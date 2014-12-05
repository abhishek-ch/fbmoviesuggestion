## Example with address, here UK post-code and some html code in tooltip

required.packs = c(
  "ggplot2",            # Plotting.
  "googleVis"
)

# Install the required packages if missing, then load them.
sapply(required.packs, function(pack) {
  if(!(pack %in% installed.packages())) {install.packages(pack)}
  require(pack, character.only=TRUE)
})


df <- data.frame(Postcode=c("John Henchy & Sons,40 Wellington Road, St Lukes,Cork,Ireland",
                            "Bru Bar & Hostel,57 MacCurtain St,Cork,Ireland",
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
      "<a>Bru Bar <b>(4:35-5:05)</b></a>",
      "<a>LV <b>(5:10-5:40)</b></a>",
      "<a>Dan Lowry's Tavern <b>(5:45-6:15)</b></a>",
      "<a>Shelbourne Bar <b>(6:20-6:50)</b></a>",
      "<a>The Cork Arms <b>(6:55-7:25)</b></a>",
      "<a>Gallagher's Pub <b>(7:30-8:00)</b></a>",
      "<a>6ix <b>(8:05-8:35)</b></a>",
      "<a>The Corner House <b>(9:10-9:40)</b></a>",
      "<a>Sin E <b>(9:45-10:15)</b></a>",
      "<a>Cashmans <b>(10:20-10:50)</b></a>",
      "<a>The Slate <b>(11:00-till death...)</b></a>"))

M2 <- gvisMap(df, "Postcode", "Tip",
              options=list(showTip=TRUE,showLine=TRUE, mapType='normal',
                           enableScrollWheel=TRUE,
                           useMapTypeControl=TRUE,
                           icons=paste0("{",
                                        "'default': {'normal': 'http://res.cloudinary.com/dgxal1qkf/image/upload/v1417455127/1_u5z1re.png',\n",
                                        "'selected': 'http://res.cloudinary.com/dgxal1qkf/image/upload/v1417455196/2_ebvcx0.png'",
                                        "}}")))

plot(M2)
