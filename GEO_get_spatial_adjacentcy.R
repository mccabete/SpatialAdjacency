####################
#  get_spatial_adjacentcy_ratios
#  File paths set up for GEO
#  Created 7/10/2018 Tempest McCabe
####################

require(raster)
require(igraph)

## Functions
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_outer_edges.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_interior_vertices.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/edge_to_interior.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_ratio_dist.R")


## Set up paths

test <- raster("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/Geo_tiff/lf06628962_US_DIST2000/US_DIST2000\\US_DIST2000.tif")

csv<-read.csv("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/disturb2000.csv")
text <- "*ire"
dist_type <- "Fire"

out_file <- ""

## Write output
Fire_2000<- get_ratio_dist(test, text, dist_type, "2000", csv)
write_csv(Fire_2000,"/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/Fire_2000.csv" )
