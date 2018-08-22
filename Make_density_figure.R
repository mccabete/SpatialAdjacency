

  years <- c(10,50,100, 500,1000,1500, 10000)

for (i in seq_along(years)){
  
  
  r <- raster(ncol = 1000, nrow = 1000)
  values(r) <- runif(ncell(r))
  values <- values(r)
  
  test <- disturb_raster(values = values, nrow = 1000, ncol = 1000, years = i)  
  
  r_new <- raster(ncol=1000, nrow=1000)
  values(r) <- test
  
  run<- freq(r)
  colnames(run) <- c('value', 'count')
  run <- as.data.frame(run)
  run <- na.omit(run)
  
  
  plot(run$value, run$count/length(test), main = paste('After', years[i], "years"), ylab = "age count / grid area", xlab = "age of pixel")
  
}
