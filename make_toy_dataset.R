
## Set up paths
require(raster)
require(igraph)
require(fasterize)
#equire(rgeos)
#library(rgdal)
#library(sp)
## Functions
source("/Users/tess/Documents/work/Spacial_adj/get_outer_edges.R")
source("/Users/tess/Documents/work/Spacial_adj/get_interior_vertices.R")
source("/Users/tess/Documents/work/Spacial_adj/edge_to_interior.R")
source("/Users/tess/Documents/work/Spacial_adj/get_ratio_dist.R")

### 8.5

flist <- list.files("/Users/tess/Downloads/LANDFIRE/8_5_little/")

for ( i in seq_along(flist)){
  
  r <- raster(paste("/Users/tess/Downloads/LANDFIRE/8_5_little/",flist[i],"/US_DIST2014\\US_DIST2014.tif", sep = ""))
  csv<-read.csv("/Users/tess/Downloads/LANDFIRE/US_DIST2000/CSV_Data/US_disturb2000.csv")
  #text <- "*ire*"
  #dist_type <- "Fire"
  text <- NULL
  dist_type <- NULL
  out_file <- ""
  
  date= "2014"
  
  path_ecoregion <- "/Users/tess/Documents/work/na_cec_eco_l2/"
  ## Write output
  Fire_2000<- get_ratio_dist(r, date="2014", csv = csv)
  file_name <- paste("/Users/tess/Documents/work/LANDFIRE/8_5_little_2014","_",flist[i],".csv",sep ="" )
  write_csv(Fire_2000, file_name )
  
}


