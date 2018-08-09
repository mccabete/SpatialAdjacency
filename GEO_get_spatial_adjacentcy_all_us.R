####################
#  get_spatial_adjacentcy_ratios
#  File paths set up for GEO
#  Created 7/10/2018 Tempest McCabe
####################

#require(raster)
#require(igraph)


print("test")

sessionInfo()
.libPaths()
#install.packages("raster",repo="https://cloud.r-project.org/")
#install.packages("raster",repo="https://cloud.r-project.org/")
#install.packages("igraph",repo="https://cloud.r-project.org/")
#install.packages("rgdal", repo = "https://cloud.r-project.org/")

#install.packages("sp",repo="https://cloud.r-project.org/")
#install.packages("Rcpp",repo="https://cloud.r-project.org/", verbose = TRUE)
#install.packages("raster",repo="https://cloud.r-project.org/")

#library(rgdal)
library(igraph)
library(raster)
library(rgdal)
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_outer_edges.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_interior_vertices.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/edge_to_interior.R")
source("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/get_ratio_dist_2000.R")


## Set up paths

all_us <- rgdal::readGDAL(fname = "/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/US_DIST2000/grid1/us_dist2000/")
test <- raster (all_us)

csv<-read.csv("/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/disturb2000.csv")
text <- NULL
dist_type <- NULL

out_file <- ""

## Write output
print("starting get_ratio_dist")

Fire_2000<- get_ratio_dist(test, date= "2014",csv= csv)

print("writing output" )
write.csv(Fire_2000,"/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/all_us_2000.csv" )
