# http://nbviewer.ipython.org/gist/glamp/20a18d52c539b87de2af
#http://www.datarobot.com/blog/multiple-regression-using-statsmodels/

import numpy as np
import pylab as pl
import pandas as pd
from collections import Counter
from collections import OrderedDict
import operator
import random
import math
from scipy.spatial import distance
from pandas.stats.api import ols
import statsmodels.formula.api as sm



class CSVLoader(object):

    file = ""

    def __init__(self, file):
        self.file = file

    def loadcsv(self):
        df = pd.read_csv(self.file)
        return df


def percentage1(part, whole):
    return 100 * float(part) / float(whole)


def percentage2(percent, whole):
    return (percent * whole) / 100.0



class FindDistance(object):

    df = ""
    df2 = ""

    def __init__(self, df, df2):
        self.df = df
        self.df2 = df2

    def calculate_similarity(self, movie1, movie2):
        pass
        #ALL_FEATURES = self.df["Movie"]
        # print ALL_FEATURES

    '''
		It cleanse the data with some ineresting facts
		It tries to determine a NA values in a cell

		It finally uses lineare regression to find the votes but ratings are based on Mathematical formula.

		If frequency of movie in the movie list is more that does mean more user liked it so naturally it must
		be high 

	'''

    def updateNADataFrame(self, movieFrequency):

        movieFrequency = sorted(
            movieFrequency.items(), key=operator.itemgetter(1), reverse=True)

        movieFrequency = OrderedDict(movieFrequency)

        estimdbRatings = 8.3
        estrottenratings = 8.3
        estimdbVotes = 143000
        estrottenvotes = 90034
        maxPoint = movieFrequency.values()[0]

        for index, row in df2.iterrows():
            #df.loc[index, "A"] = "I am working! {}".format(row["B"])
            imdbRating = df2.loc[index, "imdbRating"]
            tomatoRating = df2.loc[index, "tomatoRating"]
            imdbVotes = df2.loc[index, "imdbVotes"]
            tomatoUserReviews = df2.loc[index, "tomatoUserReviews"]

            if math.isnan(imdbRating) == True:
                movie = df2.loc[index, "MOVIE"]
                # find the frequency of the current movie

                currMovieFreq = movieFrequency[movie]
                innerperc = int(round(percentage1(currMovieFreq, maxPoint)))
                percRating = percentage2(innerperc, 3.3)

                newRating = round(percRating + 6.1, 1)
                self.df2.loc[index, "imdbRating"] = newRating
                self.df2.loc[index, "tomatoRating"] = newRating

                result = sm.ols(
                    formula="tomatoUserReviews ~ imdbRating + tomatoRating + I(genre1 ** 1.0) +I(genre2 ** 1.0)+I(genre3 ** 4.0)", data=df2).fit()
                pretomatoRating = result.predict(
                    pd.DataFrame({'imdbRating': [newRating], 'tomatoRating': [newRating],'genre1':[0],'genre2':[0],'genre3':[0]}))
                pretomatoRating = int(round(pretomatoRating))
                if pretomatoRating < 0:
                    pretomatoRating = 10000

                self.df2.loc[index, "tomatoUserReviews"] = pretomatoRating

                result1 = sm.ols(
                    formula="imdbVotes ~ imdbRating + tomatoRating + tomatoUserReviews+ I(genre1 ** 1.0) +I(genre2 ** 1.0)+I(genre3 ** 4.0)", data=df2).fit()
                preimdbVotes = result1.predict(pd.DataFrame({'imdbRating': [
                                               newRating], 'tomatoRating': [newRating], 'tomatoUserReviews': [pretomatoRating],
                                               'genre1':[0],'genre2':[0],'genre3':[0]}))
                preimdbVotes = int(round(preimdbVotes))
                if preimdbVotes < 0:
                    preimdbVotes = 24000

                self.df2.loc[index, "imdbVotes"] = preimdbVotes

                print "rating %s imdb %s rotten %s ** Movies %s " % (newRating, preimdbVotes, pretomatoRating, movie)

            df2.tomatoRating.fillna(
                round(random.uniform(5.5, 7.0), 1), inplace=True)
            df2.imdbRating.fillna(
                round(random.uniform(4.2, 7.0), 1), inplace=True)
            df2.tomatoUserReviews.fillna(
                random.randint(5000, 10000), inplace=True)
            df2.imdbVotes.fillna(random.randint(8000, 12000), inplace=True)
            df2.Genre.fillna("-", inplace=True)

            df2.to_csv("updated.csv", sep=',')



    '''
		This method is used for extracting recommended movies for a user
		1. Get all the movies liked by the user @genreList
		2. Based on 1, it fetches all the Genre of movies, user is interested in @userGenreList
		3. Find the frequency of eah Genre and selected the top 2 Genre among that
		4. Find all the movies among total facebook liked movies fall under top 2 genres
		5. Cleaned the data frame with NA values
	'''

    def restructureGenre(self):

        mapval = {'Sci-Fi':1, 'Crime':2, 'Romance':3, 'Animation':4, 'Music':5, 'Adult':6, 'Comedy':7, 'War':8, 'NO':9, 'Horror':10, 'Film-Noir':11, 'Western':12,
         'News':13, 'Reality-TV':14, 'Thriller':15, 'Adventure':16,
         'Mystery':17, 'Short':18, 'Talk-Show':19, 'Drama':20, 'Action':21, 'Documentary':22, 'Musical':23,
          'History':24, 'Family':25, 'Fantasy':26, 'Sport':27, 'Biography':28,'NO':0}

        userGenreList = []
       
        df2.Genre.fillna("NO", inplace=True)

        for index, row in df2.iterrows():
            genre = df2.loc[index, "Genre"]
            val = [x.strip() for x in genre.split(', ')]
           # print "valvalvalval",len(val)
            i = 0
            for single in val:
                if i == 0:
                    self.df2.loc[index, "genre1"] = mapval[single]
                elif i == 1:
                    self.df2.loc[index, "genre2"] = mapval[single]
                elif i == 2:
                    self.df2.loc[index, "genre3"] = mapval[single]
                i += 1
            
        df2.genre1.fillna(0, inplace=True)
        df2.genre2.fillna(0, inplace=True)
        df2.genre3.fillna(0, inplace=True)

        df2.to_csv("ok.csv", sep=',')       

        print df2
        #df2.Genre = df2.Genre.astype(float)
        


        

    def commonmovies(self, user):
        #self.restructureGenre()
        movieList = df.Movie[df.User == user].tolist()

        # List of genre User likes
        userGenreList = []
        genreList = df.Genre[df.User == user].tolist()

        try:

            for genre in genreList:
                val = [x.strip() for x in genre.split(',')]
                for single in val:
                    userGenreList.append(single)
        except(AttributeError), e:
            print "Error %s" % e

        # find the frequencey of each genre which can help in find the actual
        # user likes
        genreFrequency = Counter(userGenreList)
       
        # sort the list with decreasing
        genreFrequency_x = sorted(
            genreFrequency.items(), key=operator.itemgetter(1), reverse=True)

        # extracted the top 2 genres from user preffered list
        movie_genre = ""
        if len(genreFrequency) >= 2:
            movie_genre = genreFrequency_x[0][0] + "|" + genreFrequency_x[1][0]
        elif len(genreFrequency) == 1:
            movie_genre = genreFrequency_x[0]

        userMovieList = []
        userMovieList = df.Movie.tolist()
        movieFrequency = Counter(userMovieList)
        self.updateNADataFrame(movieFrequency)

        suggestedMoviesList = []

        try:
            suggestedMoviesList = df2[
                df2.Genre.str.contains(movie_genre).fillna(False)]

            for movie in movieList:
                suggestedMoviesList = suggestedMoviesList[
                    suggestedMoviesList.MOVIE != movie]

            #
            # Sort the df based on rating , so now fetch top 2 make a comparision easily
            #
            suggestedMoviesList = suggestedMoviesList.sort(
                columns=['imdbRating', 'tomatoRating'], ascending=[False, False])

        except(ValueError), e:
            print "Error %s" % e

        return suggestedMoviesList

    '''
		Find the Similarity between any 2 movies based on ratings and dataframe must be passed
		or default will be taken as the movie list dataframe

		If data is njot sparsed or random changes, prefer to use eculidean else cosine.
		 here from each df, picked 2 movies to work one and this method will always work on that
		 philosopy , only the client needed to deal with there way of calling the method

		 Votes have big margin differences because usually I found imdb has more votes than rotten , 
		 so I picked cosine for giving those differences.

		 In-future we can add more parameters of a movie and user to define more generalize 
		 distances between them
	'''

    def calculatedistance(self, movie1, movie2):
        FEATURES = [
            'imdbRating', 'imdbVotes', 'tomatoRating', 'tomatoUserReviews']

        movie1DF = df2[df2.MOVIE == movie1]
        movie2DF = df2[df2.MOVIE == movie2]


        rating1 = (float(movie1DF.iloc[0]['imdbRating']), float(
            movie1DF.iloc[0]['tomatoRating']))
        rating2 = (float(movie2DF.iloc[0]['imdbRating']), float(
            movie2DF.iloc[0]['tomatoRating']))

        review1 = (long(movie1DF.iloc[0]['imdbVotes']), long(
            movie1DF.iloc[0]['tomatoUserReviews']))
        review2 = (long(movie2DF.iloc[0]['imdbVotes']), long(
            movie2DF.iloc[0]['tomatoUserReviews']))

        # ValueError

        distances = []
        distances.append(round(distance.euclidean(rating1, rating2), 2))
        '''
			Since votes have sparse data , so i preffered to use cosine rather euclidean..
			http://stats.stackexchange.com/questions/29627/euclidean-distance-is-usually-not-good-for-sparse-data
		'''
        distances.append(round(distance.cosine(review1, review2), 2))

        return distances

    def recommendMovie(self, user1, movie):
        userDF = df[df.User == user1]
        return self.calculatedistance(userDF.Movie.irow(1), movie)

    '''
		find permutation of each movie with another, exactly its trying to find the comparision of
		each movie with other
	'''

    def findSimilarityBetweenMovies(self, movies):
        simple_distances = []
        for movie1 in movies:
            for movie2 in movies:
                if movie1 != movie2:
                    row = [movie1, movie2] + \
                        self.calculatedistance(movie1, movie2)
                    simple_distances.append(row)
        cols = ["Movie1", "Movie2", 'Ratings', 'Votes']
        simple_distances = pd.DataFrame(simple_distances, columns=cols)
        print simple_distances.head()
        print len(simple_distances)
        return simple_distances

    def compareOneMovieWithMultiple(self, movie, movies):
        simple_distances = []
        for movie2 in movies:
            if movie != movie2:
                row = [movie, movie2] + self.calculatedistance(movie, movie2)
                simple_distances.append(row)
        cols = ["MAIN_MOVIE", "MovieToBeCompared", 'Ratings', 'Votes']
        simple_distances = pd.DataFrame(simple_distances, columns=cols)
        print simple_distances
        print len(simple_distances)
        return simple_distances

    '''
		This method is meant for comparing between list of movies with other movies
		It verify the distance between each movie with other
	'''

    def compareMultipleMovies(self, movies1, movies2):
        simple_distances = []
        for movie1 in movies1:
            for movie2 in movies2:
                if movie1 != movie2:
                    row = [movie1, movie2] + \
                        self.calculatedistance(movie1, movie2)
                    simple_distances.append(row)

        cols = ["MAIN_MOVIE", "MovieToBeCompared", 'Ratings', 'Votes']
        simple_distances = pd.DataFrame(simple_distances, columns=cols)
        # print simple_distances
        # print len(simple_distances)
        return simple_distances

    def compareUserMovieWithSuggestedList(self, user):
        recommendedMoviesList = findDistance.commonmovies(user)
        userDF = df[df.User == user]
        return self.compareMultipleMovies(userDF.Movie, recommendedMoviesList.MOVIE[0:10])

    def common_watchers(self, movie1, movie2):
        movie1_reviewers = df[df.Movie == movie1].User.unique()
        movie2_reviewers = df[df.Movie == movie2].User.unique()
        common_reviewers = set(movie1_reviewers).intersection(movie2_reviewers)
        return common_reviewers

    # returns the list of users matches in common user data
    # its nothing much but soriting list of users for the movie to be compared
    # of
    def getCommonUserData(self, movie, commonusers):
        mask = (df.User.isin(commonusers)) & (df.Movie == movie)
        reviews = df[mask].sort('User')
        reviews = reviews[reviews.User.duplicated() == False]
        return reviews


