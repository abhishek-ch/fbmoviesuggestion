#http://www.thisisthegreenroom.com/2009/choropleths-in-r/
#http://www.r-bloggers.com/example-8-31-choropleth-maps/

library(ggplot2)
library(maps)
library(mapproj)
require(ggmap)

pop = read.csv("/Users/abhishekchoudhary/Work/python/recommend/population.csv")
View(pop)
ggplot(pop, aes(Longitude,Latitude,group=group)) + geom_polygon(aes(fill=Population.2011.Census.))

  
states_map <-pop["Place"]

pp <- ggplot(states_map) + 
  aes(pop$Longitude,pop$Latitude) + 
  geom_polygon() +
  geom_path(color="white") +
  coord_equal() +
  scale_fill_brewer("India")


qplot(Longitude,
      Latitude,
      data = pop,
      group = group,
      fill = pop$Population.2011.Census.,
      geom = "polygon"
)



# getting the map
mapgilbert <- get_map(location = c(lon = 73.6303446, lat = 10.0760115), zoom = 4,
                      maptype = "satellite", scale = 2)
ggmap(mapgilbert)

# plotting the map with some points on it
ggmap(mapgilbert) +
  geom_point(data = pop, aes(x = Longitude, y = Latitude, fill = "red", alpha = 0.8), size = 3, shape = 25) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)





