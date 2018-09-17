
library(raster)
source("./edge_to_interior.R")
source("./get_interior_vertices.R")
source("./get_outer_edges.R")

get_ratio_basic <- function ( r, date) {
    
    ages <- unique(r)
    results <- list()
    results_final <- list()
    
for (j in seq_along(ages)){
  fire_only <- r
  fire_only[ fire_only != ages[j] ] <- NA
    
  fire_clump <- clump(fire_only, gaps = TRUE, directions = 4 )
  clump_num <- unique(fire_clump)
  
  
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
    results$age[i] <- ages[j]
    results$clump_num[i] <- i
    
    results_final <- rbind(as.data.frame(results_final), as.data.frame(results))
    results_final <- unique(results_final)
    rm(out)
    
  }
  
  }
  
    results_final$Year <- rep(as.character(date), length(results_final$ratio))
  return(results_final)
}

