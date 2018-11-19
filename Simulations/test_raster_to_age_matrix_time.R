# Tests how long raster_to_age_matrix takes to run for different dimentions of raster. 
# Usefull for checking feasibility of local runs

r <- raster(ncol=5, nrow =5)

seq <- 1:4

seq <- 10^(seq)
seq2 <- c(1:8)

times <- list()
iterator <- 0
for (i in seq_along(seq)){
  for(j in seq_along(seq2)){
    iterator <- 1 + iterator
    r <- raster(ncol = seq[i]*seq2[j], nrow = seq[i]*seq2[j])
    times$time[iterator] <- system.time(raster_to_age_matrix(r)) 
    times$dim[iterator] <- paste((seq[i]*seq2[j])^2)
    rm(r)
  }
  
}


times_classes <- list()

r <- raster(ncol=100, nrow =100)

for ( i in 1:100){
  r <- raster(ncol=10, nrow =10)
  values(r) <- rpois(100, 5)
  times_classes$time[i] <- system.time(raster_to_age_matrix(r)) 
  times_classes$class[i] <- length(unique(values(r)))
  rm(r)
  
}

plot(times_classes$time, times_classes$class, ylab = "Number of classes", xlab="System time (s)")
