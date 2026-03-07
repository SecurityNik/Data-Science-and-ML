'''

## "Welcome to the world of AI" 
#### Putting it all together. Building and training fully functional Decoder-Only transformer .

Ok, in the previous two posts, we built a Decoder Only transformer using pure NumPy. We then use PyTorch to build a transformer. This was however done in Jupyter notebook. Let's write a real script that we can run on any text based dataset to generate similar text. 

I will stick with my baby names dataset to keep this simple

References:
https://docs.python.org/3/library/argparse.html

$ clear && python3 baby_name_gpt.py --filename names.txt --d_model=32 --n_heads=4 --n_layers=2 --epochs=10000 --temperature=1.3 --top_p=0.90

'''

#baby_name_gpt.py

import argparse
import torch
import torch.nn as nn
import torch.nn.functional as F

# Set the seed for reproducibility
torch.manual_seed(42)

CONTEXT_WINDOW_LENGTH = 16  # Max tokens the model can process at once

# Setup the argument parser
arg_parser = argparse.ArgumentParser(prog='gpt.py', description='A mini GPT', epilog='www.securitynik.com')

# Add arguments
arg_parser.add_argument('-f', '--filename', required=True, help='/path/to/some_file with text to learn from')
arg_parser.add_argument('-d', '--d_model', type=int,  help='Embedding dimension of the model')
arg_parser.add_argument('-n', '--n_heads', type=int, help='Number of heads')
arg_parser.add_argument('-l', '--n_layers', type=int, help='Number of layers')
arg_parser.add_argument('-e', '--epochs', type=int, help='Number of training ')
arg_parser.add_argument('-b', '--batch_size', type=int, help='Batch size')
arg_parser.add_argument('-t', '--temperature', type=float, help='temperature')
arg_parser.add_argument('-k', '--top_k', type=int, help='top_k')
arg_parser.add_argument('-p', '--top_p', type=float, help='top_p')

args = arg_parser.parse_args()

# Setup a function to read the data
def get_data(input_file=None):
    print(f'🚀 Getting data ...')
    try:
        with open(file=input_file, mode='r') as fp:
            data = fp.read()
            print(f'✅ Successfully read: {len(data)} bytes of data.')
            return data
    except Exception as e:
        print(f'Error encountered: {e}')


# Tokenize the data:
def tokenizer(data=None):
    chars = sorted(list(set(data)))
    print(f'Chars: {repr("".join(chars))}')

    vocab_size = len(chars)
    print(f'✅ Vocab size: {vocab_size} tokens')

    # Encode the chars to numbers
    stoi = { ch:idx for idx,ch in enumerate(chars)}

    # Decode
    itos = {idx:ch for ch,idx in stoi.items()}
    
    return stoi, itos, int(vocab_size)


# Perform the encoding of text
def encode_data(tokenizer=None, data=None):
    print(f'🚀 Encoding the data ...')
    return torch.tensor([ tokenizer.get(ch) for ch in data ], dtype=torch.long)


# Perform the decoding of numbers
def decode_tokens(tokenizer=None, data=None):
    print(f'🚀 Decoding the data ...')
    return ''.join([ tokenizer.get(i) for i in data ])


# Split the data into train and test sets
def train_test_split(tokens=None):
    print(f'🚀 Splitting into train and test sets ...')
    # Use 90% for training and 10 for test
    n = int(len(tokens) * 0.9)
    X_train = tokens[:n]
    X_test = tokens[n:]
    
    print(f'✅ X_train.shape: {X_train.shape} | X_test.shape: {X_test.shape} ...')

    return X_train, X_test


# Generate batches fo data
def generate_batch(X_train=None, X_test=None, split='train',  batch_size=32):

    X = X_train if split=='train' else X_test
    idx = torch.randint(low=0, high=len(X) - CONTEXT_WINDOW_LENGTH, size=(batch_size,))

    X_batch = torch.stack(tensors=[ X[i:i + CONTEXT_WINDOW_LENGTH] for i in idx], dim=0)

    y_batch = torch.stack(tensors=[ X[i+1:i + CONTEXT_WINDOW_LENGTH + 1] for i in idx], dim=0)
    
    return (X_batch, y_batch)


