get_ratio_dist <- function ( r,text = NULL, dist = NULL, date, csv, eco_region = FALSE, path_ecoregion) {
  
  
 ### get the ecoregion
 #eco_region <- readOGR(dsn = "/Users/tess/Documents/work/na_cec_eco_l2/", layer = "NA_CEC_Eco_Level2")
 #projection(eco_region) <- projection(r) 
 #work <- crop(eco_region, r) #
 
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
  #geometries <- geom(eco_region)
  #over(geometries, fire_only)
  
  
  clump_num <- unique(fire_clump)
  
  ## create results object
  #ratio <- rep(NA, length(clump_num))
  #Year <- rep(NA, length(clump_num))
  #Dist_type <- rep(NA, length(clump_num))
  #size <-  rep(NA, length(clump_num))
  #ids <- rep(NA, length(clump_num))
  
  #results <- cbind(ratio, size, Year, Dist_type, ids)
  #results <- as.data.frame(results, row.names = FALSE)
  results <- list()
  
  for ( i in seq_along(clump_num)){
    clump_id<-c(i, NA)
    tmp <- getValues(fire_clump)
    tmp[!(tmp %in% clump_id)] <- NA
    clump <- fire_clump
    values(clump) <- tmp
    rm(tmp)
    
    
    out <- edge_to_interior(clump)
    dist_number <- unique(stack$US_DIST2000.US_DIST2000[stack$clumps == i])
    
    dist_names <- droplevels(csv_fire$Dist_Type[csv_fire$Value %in% dist_number])
    dist_names <- droplevels(unique(dist_names))
    
    if (length(dist_names) > 1){
      
      for (j in 0:length(dist_names)){
        z = j+1
        results$ratio[i + j] <- as.numeric(out$ratio)
        results$size[i + j] <- as.numeric(out$size)
        results$Dist_type[i + j] <- dist_names[z]
        results$ids[i + j] <- paste(dist_number, collapse = ' ')
        final_j <- j
      }
      i = i + final_j
      
    }else{
      
      results$ratio[i] <- as.numeric(out$ratio)
      results$size[i] <- as.numeric(out$size)
      results$Dist_type[i] <- dist_names[i]
      results$ids[i] <- paste(dist_number, collapse = ' ')
      rm(out)
      
    }
    
   
  }
  results$Year <- rep(as.character(date), length(results$ratio))
  
  results <- as.data.frame(results)
  return(results)
  
}
