
library(raster)
source("./edge_to_interior.R")
source("./get_interior_vertices.R")
source("./get_outer_edges.R")


get_ratio_basic <- function ( r, date = NA) {
  
    values(r) <- values(r) +1 #If zero's exist, want them to be offical age class.
    ages <- unique(r)
    results <- list()
    results_final <- list()
  
## Subset raster by disturbence/ age class
for (j in seq_along(ages)){
  fire_only <- r
  fire_only[ fire_only != ages[j] ] <- NA
    
  fire_clump <- clump(fire_only, gaps = TRUE, directions = 4 )
  clump_num <- unique(fire_clump)
  
  ## Subset to each clump within a class
  for ( i in seq_along(clump_num)){
    clump_id<-c(i, NA)
    tmp <- getValues(fire_clump)
    tmp[!(tmp %in% clump_id)] <- NA
    clump <- fire_clump
    values(clump) <- tmp
    rm(tmp)
    
    ## Get interior to total ratio for clump
    out <- edge_to_interior(clump)
    
    
    ## Get information on clump
    results$ratio[i] <- as.numeric(out$ratio)
    results$size[i] <- as.numeric(out$size)
    results$age[i] <- ages[j]
    results$clump_num[i] <- i
    
    results_final <- rbind(as.data.frame(results_final), as.data.frame(results))
    results_final <- unique(results_final)
    rm(out)
  
  }
  
  }
  
    results_final$Year <- rep(as.character(date), length(results_final$ratio))
    
    age_correction <- rep(1, length(results$age))
    results_final$age <- results_final$age - age_correction # returning to orginal values post adjacentcy
  return(results_final)
}