# Create the GPT Embeddings
class GPTEmbeddings(nn.Module):
    def __init__(self, vocab_size=0, d_model=32):
        super(GPTEmbeddings, self).__init__()

        #self.device = device

        # Token embeddings
        self.tok_embeddings = nn.Embedding(num_embeddings=vocab_size, embedding_dim=d_model)

        # Positional embeddings
        self.pos_embeddings = nn.Embedding(num_embeddings=CONTEXT_WINDOW_LENGTH, embedding_dim=d_model)

    def forward(self, x):
        #x: (B, T)
        # print(f'==[DEBUG]== {x.size()}')
        B, T = x.size()

        # Setup positions
        positions = torch.arange(T)
        pos_emb = self.pos_embeddings(positions) # (B, T, D)
        tok_emb = self.tok_embeddings(x)    # (B, T, D)

        return pos_emb + tok_emb # (B, T, D)


# Setup the MultiHead attention
class MultiHeadAttention(nn.Module):
    def __init__(self, d_model=32, n_heads=4):
        super(MultiHeadAttention, self).__init__()

        # Verify the embedding dimension size vs n_heads
        assert d_model % n_heads == 0, f'd_model: {d_model} is not divisible by n_heads: {n_heads}'

        self.d_model = d_model
        self.n_heads = n_heads
        self.head_dim = d_model // n_heads

        # Fused QKV Projection matrix
        self.qkv_proj = nn.Linear(in_features=d_model, out_features=3*d_model, bias=False)

        # Output projection
        self.out_proj = nn.Linear(in_features=d_model, out_features=d_model, bias=False)

    def forward(self, x):
        #x: (B, T, D)
        B, T, D = x.size()

        qkv = self.qkv_proj(x) # ( B, T, D*3)

        # Reshape to separate heads
        qkv = qkv.view(B, T, 3, self.n_heads, self.head_dim)
        qkv = qkv.permute(2,0,3,1,4) # (3, B, n_heads, T, head_dim)

        # Create the Q K V
        Q, K, V = qkv[0], qkv[1], qkv[2] 

        # Leverage Flash compatible attention
        attn_out = F.scaled_dot_product_attention(
            query=Q, key=K, value=V,
            attn_mask = None,
            dropout_p = 0.0,
            is_causal = True,
        ) # (B, n_heads, T, head_dim)

        # Fuse/merge the heads back together
        attn_out = attn_out.transpose(1, 2).contiguous()

        # Reshape for final output
        attn_out = attn_out.view(B, T, D)

        return self.out_proj(attn_out)



# Setup the FFN
class FFN(nn.Module):
    def __init__(self, d_model=32):
        super(FFN, self).__init__()

        # This /3 has to do with the choice of SwiGLU activation rather than ReLU or GELU and the need to control model representation capacity while maintaing the computation similar to GPT with 4*d_model
        hidden_dim = int(8 * d_model / 3)

        # Setup the parallel projections
        # This also has to do with SwiGLU
        self.ln1 = nn.Linear(in_features=d_model, out_features=hidden_dim, bias=False)
        self.ln2 = nn.Linear(in_features=d_model, out_features=hidden_dim, bias=False)

        # Setup the output projection
        self.ln3 = nn.Linear(in_features=hidden_dim, out_features=d_model, bias=False)
        
    def forward(self, x):
        # x (B, T, D)
        x = F.silu(self.ln1(x) * self.ln2(x))
        x = self.ln3(x)
        return x


# GPT Decoder Block
class DecoderBlock(nn.Module):
    def __init__(self, d_model=32, n_heads=4 ):
        super(DecoderBlock, self).__init__()

        # Setup the norm
        self.norm1 = nn.RMSNorm(normalized_shape=d_model)
        self.mha = MultiHeadAttention(d_model=d_model, n_heads=n_heads)

        self.norm2 = nn.RMSNorm(normalized_shape=d_model)
        self.ffn = FFN(d_model=d_model)


    def forward(self, x):
        # In this case, we are using the pre-norm attention
        # Applying the add and norm before going into self-attention
        x = x + self.mha(self.norm1(x))

        # Apply the second add and norm before going into the FFN
        x = x + self.ffn(self.norm2(x))

        return x


