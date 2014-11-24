#https://github.com/richardasaurus/imdb-pie
from imdbpie import Imdb
imdb = Imdb()

# Creating an instance with caching enabled
# Note that the cached responses expire every 2 hours or so.
# The API response itself dictates the expiry time)
imdb = Imdb({'cache': True})
movie = imdb.find_movie_by_id("tt1210166")
print movie