csv = CSVLoader("output.csv")
df = csv.loadcsv()
# print "ok %s"%df
# print df.head()
print "=========================================="

csv = CSVLoader("movies.csv")
df2 = csv.loadcsv()
print df2.head()

user1, user2, user3, user4 = "Berchman Mathews", "Zuber Ahmed", "Gaurav Shrivastava","Dhruv Berry"


# http://docs.scipy.org/doc/scipy-0.14.0/reference/spatial.distance.html

val1 = (1, 2)
val2 = (9, 14)

findDistance = FindDistance(df, df2)

#output = findDistance.compareUserMovieWithSuggestedList(user3)
#print output.head()
#commonMovies = distance.match("The Butterfly Effect","Hannibal")
# print "Basic Euclea..Test ",commonMovies

suggestedMoviesList = findDistance.commonmovies(user3)
print "AFTER BAKBAJI \n\nTotal Movies Found %s \n\nLength %s -- %s"%(suggestedMoviesList.head(),len(suggestedMoviesList),suggestedMoviesList.MOVIE.irow(1))
print "\n\n\n=------------------------------="
print "DISTANCE CALCULATION ",findDistance.recommendMovie(user1,suggestedMoviesList.MOVIE.irow(1))

output = findDistance.findSimilarityBetweenMovies(suggestedMoviesList.MOVIE[0:10])


HEADER = '''
<html>
	<head>
	   <link href="test.css" rel="stylesheet" />
	</head>
	<body>
'''
FOOTER = '''
	</body>
</html>
'''

with open('output_1.html', 'w') as f:
    f.write(HEADER)
    f.write(output.to_html(classes='container'))
    f.write(FOOTER)


#output.to_html(open('my_file.html', 'w'))
# findDistance.compareOneMovieWithMultiple("Troy",suggestedMoviesList.MOVIE[0:5])

#commonusers = distance.common_watchers(movie1,movie2)
# print "Users in the sameset: %d" % len(commonusers)
#print list(commonusers)

#user1 = distance.getCommonUserData(movie1,commonusers)
#user2 = distance.getCommonUserData(movie2,commonusers)

# print user1.head()