# Setup the GPT
class GPT(nn.Module):
    def __init__(self, vocab_size=0, d_model=32, n_heads=4, n_layers=4):
        super(GPT, self).__init__()

        self.embeddings = GPTEmbeddings(vocab_size=vocab_size, d_model=d_model)

        self.blocks = nn.ModuleList(
            [  DecoderBlock(d_model=d_model, n_heads=n_heads) for _ in range(n_layers) ]
            )

        # Final layernorm before going into the language head
        self.norm = nn.RMSNorm(normalized_shape=d_model)    

        # LM Head
        self.lm_head = nn.Linear(in_features=d_model, out_features=vocab_size, bias=False)

        # Take advantage of weight tying
        self.lm_head.weight = self.embeddings.tok_embeddings.weight    

        # This is to scale the weights, if not the model starts with a very high loss
        self.apply(self._init_weights)


    # Define the weights
    def _init_weights(self, module):
        if isinstance(module, nn.Linear):
            nn.init.normal_(module.weight, mean=0.0, std=0.02)

            if module.bias is not None:
                nn.init.zeros_(module.bias)
        
        elif isinstance(module, nn.Embedding):
            nn.init.normal_(module.weight, mean=0, std=0.02)


    def forward(self, x):
        x = self.embeddings(x)

        for block in self.blocks:
           x = block(x)

        # Final norm before going into the language head
        x = self.norm(x)

        # Get the logits
        logits = self.lm_head(x)

        return logits

    
    # Generate sample names
    def _generate(self, idx, max_new_tokens=10, temperature=1, new_line_token: torch.long = 0, top_k=None, top_p=None ):
        # idx: (B, T) starting token indices 
        if temperature <= 0:
            temperature = 0.1

        print(f'==[DEBUG]== Generating ... ')
        # Put the model in eval model
        self.eval()

        for _ in range(max_new_tokens):
            # First crop the context to context window length if needed
            idx_cond = idx[:, -CONTEXT_WINDOW_LENGTH: ]

            # Forward pass to get the logits
            logits = self(idx_cond) # (B, T, vocab_size)

            # Take the logits for the final time sep
            logits = logits[:, -1, :]   # (B, vocab_size)

            # Apply temperature
            logits = logits / temperature

            # Extract the top_k probabilities
            # set everything else to -inf
            if top_k is not None:
                v, _ = torch.topk(logits, top_k)
                logits[logits < v[:, [-1]]] = float('-inf')

            # Set top_p
            if top_p is not None:
                sorted_logits, sorted_indices = torch.sort(logits, descending=True)
                sorted_probs = F.softmax(sorted_logits, dim=-1)
                cumulative_probs = torch.cumsum(sorted_probs, dim=-1)

                sorted_indices_to_remove = cumulative_probs > top_p
                sorted_indices_to_remove[..., 1:] = sorted_indices_to_remove[..., :-1].clone()
                sorted_indices_to_remove[..., 0] = False

                indices_to_remove = sorted_indices_to_remove.scatter(1, sorted_indices, sorted_indices_to_remove )
                logits[indices_to_remove] = float('-inf')

            
            # Convert the logits to probabilities
            probs = F.softmax(logits, dim=-1)

            # Based on the probabilities, sample the next token
            next_token = torch.multinomial(input=probs, num_samples=1, replacement=True) # (B, 1)
            
            # Append to the existing sequence
            idx = torch.cat((idx, next_token), dim=-1)

            # Stop if new line is generated
            #if (next_token == new_line_token).all():
            #    break
        
        return idx



