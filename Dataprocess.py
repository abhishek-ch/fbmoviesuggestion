import csv

class DataCreator(object):


	def readMoviescsv(self):
		movieDictionary = {}
		cr = csv.reader(open("movie_details_updated.csv","rb"))
		for row in cr:
			key = row[0]
			movieDictionary[row[0]] = [row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10],row[11]]
			print key
		return movieDictionary

	def test_ascii(struni):
		strasc=unicodedata.normalize('NFD', struni).encode('ascii','replace')
		if len(struni)==len(strasc): 
			return True 
		else: 
			return False

	def createAbsoluteCSVDB(self,movieDictionary):
		RESULTS = []
		RESULTS.append(["User","Movie","Year","Released","Genre","Director","Poster","imdbRating","imdbVotes","imdbID","tomatoRating","tomatoUserReviews","BoxOffice"])
		cr = csv.reader(open("outing.csv","rb"))
		for user in cr:
			#print user[0]			
			row =	movieDictionary.get(user[1], None)
			#print row[10]
			if(row != None):	
				RESULTS.append([user[0],user[1],row[0],row[1],row[2],row[3],row[4],row[5],row[6],row[7],row[8],row[9],row[10]])
			else:
				RESULTS.append([user[0],user[1]])

		#write contents into a single csv file
		with open('output.csv', 'wb') as fp:
			    a = csv.writer(fp, delimiter=',')
			    a.writerows(RESULTS)
			    #for rows in RESULTS:			    	
			    #	a.writerow(row)

		return RESULTS			


						

dc = DataCreator()
movieDictionary = dc.readMoviescsv()
output = dc.createAbsoluteCSVDB(movieDictionary)
#for items in output:
#	print items