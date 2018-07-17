get_ratio_dist <- function ( r,text, dist, date, csv, eco_region = FALSE, path_ecoregion) {
  csv_fire<-csv[grep(text, csv$Dist_Type),]
  
  ### get the ecoregion
 #eco_region <- readOGR(dsn = "/Users/tess/Documents/work/na_cec_eco_l2/", layer = "NA_CEC_Eco_Level2")
 #projection(eco_region) <- projection(r) 
 #work <- crop(eco_region, r) #
 
  ### Attempt to subset just fire
  #fire<-c(csv_fire$Value, 0)
  #tmp<-getValues(r)
  #tmp[!(tmp %in% fire)] <- NA
  #tmp[tmp == 0] <- NA
  #tmp[tmp > 0] <-1
  #fire_only <- r
  #values(fire_only) <- tmp
  #rm(tmp)
  
  #fire_clump <- clump(fire_only, gaps = FALSE, directions = 4)
  
  dist_clump <- clump(r, gaps = FALSE, directions = 4)
  stack <- addLayer(r, dist_clump) 
  
  fire_clump <- stack$clumps
  #geometries <- geom(eco_region)
  #over(geometries, fire_only)
  
  
  clump_num <- unique(fire_clump)
  
  ## create results object
  ratio <- rep(NA, length(clump_num))
  Year <- rep(NA, length(clump_num))
  Dist_type <- rep(NA, length(clump_num))
  size <-  rep(NA, length(clump_num))
  results <- cbind(ratio, size, Year, Dist_type)
  results <- as.data.frame(results, row.names = FALSE)
  
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
  #results$Year <- rep(as.character(date), length(clump_num))
  #results$Dist_type <- rep(as.character(dist), length(clump_num))
  results <- as.data.frame(results)
  return(results)
  
}