# Configure the optimizer for weight decaying and parameter grouping
def configure_optimizer(model=None, weight_decay=0.1, learning_rate=3e-3, betas=(0.9, 0.95)):

    # Setup two sets to track decay
    decay_params = []
    no_decay_params = []

    # for module in model.modules():
    for name, param in model.named_parameters():
        if not param.requires_grad:
            continue
        
        # Apply weight decay only to linear weights
        if name.endswith('weight') and 'norm' not in name and 'embedding' not in name:
            decay_params.append(param)
        else:
            no_decay_params.append(param)

    # Remove duplicates
    decay_ids = { id(p):p for p in decay_params }
    no_decay_ids = { id(p):p for p in no_decay_params }
    assert set(decay_ids).isdisjoint(set(no_decay_ids))
    
    # Setup our optimizer groups
    optim_groups = [
        { 'params' : decay_params, 'weight_decay' : weight_decay },
        # No decaying these parameters
        { 'params' : no_decay_params, 'weight_decay' : 0.0 }
    ]

    optimizer = torch.optim.AdamW(
        params = optim_groups,
        lr = learning_rate,
        betas = betas
    )
    return optimizer


# Setup the evaluation loop
# Disable gradient tracking
@torch.no_grad()
def estimate_loss(model, X_train=None, X_test=None, vocab_size=None, batch_size=32, eval_iters=50):
    # put the model in eval mode
    model.eval()

    losses = { 'train' : 0, 'test' : 0 }
    
    for split in ['train', 'test']:
        total_loss = 0.0

        for _ in range(eval_iters):
            xb, yb = generate_batch(X_train=X_train, X_test=X_test, batch_size=batch_size)

            logits = model(xb)

            loss = F.cross_entropy(
              input=logits.view(-1, vocab_size), target=yb.view(-1) 
              )
            
            # Track the loss
            total_loss += loss.item()
        
        losses[split] = total_loss / eval_iters 

    model.train()
    return losses



# Define the training loop
def train(model=None, optimizer=None, X_train=None, X_test=None, vocab_size=None, batch_size=64, epochs=10, eval_interval=10, grad_clip=1.0):
    print(f'✅ Beginning training ...')

    model.train()
    for epoch in range(epochs):

        # Evaluate the model periodically
        if epoch % eval_interval == 0:
            losses = estimate_loss(model=model, X_train=X_train, X_test=X_test, vocab_size=vocab_size, batch_size=batch_size)
                        
            print(f'Epoch: {epoch+1} | loss: {losses}')

        # Get Batch
        xb, yb = generate_batch(X_train=X_train, X_test=X_test, split='train')

        # Forward to get the logits
        logits = model(xb)

        # Calculate the loss
        loss = F.cross_entropy(
            input=logits.view(-1, vocab_size), target=yb.view(-1)
            )
        
        # Back propagate
        loss.backward()

        # Clip the gradients
        torch.nn.utils.clip_grad_norm_(model.parameters(), grad_clip)

        # Update the parameters
        optimizer.step()

    # Return the model
    return model


def main():
    print(f'🚀 Launching {__file__}')

    # Read the arguments
    file_name = args.filename
    d_model = args.d_model if args.d_model else 32 
    n_heads = args.n_heads if args.n_heads else 4
    n_layers = args.n_layers if args.n_layers else 4
    epochs = args.epochs if args.epochs else 10
    batch_size = args.batch_size if args.batch_size else 64
    temperature = args.temperature if args.temperature else 0.1
    top_k = args.top_k if args.top_k else None
    top_p = args.top_p if args.top_p else None
    #print(f'==[DEBUG]== filename: {file_name} | d_model: {d_model} | n_heads: {n_heads}')

    data = get_data(file_name)
    
    stoi, itos, vocab_size = tokenizer(data=data)
    tokens_encoded = encode_data(tokenizer=stoi, data=data)
    X_train, X_test = train_test_split(tokens=tokens_encoded)
    
    # Setup the model
    model = GPT(vocab_size=vocab_size, d_model=d_model, n_heads=n_heads)

    # get the optimizer
    optimizer = configure_optimizer(model=model, weight_decay=0.1, learning_rate=3e-4)    

    model = train(model=model, optimizer=optimizer, X_train=X_train, X_test=X_test, vocab_size=vocab_size, batch_size=64, epochs=epochs)

    # Generate samples starting from the new line char
    new_line_token = stoi['\n']
    start_token = torch.tensor([[new_line_token]], dtype=torch.long)

    generated = model._generate(idx=start_token, new_line_token=new_line_token, max_new_tokens=50)

    name = ''.join([ itos[i.item()] for i in generated[0] ])
    print(f'{name}')


if __name__ == '__main__':
    main()