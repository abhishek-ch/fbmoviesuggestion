import base64
import json
import requests
import simplejson
import urllib2
import sys
sys.path.append('/usr/local/lib/python2.7/site-packages/')
import pprint
import pandas as pd
import time
import csv
#https://code.google.com/apis/console/b/0/?noredirect&pli=1#project:371244046654:access
#http://maps.google.cn/maps/api/geocode/json?address=1600+Amphitheatre+Parkway,+Mountain+View,+CA



RESULTS = []
def loadcsv(filename):
	df = pd.read_csv(filename)
	return df

df = loadcsv("population.csv")
placecol = df["Place"]


def updateCSV(placecol):
	for state in placecol:
		state = state.replace (" ", "%20")
		url = 'http://maps.google.cn/maps/api/geocode/json?address=%s'%(state)
		print "URLRLRLL ",url
		response = urllib2.urlopen(url)
		data = json.load(response)
		lat = data["results"][0]["geometry"]["location"]["lat"]
		longi = data["results"][0]["geometry"]["location"]["lng"]
		RESULTS.append([state,lat,longi])
		print "State %s lat %s long %s "%(state,lat,longi)
		time.sleep(2)

	with open('state.csv', 'a') as fp:
		    a = csv.writer(fp, delimiter=',')
		    a.writerows(RESULTS)
		    #RESULTS[:] = []	


updateCSV(placecol)
#print df.head()    

