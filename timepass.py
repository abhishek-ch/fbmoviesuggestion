#http://gedas.bizhat.com/dist.htm
#https://www.bionicspirit.com/blog/2012/01/16/cosine-similarity-euclidean-distance.html
#http://guidetodatamining.com/guide/ch2/DataMining-ch2.pdf
#http://www.slideshare.net/marcelcaraciolo/crab-a-python-framework-for-building-recommender-systems
#https://github.com/marcelcaraciolo/crab/blob/master/crab/tests/test_recommender.py
#https://github.com/ocelma/python-recsys

import unittest
import sys
from math import sqrt
from operator import itemgetter

from scipy.spatial import distance


users = {"Angelica": {"Blues Traveler": 3.5, "Broken Bells": 2.0,
                      "Norah Jones": 4.5, "Phoenix": 5.0,
                      "Slightly Stoopid": 1.5,
                      "The Strokes": 2.5, "Vampire Weekend": 2.0},
         "Bill": {"Blues Traveler": 2.0, "Broken Bells": 3.5,
                  "Deadmau5": 4.0, "Phoenix": 2.0,
                  "Slightly Stoopid": 3.5, "Vampire Weekend": 3.0},
         "Chan": {"Blues Traveler": 5.0, "Broken Bells": 1.0,
                  "Deadmau5": 1.0, "Norah Jones": 3.0,
                  "Phoenix": 5, "Slightly Stoopid": 1.0},
         "Dan": {"Blues Traveler": 3.0, "Broken Bells": 4.0,
                 "Deadmau5": 4.5, "Phoenix": 3.0,
                 "Slightly Stoopid": 4.5, "The Strokes": 4.0,
                 "Vampire Weekend": 2.0},
         "Hailey": {"Broken Bells": 4.0, "Deadmau5": 1.0,
                    "Norah Jones": 4.0, "The Strokes": 4.0,
                    "Vampire Weekend": 1.0},
         "Jordyn": {"Broken Bells": 4.5, "Deadmau5": 4.0, "Norah Jones": 5.0,
                    "Phoenix": 5.0, "Slightly Stoopid": 4.5,
                    "The Strokes": 4.0, "Vampire Weekend": 4.0},
         "Sam": {"Blues Traveler": 5.0, "Broken Bells": 2.0,
                 "Norah Jones": 3.0, "Phoenix": 5.0,
                 "Slightly Stoopid": 4.0, "The Strokes": 5.0},
         "Veronica": {"Blues Traveler": 3.0, "Norah Jones": 5.0,
                      "Phoenix": 4.0, "Slightly Stoopid": 2.5,
                      "The Strokes": 3.0}}


class Distance(object):

    def euclideanDist(self, user1, user2):
        return distance.euclidean(user1, user2)

    def manhattan(self, rating1, rating2):
        """Computes the Manhattan distance. Both rating1 and rating2 are
        dictionaries of the form
        {'The Strokes': 3.0, 'Slightly Stoopid': 2.5 ..."""

        distance = 0
        for key in rating1:
            if key in rating2:
                distance += abs(rating1[key] - rating2[key])
        return distance

    def findNearestNeighbour(self, user1, users):
        # sort all the values
        distDic = []
        for key in users:
            if(key != user1):
                distance = self.manhattan(users[user1], users[key])                
                distDic.append((distance, key))
        distDic.sort()
        return distDic

    def recommend(self, search, users):
        # recommend the albums best possible for next best user choosed
        nearest = dist.findNearestNeighbour(search, users)[0][1]
        print " Nearest user %s" % users[nearest]
        recommend = []

        mainUser = users[search]
        nearestUser = users[nearest]
        for key in nearestUser:
            if not key in mainUser:
                recommend.append((key, nearestUser[key]))

        return sorted(recommend, key=itemgetter(1))


dist = Distance()
# print dist.euclideanDist(users["Hailey"].values(), users["Jordyn"].values())

print users['Angelica']
print "FINAL %s" % dist.recommend('Angelica', users)


class Corelation(object):


	def pearson(self, x ,y):
		sum_xy = 0
		divide_xy = 0
		sum_x = 0
		sum_y = 0
		square_x = 0
		square_y = 0
		n = 0

		second = 0
		third = 0
		fourth = 0
		for key in x:
			if key in y:
				n += 1
				sum_xy += x[key] * y[key]
				sum_x += x[key]
				sum_y += y[key]
				square_x += x[key] ** 2
				square_y += y[key] ** 2

				

		second = sum_x * sum_y /n		
		denominator = sqrt(square_x - (sum_x ** 2)/n) * sqrt(square_y - (sum_y ** 2)/n)

		if(denominator == 0):
			return 0
		else:	 
			return (sum_xy - second)/denominator
	
cor = Corelation()
print cor.pearson(users['Angelica'],users['Hailey'])

