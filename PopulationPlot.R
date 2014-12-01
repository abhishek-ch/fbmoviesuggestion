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




##############################Scrollable Gmap##################################

required.packs = c(
  "ggplot2",            # Plotting.
  "googleVis"
)

# Install the required packages if missing, then load them.
sapply(required.packs, function(pack) {
  if(!(pack %in% installed.packages())) {install.packages(pack)}
  require(pack, character.only=TRUE)
})

if(Sys.info()["user"] == 'achoudhary'){
  pop = read.csv("D:/Work/Python/DataMining/git/population.csv")
}else{
  pop = read.csv("/Users/abhishekchoudhary/Work/python/recommend/population.csv")
}


location = paste(pop$Latitude, pop$Longitude, sep=":")
placeNames <- pop$Place
plotData<-data.frame(name=placeNames,latLong=unlist(location))
View(plotData)

sites <- gvisMap(plotData,locationvar="latLong",tipvar="name", 
                 options=list(displayMode = "Markers", mapType='normal', colorAxis = "{colors:['red', 'grey']}",
                              useMapTypeControl=TRUE, enableScrollWheel='TRUE'))
plot(sites)











###########################################################################

## Example with address, here UK post-code and some html code in tooltip

df <- data.frame(Postcode=c("John Henchy & Sons,40 Wellington Road, St Lukes,Cork,Ireland",
                            "Brú Bar & Hostel,57 MacCurtain St,Cork,Ireland",
                            "Windsor Inn Cork,54 - 55 MacCurtain St,Cork,Ireland",
                            "Dan Lowry's Tavern,13 MacCurtain St,Cork,Ireland",
                            "Shelbourne Bar , 16/17 MacCurtain Street Cork,Ireland",
                            "The Cork Arms,23 MacCurtain St,Cork,Ireland",
                            "Gallagher's Pub,32 MacCurtain St, Cork,Ireland"
                            ,"6ix,6 Bridge St,Cork,Ireland",
                            "The Corner House,7 Coburg St,Cork,Ireland",
                            "Sin é,8 Coburg St,Cork,Ireland",
                            "Cashmans,26 Academy St,Cork,Ireland",
                            "The Bowery,21 Tuckey St,Cork,Ireland"
                            ),
                 Tip=c("<a>John Henchy & Sons <b>(4:00-4:30)</b></a>",
                       "Bru Bar(4:35-5:05)",
                       "LV(5:10-5:40)",
                       "Dan Lowry's Tavern(5:45-6:15)",
                       "Shelbourne Bar(6:20-6:50)",
                       "The Cork Arms(6:55-7:25)",
                       "Gallagher's Pub(7:30-8:00)",
                       "6ix(8:05-8:35)",
                       "The Corner House(9:10-9:40)",
                       "Sin E(9:45-10:15)",
                       "Cashman(10:20-10:50)s",
                       "The Slate(11:00-till death...)"))

M2 <- gvisMap(df, "Postcode", "Tip",
              options=list(showTip=TRUE,showLine=TRUE, mapType='normal',
                           enableScrollWheel=TRUE,
                           useMapTypeControl=TRUE,
                           icons=paste0("{",
                                        "'default': {'normal': 'https://d30y9cdsu7xlg0.cloudfront.net/png/14871-42.png',\n",
                                        "'selected': 'https://d30y9cdsu7xlg0.cloudfront.net/png/9454-42.png'",
                                        "}}")))

plot(M2)
