library(raster)

source('~/Documents/work/Spacial_adj/corner_number.R')
source('~/Documents/work/Spacial_adj/disturb_matrix.R')
source('~/Documents/work/Spacial_adj/edge_number.R')
source('~/Documents/work/Spacial_adj/edge_to_interior.R')
source('~/Documents/work/Spacial_adj/get_interior_vertices.R')
source('~/Documents/work/Spacial_adj/get_outer_edges.R')

  years <- c(10,50,100, 500,1000,1500, 1000000000000)
  i = 1000

#for (i in seq_along(years)){
  
  
  r <- raster(ncol = 1000, nrow = 1000)
  values(r) <- runif(ncell(r))
  values <- values(r)
  
  test <- disturb_raster(values = values, nrow = 1000, ncol = 1000, years = i)  
  
  hist(test)
  r_new <- raster(ncol=1000, nrow=1000)
  values(r) <- test
  
  #run<- freq(r)
  #colnames(run) <- c('value', 'count')
  #run <- as.data.frame(run)
  #run <- na.omit(run)
  
  
  #plot(run$value, run$count/length(test), main = paste('After', years[i], "years"), ylab = "age count / grid area", xlab = "age of pixel")
  
#}

  