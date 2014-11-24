#http://nbviewer.ipython.org/github/furukama/Mining-the-Social-Web-2nd-Edition/blob/master/ipynb/Chapter%202%20-%20Mining%20Facebook.ipynb
#http://www.serpentine.com/wordpress/wp-content/uploads/2006/12/slope_one.py.txt
#https://developers.facebook.com/docs/graph-api/reference/v2.2/user
#http://nbviewer.ipython.org/gist/glamp/20a18d52c539b87de2af

import requests
import json
import facebook
import csv
from pprint import pprint
# pip install prettytable
from prettytable import PrettyTable
from collections import Counter
import urllib2

access_token = "XXx"
url = "https://graph.facebook.com/me?access_token=%s"

#response = requests.get(url%(access_token))
#fb_data = json.loads(response.text)
#print fb_data



graph = facebook.GraphAPI(access_token)
profile = graph.get_object("me")


friends = graph.get_connections("me", 'friends')['data']
friendValue = ""
RESULTS = []
i = 0
RESULTS.append(["NAME","MOVIE","Year","Released","Genre","Director","Poster","imdbRating","imdbVotes","imdbID","tomatoRating","tomatoUserReviews","BoxOffice"])
for friend  in friends:

	name = friend['name'].encode('utf8')
	allLikes = graph.get_connections(friend['id'], "movies")['data']
	for like in allLikes:

		if(like['category'] == 'Movie'):
			i += 1

			friendValue = like['name'].encode('utf8')
			movieName = friendValue
			friendValue = friendValue.replace(' ','+').strip()
			json_data=urllib2.urlopen('http://www.omdbapi.com/?t=%s&y=&plot=short&r=json&tomatoes=true'%(friendValue))
			data = json.load(json_data)
			pprint(data)

			
			#pprint(data['oiopp'])
			if(data['Response'] == "True"):
				RESULTS.append([name,movieName,data['Year'].encode('utf8'),data['Released'].encode('utf8'),data['Genre'].encode('utf8'),data['Director'].encode('utf8'),data['Poster'].encode('utf8'),data['imdbRating'].encode('utf8'),data['imdbVotes'].encode('utf8'),data['imdbID'].encode('utf8'),data['tomatoRating'].encode('utf8'),data['tomatoUserReviews'].encode('utf8'),data['BoxOffice'].encode('utf8')]);	
			else:
				RESULTS.append([name,movieName,"N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A"]);	
			json_data.close()
			#print "Friend %s - %s"%(friendValue,name)
			with open('movie_details.csv', 'a') as fp:
			    a = csv.writer(fp, delimiter=',')
			    a.writerows(RESULTS)
			    RESULTS[:] = []
	

	friendValue = ""







