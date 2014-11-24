import csv
import unicodedata 
import urllib2
import json
import pprint

movieList = []
RESULTS = []
RESULTS.append(["MOVIE","Year","Released","Genre","Director","Poster","imdbRating","imdbVotes","imdbID","tomatoRating","tomatoUserReviews","BoxOffice"])
#--------------------------------------------------------------------
def test_ascii(struni): 
	strasc=unicodedata.normalize('NFD', struni).encode('ascii','replace')
	if len(struni)==len(strasc): 
		return True 
	else: 
		return False 
#----------------------------------------------------------------------

#---------------------------------------------------------------------
def whatisthis(s):
    if isinstance(s, str):
        return "ordinary string"
    elif isinstance(s, unicode):
        return "unicode string"
    else:
        return "not a string"
#----------------------------------------------------------------------

#----------------------------------------------------------------------
with open('name_movie.csv', 'rU') as f:
	reader = csv.reader(f)
	for row in reader:
		name = row[1]
		try:
			if(test_ascii(name.decode('utf8')) == True):
				movieList.append(name)
			    	
		except UnicodeDecodeError, e:
			print e 		
#-----------------------------------------------------------------

print "length %s "%(len(movieList))
#Avail only unique movies in the list
movieList = list(set(movieList))

print "New %s "%(len(movieList))

start = False

for movie in movieList:

	name = movie.replace(' ','+').strip()
	print "Movie %s "%name
	try:
		proxy_handler = urllib2.ProxyHandler({})
		opener = urllib2.build_opener(proxy_handler)

		json_data=opener.open('http://www.omdbapi.com/?t=%s&y=&r=json&tomatoes=true'%(name))
		data = json.load(json_data)
		pprint.pprint(data)
		if(data['Response'] == "True"):
			RESULTS.append([name,data['Year'].encode('utf8'),data['Released'].encode('utf8'),data['Genre'].encode('utf8'),data['Director'].encode('utf8'),data['Poster'].encode('utf8'),data['imdbRating'].encode('utf8'),data['imdbVotes'].encode('utf8'),data['imdbID'].encode('utf8'),data['tomatoRating'].encode('utf8'),data['tomatoUserReviews'].encode('utf8'),data['BoxOffice'].encode('utf8')]);
		else:
			RESULTS.append([name,"N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A","N/A"]);
		json_data.close()		
					
		with open('movie_details2.csv', 'a') as fp:
		    a = csv.writer(fp, delimiter=',')
		    a.writerows(RESULTS)
		    RESULTS[:] = []
	except (urllib2.URLError,ValueError), e:
		print "name %s error %s "%(name,e) 	






