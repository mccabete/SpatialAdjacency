r <- raster(ncol=5, nrow=5)


values(r) <- c(6,NA,NA,NA,6,
               NA,5,2,1,NA,
               NA,NA,3,NA,NA,
               NA,1,NA,NA,NA,
               7,NA,NA,NA,7)

get_ratio_basic <- function ( r, date) {
    
    fire_only <- r
    fire_clump <- clump(r, gaps = FALSE, directions = 4 )

  clump_num <- unique(fire_clump)
  results <- list()
  
  for ( i in seq_along(clump_num)){
    clump_id<-c(i, NA)
    tmp <- getValues(fire_clump)
    tmp[!(tmp %in% clump_id)] <- NA
    clump <- fire_clump
    values(clump) <- tmp
    rm(tmp)
    
    out <- edge_to_interior(clump)
    
    results$ratio[i] <- as.numeric(out$ratio)
    results$size[i] <- as.numeric(out$size)
    rm(out)
    
    
  }
  results$Year <- rep(as.character(date), length(results$ratio))
  
  results <- as.data.frame(results)
  return(results)
}
test <- get_ratio_basic(r, "100")