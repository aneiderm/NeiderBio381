# Leaflet presentation

install.packages("leaflet") 
install.packages("maps")
library(leaflet)
library(maps)
library(TeachingDemos)
char2seed("Professor Looney")
dF <- read.csv("Class demos/Leaflet/leafletData30.csv")
dF2 <- read.csv("Class demos/Leaflet/leafletData500.csv")
cities <- read.csv("Class demos/Leaflet/cities.csv")

# leaflet() creates a map widget that can store variables to be modified later on 
# addtiles() adds mapping data from "open street map"
# %>%: takes an output and add onto the next command
# as the first argument, and reassign it to the variable

# create a simple map
my_map <- leaflet()%>%
  addTiles()
my_map

# without piping notation
my_map=leaflet()
my_map=addTiles(my_map)
my_map

# adding different types of maps onto my_map
my_map <- leaflet()%>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldImagery)
my_map

# adding markers
map <- my_map %>%
  addMarkers(lat=44.4764,lng=-73.1955)
map

# give a label
map <- my_map %>%
  addMarkers(lat=44.4764,lng=-73.1955,
             popup="Bio381 Classroom")
map

df <- data.frame(lat=runif(20,min=44.4770,max = 44.4793),
                 lng=runif(20,min=-73.18788,max=-73))
head(df)
df%>%
  leaflet()%>%
  addTiles()%>%
  addMarkers()

# read .csv file
markers <- data.frame(lat=df$lat,
                      lng=df$lng)
markers%>%
  leaflet()%>%
  addTiles()%>%
  addMarkers()

# adding legends
df <- data.frame(col=sample(c("red","blue","green"),
                            20,replace=TRUE),
                 stingAsFactors=FALSE)
markers%>%
  leaflet()%>%
  addTiles()%>%
  addCircleMarkers(color=df$col)%>%
  addLegend(labels=c("A.rubrum","T.canadensis","P.strobum"),colors=c("red","blud","green"))


# making clusters
cluster <- data.frame(lat=df$lat,
                      lng=df$lng)
cluster%>%
  leaflet()%>%
  addTiles()%>%
  addMarkers()


# you can add rectangles or polygons with addRectangles() or addPolygons()

#POLYGONS
# simple colored map of the united states
mapStates = map("state", fill = TRUE, plot = FALSE)
leaflet(data = mapStates) %>% addTiles() %>%
  addPolygons(fillColor = topo.colors(10, alpha = NULL), stroke = FALSE)

leaflet(cities) %>% addTiles() %>%
  addCircles(lng = ~long, lat = ~lat, weight = 1,
             radius = ~sqrt(pop) * 30, popup = ~city)
