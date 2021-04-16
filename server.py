#!/usr/bin/env python3

'''
 This is all part of my codebascis training
 I did not complete the web application side of it
 Also I ran into an error when viewing the page to make the prediction. 
 Will deal with that another day. 
 Good part is I know the predictions works as can been seen from running util.py
 
'''


import util

from flask import Flask, request, jsonify
app = Flask(__name__)


@app.route('/')
def get_location_names():
	response = jsonify({
		'locations' : util.get_location_names()	
	})
	response.headers.add('Access-Control-Allow-Origin', '*')
	
	return response
    


@app.route('/home_price_predictor', methods=["POST"])
def home_price_predictor():
	# Reading the response data
	if request.method == 'POST':
		total_sqft = float(request.form['total_sqft'])
		location = request.form['location']
		bedrooms = int(request.form['bedrooms'])
		bath = int(request.form['bath'])
	
		response = jsonify({
				'estimated_price' : util.get_estimaed_price(location, total_sqft, bath, bedrooms)
			})
	
		return response
	else:
		return "A problem occurred"

if __name__ == '__main__':
	print('Starting python flask server for home price prediction')
	util.load_saved_artifacts()
	app.run(debug=True)
	
	
	
	
	
	'''
	References:
	https://www.youtube.com/watch?v=Q5JyawS8f5Q&list=PLeo1K3hjS3uvCeTYTeyfe0-rN5r8zn9rw&index=24
	https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Access-Control-Allow-Origin
	
	
	'''
