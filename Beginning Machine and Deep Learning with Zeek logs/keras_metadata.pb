
�proot"_tf_keras_network*�o{"name": "regression_classification_model", "trainable": true, "expects_training_arg": true, "dtype": "float32", "batch_input_shape": null, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": false, "class_name": "Functional", "config": {"name": "regression_classification_model", "trainable": true, "layers": [{"class_name": "InputLayer", "config": {"batch_input_shape": {"class_name": "__tuple__", "items": [null, 3]}, "dtype": "float32", "sparse": false, "ragged": false, "name": "classification_input"}, "name": "classification_input", "inbound_nodes": []}, {"class_name": "Dense", "config": {"name": "clf_hidden_1", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_hidden_1", "inbound_nodes": [[["classification_input", 0, 0, {}]]]}, {"class_name": "InputLayer", "config": {"batch_input_shape": {"class_name": "__tuple__", "items": [null, 1]}, "dtype": "float32", "sparse": false, "ragged": false, "name": "regression_input"}, "name": "regression_input", "inbound_nodes": []}, {"class_name": "Dropout", "config": {"name": "clf_dropout_1", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "clf_dropout_1", "inbound_nodes": [[["clf_hidden_1", 0, 0, {}]]]}, {"class_name": "Dense", "config": {"name": "reg_hidden_1", "trainable": true, "dtype": "float32", "units": 8, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "reg_hidden_1", "inbound_nodes": [[["regression_input", 0, 0, {}]]]}, {"class_name": "Dense", "config": {"name": "clf_hidden_2", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_hidden_2", "inbound_nodes": [[["clf_dropout_1", 0, 0, {}]]]}, {"class_name": "Dropout", "config": {"name": "reg_dropout_1", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "reg_dropout_1", "inbound_nodes": [[["reg_hidden_1", 0, 0, {}]]]}, {"class_name": "Dropout", "config": {"name": "clf_dropout_2", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "clf_dropout_2", "inbound_nodes": [[["clf_hidden_2", 0, 0, {}]]]}, {"class_name": "Dense", "config": {"name": "reg_hidden_2", "trainable": true, "dtype": "float32", "units": 8, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "reg_hidden_2", "inbound_nodes": [[["reg_dropout_1", 0, 0, {}]]]}, {"class_name": "Dense", "config": {"name": "clf_hidden_3", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_hidden_3", "inbound_nodes": [[["clf_dropout_2", 0, 0, {}]]]}, {"class_name": "Concatenate", "config": {"name": "concatenated_shared_layer", "trainable": true, "dtype": "float32", "axis": -1}, "name": "concatenated_shared_layer", "inbound_nodes": [[["reg_hidden_2", 0, 0, {}], ["clf_hidden_3", 0, 0, {}]]]}, {"class_name": "Dropout", "config": {"name": "reg_clf_dropout_3", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "reg_clf_dropout_3", "inbound_nodes": [[["concatenated_shared_layer", 0, 0, {}]]]}, {"class_name": "Dense", "config": {"name": "reg_output", "trainable": true, "dtype": "float32", "units": 1, "activation": "linear", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "reg_output", "inbound_nodes": [[["reg_clf_dropout_3", 0, 0, {}]]]}, {"class_name": "Dense", "config": {"name": "clf_output", "trainable": true, "dtype": "float32", "units": 1, "activation": "sigmoid", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}}, "bias_initializer": {"class_name": "Zeros", "config": {}}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_output", "inbound_nodes": [[["reg_clf_dropout_3", 0, 0, {}]]]}], "input_layers": [["regression_input", 0, 0], ["classification_input", 0, 0]], "output_layers": [["reg_output", 0, 0], ["clf_output", 0, 0]]}, "shared_object_id": 28, "input_spec": [{"class_name": "InputSpec", "config": {"dtype": null, "shape": {"class_name": "__tuple__", "items": [null, 1]}, "ndim": 2, "max_ndim": null, "min_ndim": null, "axes": {}}}, {"class_name": "InputSpec", "config": {"dtype": null, "shape": {"class_name": "__tuple__", "items": [null, 3]}, "ndim": 2, "max_ndim": null, "min_ndim": null, "axes": {}}}], "build_input_shape": [{"class_name": "TensorShape", "items": [null, 1]}, {"class_name": "TensorShape", "items": [null, 3]}], "is_graph_network": true, "full_save_spec": {"class_name": "__tuple__", "items": [[[{"class_name": "TypeSpec", "type_spec": "tf.TensorSpec", "serialized": [{"class_name": "TensorShape", "items": [null, 1]}, "float32", "regression_input"]}, {"class_name": "TypeSpec", "type_spec": "tf.TensorSpec", "serialized": [{"class_name": "TensorShape", "items": [null, 3]}, "float32", "classification_input"]}]], {}]}, "save_spec": [{"class_name": "TypeSpec", "type_spec": "tf.TensorSpec", "serialized": [{"class_name": "TensorShape", "items": [null, 1]}, "float32", "regression_input"]}, {"class_name": "TypeSpec", "type_spec": "tf.TensorSpec", "serialized": [{"class_name": "TensorShape", "items": [null, 3]}, "float32", "classification_input"]}], "keras_version": "2.12.0", "backend": "tensorflow", "model_config": {"class_name": "Functional", "config": {"name": "regression_classification_model", "trainable": true, "layers": [{"class_name": "InputLayer", "config": {"batch_input_shape": {"class_name": "__tuple__", "items": [null, 3]}, "dtype": "float32", "sparse": false, "ragged": false, "name": "classification_input"}, "name": "classification_input", "inbound_nodes": [], "shared_object_id": 0}, {"class_name": "Dense", "config": {"name": "clf_hidden_1", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 1}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 2}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_hidden_1", "inbound_nodes": [[["classification_input", 0, 0, {}]]], "shared_object_id": 3}, {"class_name": "InputLayer", "config": {"batch_input_shape": {"class_name": "__tuple__", "items": [null, 1]}, "dtype": "float32", "sparse": false, "ragged": false, "name": "regression_input"}, "name": "regression_input", "inbound_nodes": [], "shared_object_id": 4}, {"class_name": "Dropout", "config": {"name": "clf_dropout_1", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "clf_dropout_1", "inbound_nodes": [[["clf_hidden_1", 0, 0, {}]]], "shared_object_id": 5}, {"class_name": "Dense", "config": {"name": "reg_hidden_1", "trainable": true, "dtype": "float32", "units": 8, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 6}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 7}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "reg_hidden_1", "inbound_nodes": [[["regression_input", 0, 0, {}]]], "shared_object_id": 8}, {"class_name": "Dense", "config": {"name": "clf_hidden_2", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 9}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 10}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_hidden_2", "inbound_nodes": [[["clf_dropout_1", 0, 0, {}]]], "shared_object_id": 11}, {"class_name": "Dropout", "config": {"name": "reg_dropout_1", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "reg_dropout_1", "inbound_nodes": [[["reg_hidden_1", 0, 0, {}]]], "shared_object_id": 12}, {"class_name": "Dropout", "config": {"name": "clf_dropout_2", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "clf_dropout_2", "inbound_nodes": [[["clf_hidden_2", 0, 0, {}]]], "shared_object_id": 13}, {"class_name": "Dense", "config": {"name": "reg_hidden_2", "trainable": true, "dtype": "float32", "units": 8, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 14}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 15}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "reg_hidden_2", "inbound_nodes": [[["reg_dropout_1", 0, 0, {}]]], "shared_object_id": 16}, {"class_name": "Dense", "config": {"name": "clf_hidden_3", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 17}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 18}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_hidden_3", "inbound_nodes": [[["clf_dropout_2", 0, 0, {}]]], "shared_object_id": 19}, {"class_name": "Concatenate", "config": {"name": "concatenated_shared_layer", "trainable": true, "dtype": "float32", "axis": -1}, "name": "concatenated_shared_layer", "inbound_nodes": [[["reg_hidden_2", 0, 0, {}], ["clf_hidden_3", 0, 0, {}]]], "shared_object_id": 20}, {"class_name": "Dropout", "config": {"name": "reg_clf_dropout_3", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "name": "reg_clf_dropout_3", "inbound_nodes": [[["concatenated_shared_layer", 0, 0, {}]]], "shared_object_id": 21}, {"class_name": "Dense", "config": {"name": "reg_output", "trainable": true, "dtype": "float32", "units": 1, "activation": "linear", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 22}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 23}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "reg_output", "inbound_nodes": [[["reg_clf_dropout_3", 0, 0, {}]]], "shared_object_id": 24}, {"class_name": "Dense", "config": {"name": "clf_output", "trainable": true, "dtype": "float32", "units": 1, "activation": "sigmoid", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 25}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 26}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "name": "clf_output", "inbound_nodes": [[["reg_clf_dropout_3", 0, 0, {}]]], "shared_object_id": 27}], "input_layers": [["regression_input", 0, 0], ["classification_input", 0, 0]], "output_layers": [["reg_output", 0, 0], ["clf_output", 0, 0]]}}, "training_config": {"loss": {"reg_output": {"class_name": "MeanAbsoluteError", "config": {"reduction": "auto", "name": "mean_absolute_error"}, "shared_object_id": 32}, "clf_output": {"class_name": "BinaryCrossentropy", "config": {"reduction": "auto", "name": "binary_crossentropy", "from_logits": false, "label_smoothing": 0.0, "axis": -1}, "shared_object_id": 31}}, "metrics": [[{"class_name": "MeanMetricWrapper", "config": {"name": "reg_output_mean_absolute_error", "dtype": "float32", "fn": "mean_absolute_error"}, "shared_object_id": 33}], [{"class_name": "Recall", "config": {"name": "clf_output_recall", "dtype": "float32", "thresholds": null, "top_k": null, "class_id": null}, "shared_object_id": 34}]], "weighted_metrics": null, "loss_weights": {"reg_output": 1, "clf_output": 3}, "optimizer_config": {"class_name": "Custom>Adam", "config": {"name": "Adam", "weight_decay": null, "clipnorm": null, "global_clipnorm": null, "clipvalue": null, "use_ema": false, "ema_momentum": 0.99, "ema_overwrite_frequency": null, "jit_compile": false, "is_legacy_optimizer": false, "learning_rate": 0.0010000000474974513, "beta_1": 0.9, "beta_2": 0.999, "epsilon": 1e-07, "amsgrad": false}}}}2
�root.layer-0"_tf_keras_input_layer*�{"class_name": "InputLayer", "name": "classification_input", "dtype": "float32", "sparse": false, "ragged": false, "batch_input_shape": {"class_name": "__tuple__", "items": [null, 3]}, "config": {"batch_input_shape": {"class_name": "__tuple__", "items": [null, 3]}, "dtype": "float32", "sparse": false, "ragged": false, "name": "classification_input"}}2
�root.layer_with_weights-0"_tf_keras_layer*�{"name": "clf_hidden_1", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dense", "config": {"name": "clf_hidden_1", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 1}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 2}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "inbound_nodes": [[["classification_input", 0, 0, {}]]], "shared_object_id": 3, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 2, "axes": {"-1": 3}}, "shared_object_id": 35}, "build_input_shape": {"class_name": "TensorShape", "items": [null, 3]}}2
�root.layer-2"_tf_keras_input_layer*�{"class_name": "InputLayer", "name": "regression_input", "dtype": "float32", "sparse": false, "ragged": false, "batch_input_shape": {"class_name": "__tuple__", "items": [null, 1]}, "config": {"batch_input_shape": {"class_name": "__tuple__", "items": [null, 1]}, "dtype": "float32", "sparse": false, "ragged": false, "name": "regression_input"}}2
�root.layer-3"_tf_keras_layer*�{"name": "clf_dropout_1", "trainable": true, "expects_training_arg": true, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dropout", "config": {"name": "clf_dropout_1", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "inbound_nodes": [[["clf_hidden_1", 0, 0, {}]]], "shared_object_id": 5, "build_input_shape": {"class_name": "TensorShape", "items": [null, 4]}}2
�root.layer_with_weights-1"_tf_keras_layer*�{"name": "reg_hidden_1", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dense", "config": {"name": "reg_hidden_1", "trainable": true, "dtype": "float32", "units": 8, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 6}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 7}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "inbound_nodes": [[["regression_input", 0, 0, {}]]], "shared_object_id": 8, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 2, "axes": {"-1": 1}}, "shared_object_id": 36}, "build_input_shape": {"class_name": "TensorShape", "items": [null, 1]}}2
�root.layer_with_weights-2"_tf_keras_layer*�{"name": "clf_hidden_2", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dense", "config": {"name": "clf_hidden_2", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 9}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 10}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "inbound_nodes": [[["clf_dropout_1", 0, 0, {}]]], "shared_object_id": 11, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 2, "axes": {"-1": 4}}, "shared_object_id": 37}, "build_input_shape": {"class_name": "TensorShape", "items": [null, 4]}}2
�root.layer-6"_tf_keras_layer*�{"name": "reg_dropout_1", "trainable": true, "expects_training_arg": true, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dropout", "config": {"name": "reg_dropout_1", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "inbound_nodes": [[["reg_hidden_1", 0, 0, {}]]], "shared_object_id": 12, "build_input_shape": {"class_name": "TensorShape", "items": [null, 8]}}2
�root.layer-7"_tf_keras_layer*�{"name": "clf_dropout_2", "trainable": true, "expects_training_arg": true, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dropout", "config": {"name": "clf_dropout_2", "trainable": true, "dtype": "float32", "rate": 0.25, "noise_shape": null, "seed": null}, "inbound_nodes": [[["clf_hidden_2", 0, 0, {}]]], "shared_object_id": 13, "build_input_shape": {"class_name": "TensorShape", "items": [null, 4]}}2
�	root.layer_with_weights-3"_tf_keras_layer*�{"name": "reg_hidden_2", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dense", "config": {"name": "reg_hidden_2", "trainable": true, "dtype": "float32", "units": 8, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 14}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 15}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "inbound_nodes": [[["reg_dropout_1", 0, 0, {}]]], "shared_object_id": 16, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 2, "axes": {"-1": 8}}, "shared_object_id": 38}, "build_input_shape": {"class_name": "TensorShape", "items": [null, 8]}}2
�
root.layer_with_weights-4"_tf_keras_layer*�{"name": "clf_hidden_3", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dense", "config": {"name": "clf_hidden_3", "trainable": true, "dtype": "float32", "units": 4, "activation": "relu", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 17}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 18}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "inbound_nodes": [[["clf_dropout_2", 0, 0, {}]]], "shared_object_id": 19, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 2, "axes": {"-1": 4}}, "shared_object_id": 39}, "build_input_shape": {"class_name": "TensorShape", "items": [null, 4]}}2
�
�
�
�root.layer_with_weights-6"_tf_keras_layer*�{"name": "clf_output", "trainable": true, "expects_training_arg": false, "dtype": "float32", "batch_input_shape": null, "stateful": false, "must_restore_from_config": false, "preserve_input_structure_in_config": false, "autocast": true, "class_name": "Dense", "config": {"name": "clf_output", "trainable": true, "dtype": "float32", "units": 1, "activation": "sigmoid", "use_bias": true, "kernel_initializer": {"class_name": "GlorotUniform", "config": {"seed": null}, "shared_object_id": 25}, "bias_initializer": {"class_name": "Zeros", "config": {}, "shared_object_id": 26}, "kernel_regularizer": null, "bias_regularizer": null, "activity_regularizer": null, "kernel_constraint": null, "bias_constraint": null}, "inbound_nodes": [[["reg_clf_dropout_3", 0, 0, {}]]], "shared_object_id": 27, "input_spec": {"class_name": "InputSpec", "config": {"dtype": null, "shape": null, "ndim": null, "max_ndim": null, "min_ndim": 2, "axes": {"-1": 12}}, "shared_object_id": 41}, "build_input_shape": {"class_name": "TensorShape", "items": [null, 12]}}2
��root.keras_api.metrics.0"_tf_keras_metric*�{"class_name": "Mean", "name": "loss", "dtype": "float32", "config": {"name": "loss", "dtype": "float32"}, "shared_object_id": 42}2
��root.keras_api.metrics.1"_tf_keras_metric*�{"class_name": "Mean", "name": "reg_output_loss", "dtype": "float32", "config": {"name": "reg_output_loss", "dtype": "float32"}, "shared_object_id": 43}2
��root.keras_api.metrics.2"_tf_keras_metric*�{"class_name": "Mean", "name": "clf_output_loss", "dtype": "float32", "config": {"name": "clf_output_loss", "dtype": "float32"}, "shared_object_id": 44}2
��root.keras_api.metrics.3"_tf_keras_metric*�{"class_name": "MeanMetricWrapper", "name": "reg_output_mean_absolute_error", "dtype": "float32", "config": {"name": "reg_output_mean_absolute_error", "dtype": "float32", "fn": "mean_absolute_error"}, "shared_object_id": 33}2
��root.keras_api.metrics.4"_tf_keras_metric*�{"class_name": "Recall", "name": "clf_output_recall", "dtype": "float32", "config": {"name": "clf_output_recall", "dtype": "float32", "thresholds": null, "top_k": null, "class_id": null}, "shared_object_id": 34}2