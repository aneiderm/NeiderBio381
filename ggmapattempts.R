# ggmap testing
# ANN
# April 14, 2018


library(ggmap)
library(ggplot2)
library(RgoogleMaps)
# This maps package has a bunch of different maps that are brought in as a data frame that you can use with ggplot2 and then put 
library(maps)
library(mapdata)
library(rgdal)
library(foreign)
#citation('ggmap')
#?ggmap

# look at 20 topo colors, notice these are color codes!
topo.colors(20)
# we can view them by putting them into a pie chart
pie(rep(1,20), col=topo.colors(20))
# now look at these colors in the reverse order
rev(topo.colors(20))
pie(rep(1,20), col=rev(topo.colors(20)))
# store these as object called col
col  <- rev(topo.colors(20))



# ggmap plots the raster object produced by get_map
# look into get_map and qmap
# ggmap is a package that goes out to different map servers and grabs base maps to plot things on, then it sets up the coordinate system and writes it out as the base layer for further ggplotting. 

hdf <- get_map("houston, texas",maptype = "watercolor")
# Different maptypes: "terrain","toner","watercolor"
ggmap(hdf, extent = "normal")
ggmap(hdf) # extent = "panel", note qmap defaults to extent = "device"
#This gives you a margin around the outside
ggmap(hdf, extent = "panel")


# make some fake spatial data
mu <- c(-95.3632715, 29.7632836); nDataSets <- sample(4:10,1)
chkpts <- NULL
for(k in 1:nDataSets){
  a <- rnorm(2); b <- rnorm(2);
  si <- 1/3000 * (outer(a,a) + outer(b,b))
  chkpts <- rbind(
    chkpts,
    cbind(MASS::mvrnorm(rpois(1,50), jitter(mu, .01), si), k)
  )
}
chkpts <- data.frame(chkpts)
names(chkpts) <- c("lon", "lat","class")
chkpts$class <- factor(chkpts$class)
qplot(lon, lat, data = chkpts, colour = class)

# show it on the map
ggmap(hdf, extent = "normal") +
  geom_point(aes(x = lon, y = lat, colour = class), data = chkpts, alpha = .5)

ggmap(hdf) +
  geom_point(aes(x = lon, y = lat, colour = class), data = chkpts, alpha = .5)

# quickstart--can't get maps to load
myLocation <- c(lon = -95.3632715, lat = 29.7632836)
#maptype = c("terrain","toner","watercolor")
myMap <-get_mapp(location=myLocation,
          source="osm",color="bw")
ggmap(myMap)
# get_map produces a raster object.  ggmap plots the raster object.
avl <- get_map("Asheville, North Carolina")
ggmap(avl)


# working parts -----------------------------------------------------------


# try getting a burlington map.  Then put gps coordinates on it and then the county map from tauntaun dataset.

#could do a couple of these, just bringing in maps, different maptypes and zooms (7 minutes)
#Zoom has to be a whole number. 1 is "world", 21 is "building.
# Seems like you can do just a state (ie Vermont)
# Might want to try to center this up a little bit more
VT <- get_map("Killington, VT", zoom=8, maptype = "terrain",source = "google")
VTMap <- ggmap(VT)
VTMap

# Reading in a VT shapefile of town boundaries.
head(read.dbf(file = "towns/VT_Boundaries__town_polygons.dbf"), n=10)

#Now we are reading in the shape files
town.sh  <- readOGR(dsn = "towns/VT_Boundaries__town_polygons.shp", layer = "VT_Boundaries__town_polygons")
plot(town.sh)

#see if I need this in a minute
town.sh <- spTransform(town.sh, CRS("+proj=longlat +datum=WGS84"))

#fortify command (from the package ggplot2) takes all that spatial data and converts it into a data frame that R understands how to put onto a map.
fortify(town.sh)


VTMap <- VTMap + geom_polygon(aes(x=long, y=lat, group=group), fill='grey', size=.2,color='black', data=town.sh, alpha=0)
VTMap

# now I need to get some GPS coordinates and plot them
#ggmap(sq_map) + geom_point(data = sisquoc, mapping = aes(x = lon, y = lat), color = "red")

GPS_Coords <- read.table("GPS_coords.csv",header=TRUE,sep=",", stringsAsFactors=FALSE)
str(GPS_Coords)

#now we are using the make_bbbox function to pick the zoom level for our sites
VTbox <- make_bbox(lon = GPS_Coords$Lon, lat = GPS_Coords$Lat, f = .1)
VTbox

#Now we are getting the map using that coordinate box.  This bbox seems to have some issues however, so you can also set it manually
vt_map <- get_map(location = VTbox,source = "google")

ggmap(vt_map) + geom_point(data = GPS_Coords, mapping = aes(x = Lon, y = Lat), color = "red")

ggmap(VT) + geom_point(data = GPS_Coords, mapping = aes(x = Lon, y = Lat), color = "red")
#Change colors/ sizes of points.  ggplot cheat sheet.

# Can also use a different shapefile for counties

# Show on the VCGI website how to get the shapefiles 

# export to PDF

