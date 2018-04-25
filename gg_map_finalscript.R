# Using ggmap - Alex Neidermeier
# 25 April 2018
# ANN

# Adapted from R for fledglings (UVM course) and
# Making Maps with R by Eric C. Anderson for NOAA/ SWFSC


# Preliminaries ---------------------------------------------------------
library(ggmap) # automatically loads ggplot
library(rgdal) # automatically loads sp (Cheat sheet for sp : http://rspatial.r-forge.r-project.org/gallery/)
#sp is also used for plotting spatial information
library(foreign)


# Shape file: VT County Boundaries and VT town boundaries which are from http://geodata.vermont.gov/

# CSV file with GPS coordinates


# What is ggmap? ----------------------------------------------------------

# ggmap goes ou to different map servers (like Google) and grabs base maps (which are raster objects) and lets you plot things on those maps
# it can also set up and change coordinate systems and datums
# ?ggmap

#Some example map fetching first:
avl <- get_map(location="Asheville, North Carolina")
ggmap(avl)

# Different maptypes: "terrain", "toner", "watercolor +. 
avl <- get_map(location="Asheville",maptype="toner")
ggmap(avl)
# message: certain maptypes for certain sources

# Different sources include google, stamen, open street map (osm)
# Cheat sheet available: https://github.com/OHI-Science/ohi-science.github.io/raw/3c6babb40348e62b322abadad086ece565411adf/assets/downloads/other/ggmapCheatsheet.pdf
avl <- get_map(location="Asheville, North Carolina",maptype="watercolor",source = "google", zoom = 15)
ggmap(avl)

# Change the zoom:  has to be a whole number. 1 is "world", 21 is "house" on google. (18 on stamen). Below 9 can put you over the query limit

YD <- get_map(location="Yaounde, Cameroon",source="google", maptype="terrain", zoom = 11)
ggmap(YD)


# Vermont example with shapefiles -----------------------------------------

# Get a raster object, overset it with a shapefile, and add GPS coordinates
# 1. Get the map of VT
VT <- get_map("Salisbury,Vermont",zoom=8,maptype = "roadmap",source="google")
VTMap <- ggmap(VT,extent = "normal")
VTMap

# Reading in a VT database file of town boundaries from Vermont Open Geodata Portal (free!)
# Using the read.dbf function which part of the "forein" package.  Turn a data base file (.dbf) into a dataframe for ggplot.
head(read.dbf(file = "County boundaries copy/VTCountyBoundaries.dbf"))

# readOGR is from rgdal package--turns your data in a usable spatial vector object.
VTcountyB  <- readOGR(dsn = "County boundaries copy/VTCountyBoundaries.shp", layer = "VTCountyBoundaries")
plot(VTcountyB)

# Reproject your data from one projection/ datum to another. Check your metadata.
VTcountyB <- spTransform(VTcountyB, CRS("+proj=longlat +datum=WGS84"))

#fortify command (from the package ggplot2).  Converts spatial data into a data frame.
fortify(VTcountyB)

# Plot the shape file on raster object!
VTcountyMap <- VTMap + geom_polygon(aes(x=long, y=lat, group=group), fill='green', size=.2,color='black', data=VTcountyB, alpha=0.3)
VTcountyMap

# Then you can play with alpha and colors
VTcountyMap <- VTMap+geom_polygon(data = VTcountyB, aes(x=long,y=lat,group=group),fill="green",alpha=.5)
VTcountyMap

VTcountyMap <- VTMap+geom_polygon(data = VTcountyB, aes(x=long,y=lat,group=group),fill="green",alpha=.2,color="brown",size=0.5)
VTcountyMap

# From here you can also convey more information by giving results by county (ie populations)



# With GPS coordinates ----------------------------------------------------

# 5 sites in VT
# Reading in table of GPS coordinates
GPS_Coords <- read.table("GPS_coords.csv",header = TRUE,sep = ",",stringsAsFactors = FALSE)
str(GPS_Coords)

# Using geom_point (scatter plots) to plot pts on map
VTtownMap+geom_point(data=GPS_Coords,mapping=aes(x=Lon,y=Lat),color="purple")

VTtownMap+geom_point(data=GPS_Coords,mapping=aes(x=Lon,y=Lat),color="red",size=4)