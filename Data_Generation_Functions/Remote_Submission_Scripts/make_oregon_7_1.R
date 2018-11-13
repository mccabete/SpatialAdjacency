library(rgdal)
library(raster)

florida_patch <- raster::raster("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/Oregon/Oregon_whole_state_2014.tif")


eco_II<- rgdal::readOGR("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/na_cec_eco_l2/NA_CEC_Eco_Level2.shp")


Southern_coastal_plains <- eco_II[eco_II$NA_L2NAME == "MARINE WEST COAST FOREST", ]
#plot(Southern_coastal_plains)

Southern_coastal_plains <- spTransform(Southern_coastal_plains, crs(florida_patch))
crs(Southern_coastal_plains) <- crs(florida_patch)



croped <- crop(florida_patch, extent(Southern_coastal_plains))
masked <- mask(florida_patch, mask = Southern_coastal_plains, inverse=TRUE)

writeRaster(masked, "/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/Oregon/Oregon_7_1_2014.tif")
