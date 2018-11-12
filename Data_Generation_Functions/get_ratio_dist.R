get_ratio_dist <- function ( r,text = NULL, dist = NULL, date, csv, eco_region = FALSE, path_ecoregion) {
  
  

 
  ### Attempt to subset just single disturbence
  if( !is.null(dist) & !is.null(text)){
    csv_fire <- csv[grep(text, csv$Dist_Type),]
  
  fire <- c(csv_fire$Value, 0)
  tmp <- getValues(r)
  tmp[!(tmp %in% fire)] <- NA
  tmp[tmp == 0] <- NA
  tmp[tmp > 0] <- 1
  fire_only <- r
  values(fire_only) <- tmp
  rm(tmp)
  
  fire_clump <- clump(fire_only, gaps = FALSE, directions = 4)
  
  }else {
    csv_fire <- csv
    
    fire_only <- r
    fire_clump <- clump(r, gaps = FALSE, directions = 4 )
  }
  
  stack <- addLayer(fire_only, fire_clump)

  
  
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
    dist_number <- unique(stack$US_DIST2014.US_DIST2014[stack$clumps == i])
    
    dist_names <- droplevels(csv_fire$Dist_Type[csv_fire$Value %in% dist_number])
    dist_names <- unique(dist_names)
    
    results$ratio[i] <- as.numeric(out$ratio)
    results$size[i] <- as.numeric(out$size)
    results$Dist_number[i] <- dist_names
    results$dist_name[i] <- paste(dist_names, collapse = ',')
    results$ids[i] <- paste(dist_number, collapse = ' ')
    rm(out)
    
   
  }
  results$Year <- rep(as.character(date), length(results$ratio))
  
  results <- as.data.frame(results)
  return(results)
  
}
