####################
#  get_spatial_adjacentcy_ratios
#  File paths set up for GEO
#  Created 7/10/2018 Tempest McCabe
####################

require(raster)
require(igraph)
require(fasterize)
#equire(rgeos)
#library(rgdal)
#library(sp)
## Functions
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_outer_edges.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_interior_vertices.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/edge_to_interior.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_ratio_dist.R")


## Set up paths

<<<<<<< HEAD
test <- raster("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/Geo_tiff/lf06628962_US_DIST2000/US_DIST2000\\US_DIST2000.tif")

csv<-read.csv("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/disturb2000.csv")
text <- "*ire"
dist_type <- "Fire"

=======
r <- raster("/Users/tess/Downloads/LANDFIRE/Geo_tiff/lf06628962_US_DIST2000/US_DIST2000\\US_DIST2000.tif")
csv<-read.csv("/Users/tess/Downloads/LANDFIRE/US_DIST2000/CSV_Data/US_disturb2000.csv")
#text <- "*ire*"
#dist_type <- "Fire"
text <- NULL
dist_type <- NULL
>>>>>>> eaa6c608390f59f7b02047fd56bdfbf640aa4236
out_file <- ""

date= "2000"

path_ecoregion <- "/Users/tess/Documents/work/na_cec_eco_l2/"
## Write output

Fire_2000<- get_ratio_dist(r, date="2000", csv = csv)
write_csv(Fire_2000,"/Users/tess/Documents/work/LANDFIRE/Fire_200.csv" )

