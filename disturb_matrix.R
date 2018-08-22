
disturb_raster <- function (values, nrow, ncol, years, output_interval = years, return_age = FALSE, return_ratio = TRUE){
  
  ages <- values
  results <- list()
  
  for( j in 1:years){
    
    disturbed <- rbinom(length(ages), 1, 0.5) # Coin flip per disturbence
    
    for( i in seq_along(ages)){
      if ( is.na(ages[i]) ){ 
        next 
      }
      
      if (disturbed[i] == 1){ # age resetting disturbence happened
        ages[i] <- 0  ## This distinguished between background values (NA's) and 0 ages
      }
      
      if(disturbed[i] == 0){
        ages[i] <- ages[i] + 1
      }
    } 
    
    
    #if((j %% output_interval) == 0){
    #  
    #  ## Output an age_matrix
    #  if(return_age){
    #    r <- raster(ncol = ncol, nrow = nrow)
    #    results$age_matrix[[j]] <- raster_to_age_matrix(r) 
    #  }
    #  
    #  ## Output an edge_to_interior ratio
    #  if(return_ratio){
    #    r <- raster(ncol = ncol, nrow = nrow)
    #    results$ratio[[j]] <- get_ratio_basic(r, j)
    #  }
    #  
    #  results$year[[j]] <- j
    #  results$ages[[j]] <- unique(ages)
   # }
    
    
 
  } 
  
  return(ages)
} ## takes raster and disturbs it for a number of years
  

