#!/usr/bin/env python3

#!/usr/bin/env python3

'''
 This is all part of my codebascis training
 I did not complete the web application side of it
 Also I ran into an error when viewing the page to make the prediction. 
 Will deal with that another day. 
 Good part is I know the predictions works as can been seen from below 
'''



import pickle
import json
import numpy as np



# Define 3 global variables
locations = None
data_columns = None
model = None

# This function does the predictions
# I basically copying this from the notebook code.
def get_estimated_price(location, total_sqft, bath, bedrooms):
	global model
	
	try:
		location_index = data_columns.index(location.lower())	
		print('Location of location_index is: {}'.format(location_index))
	except:
		location_index = -1
		
	x = np.zeros(len(data_columns))
	x[0] = total_sqft
	x[1] = bath
	x[2] = bedrooms
	
	if location_index >= 0:
		x[location_index] = 1
	
	print('x: {}'.format(x))

	# Make a prediction	
	return round(model.predict([x])[0],2)
	
# Get the location names
def get_location_names():
	#print('Getting location names ...')
	#print(locations)
	return locations


def load_saved_artifacts():
	print("Loading saved artifacts ... ")
	global data_columns
	global locations
	global model
	
	# Open the columns json file
	with open('artifacts/bangalore_house_prices_columns.json', 'r') as columnsFile:
		data_columns = json.load(columnsFile)['data_columns']
		locations = data_columns[3:]
	
	#print(locations)
	
	# Open the saved model
	with open('artifacts/lr_model_bangalore_housing.pkl', 'rb') as pklFile:
		model = pickle.load(pklFile)

	print("Finished loading saved artifacts ... ")


if __name__ == '__main__':
	load_saved_artifacts()
	print(get_location_names())
	
	# Making some predictions
	print(get_estimated_price('location_6th Phase JP Nagar',1000,2,3))
	print(get_estimated_price('location_sarjapur  road',1000,2,3))
	print(get_estimated_price('location_old airport road',1000,2,3))
	print(get_estimated_price('location_yeshwanthpur',1000,2,3))
	



