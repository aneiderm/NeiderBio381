# Using ggmap-Alex Neidermeier
# 25 April 2018
# ANN

# Adapted from: R for fledglings (UVM course) and 
# Making Maps with R by Eric C. Anderson for (NOAA/SWFSC)

# Preliminaries -----------------------------------------------------------
library(ggmap) #automatically loads ggplot as well
library(rgdal) #automatically loads sp
library(foreign)

# download shape file. Shape files are used to store geospatial info. Don't tinker with individual files in your file browser as they get corrupted easily.  Can be downloaded from lots of places like vcgi  (browser)
# read in tables


# What is ggmap? ----------------------------------------------------------
# ggmap is a package that goes out to different map servers and grabs base maps (raster objects) to plot things on. 
#then it sets up the coordinate system and writes it out as the base layer for further ggplotting. 
# the structure is very similar to ggplot in that you add on geoms.
#?ggmap

# Some example map fetching:
avl <- get_map(location="Asheville, North Carolina")
ggmap(avl)
# Different maptypes: "terrain","toner","watercolor" and lots of others (helpfile)
# Haven't had luck getting terrain to work
avl <- get_map(location="Asheville, North Carolina",maptype = "toner")
ggmap(avl)

# can also use different sources
avl <- get_map(location="Asheville, North Carolina",maptype = "watercolor",source = "stamen")
ggmap(avl)
?get_map

# You can change the zoom as well.
#Zoom has to be a whole number. 1 is "world", 21 is "building on google, 18 on stamen
# Getting below 9 seems to put you over the query limit frequently
yd <- get_map(location="Yaounde, Cameroon",source = "google",zoom = 11)
ggmap(yd)

yd <- get_map(location="Yaounde, Cameroon",source = "google",zoom = 15, maptype = "satellite")
ggmap(yd)

# Can use extent to put a little margin around the outside.  
# default is device.
avl <- get_map(location="Asheville, North Carolina",source = "stamen", zoom = 7)
ggmap(avl, extent="panel")
ggmap(avl, extent="normal")

# Vermont example with shapefile ------------------------------------------

# Might want to try to center this up a little bit more. maybe change maptype
VT <- get_map("Salisbury, VT", zoom=8, maptype = "roadmap",source = "google")
VTMap <- ggmap(VT,extent="normal")
VTMap

# Reading in a VT shapefile of town boundaries.
# Using the read.dbf function which is part of the "foreign" package.  Essentially turns a data base file into a dataframe (needed for ggplot)
head(read.dbf(file = "towns/VT_Boundaries__town_polygons.dbf"), n=10)

#Now we are reading in the shape files
VTtownB  <- readOGR(dsn = "towns/VT_Boundaries__town_polygons.shp", layer = "VT_Boundaries__town_polygons")
plot(VTtownB)

# This is essentially to reproject your data from one projection or datum to another.  Want to check the metadata on your shapefile.
VTtownB <- spTransform(VTtownB, CRS("+proj=longlat +datum=WGS84"))

#fortify command (from the package ggplot2) takes all that spatial data and converts it into a data frame that R understands how to put onto a map.
fortify(VTtownB)

# Now we plot the shape file data on top of our ggmap
VTtownMap <- VTMap + geom_polygon(aes(x=long, y=lat, group=group), fill='grey', size=.2,color='black', data=VTtownB, alpha=0)
VTtownMap

# Can play with alpha and colors
VTtownMap <- VTMap + geom_polygon(aes(x=long, y=lat, group=group), fill='yellow', size=.2,color='black', data=VTtownB, alpha=.5)
VTtownMap

# Let's say your interested in counties instead
head(read.dbf(file = "County boundaries copy/VTCountyBoundaries.dbf"), n=10)
VTcountyB  <- readOGR(dsn = "County boundaries copy/VTCountyBoundaries.shp", layer = "VTCountyBoundaries")
plot(VTcountyB)
VTcountyB <- spTransform(VTcountyB, CRS("+proj=longlat +datum=WGS84"))
fortify(VTcountyB)

# Plot it!
VTcountyMap <- VTMap + geom_polygon(aes(x=long, y=lat, group=group), fill='green', size=.2,color='black', data=VTcountyB, alpha=0.3)
VTcountyMap
# From here you can also convey more information by giving results by county (ie populations)


# With GPS coordinates ----------------------------------------------------
# Maybe you have 5 sites in Vermont
# Reading in a short table of GPS coordinates
GPS_Coords <- read.table("GPS_coords.csv",header=TRUE,sep=",", stringsAsFactors=FALSE)
str(GPS_Coords)

#Using geom_point (which makes scatter plots) to plot the points on the map
VTtownMap + geom_point(data = GPS_Coords, mapping = aes(x = Lon, y = Lat), color = "red")

VTcountyMap + geom_point(data = GPS_Coords, mapping = aes(x = Lon, y = Lat), color = "black")

VTcountyMap + geom_point(data = GPS_Coords, mapping = aes(x = Lon, y = Lat), color = "black")

#Change colors/ sizes of points.
VTcountyMap + geom_point(data = GPS_Coords, mapping = aes(x = Lon, y = Lat), size=4, color = "purple")
# ggplot cheat sheet.



# Show on the VCGI website how to get the shapefiles 

#export to PDF


#now we are using the make_bbbox function to pick the zoom level for our sites
VTbox <- make_bbox(lon = GPS_Coords$Lon, lat = GPS_Coords$Lat, f = .1)
VTbox
#Now we are getting the map using that coordinate box.  This bbox seems to have some issues however, so you can also set it manually
vt_map <- get_map(location = VTbox,source = "google")


