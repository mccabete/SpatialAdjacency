####################
#  get_spatial_adjacentcy_ratios
#  File paths set up for GEO
#  Created 7/10/2018 Tempest McCabe
####################

require(raster)
require(igraph)

## Functions
source("/Users/tess/Documents/work/Spacial_adj/get_outer_edges.R")
source("/Users/tess/Documents/work/Spacial_adj/get_interior_vertices.R")
source("/Users/tess/Documents/work/Spacial_adj/edge_to_interior.R")
source("/Users/tess/Documents/work/Spacial_adj/get_ratio_dist.R")


## Set up paths

r <- raster("/Users/tess/Documents/work/LANDFIRE/Geo_tiff/lf06628962_US_DIST2000/US_DIST2000\\US_DIST2000.tif")
csv<-read.csv("/Users/tess/Documents/work/LANDFIRE/US_DIST2000/CSV_Data/US_disturb2000.csv")
text <- "*ire*"
dist <- "Fire"

out_file <- ""

date= "2000"
## Write output
Fire_2000<- get_ratio_dist(test, text, dist=dist_type, date="2000", csv)
#write_csv(Fire_2000,"/Users/tess/Documents/work/LANDFIRE/Fire_200.csv" )
