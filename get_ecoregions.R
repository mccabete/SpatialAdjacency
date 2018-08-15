####### For subsetting the ecoregions remotely ###
# Trying to get ecoregions Southern eastern plains 8.5 & 8.3
# comparing to ecoregions in the pacific northeast 7.1 & 6.2
#
#
library(rgdal)
library(maptools)
require(raster)
require(igraph)

eco_II<-rgdal::readOGR("~/Documents/work/na_cec_eco_l2/NA_CEC_Eco_Level2.shp")
Southern_coastal_plains <- eco_II[eco_II$NA_L2NAME == "MISSISSIPPI ALLUVIAL AND SOUTHEAST USA COASTAL PLAINS", ]

r <- raster(nrow=1e3, ncol=1e3, crs=proj4string(Southern_coastal_plains))
r[] <- 1:length(r)



Florida <- raster("/Users/tess/Downloads/LANDFIRE/Florida/lf44157424_US_DIST2014/US_DIST2014\\US_DIST2014.tif", nrow=1e6, ncol=1e6, crs=proj4string(Southern_coastal_plains))
projection(Florida) <- projection(Southern_coastal_plains)

Florida_subset <- crop(Florida, extent(Southern_coastal_plains))
plot(Florida_subset)

plot(Southern_coastal_plains)
plot(Florida, add = TRUE)
zoom()
