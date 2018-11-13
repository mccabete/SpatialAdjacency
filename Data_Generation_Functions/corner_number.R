corner_number <- function(nrow, ncol, index_vector = NULL, give_indexes = FALSE){
  corner_indexes <- c(1, ncol, nrow*ncol,(nrow*ncol) - (ncol -1))
  
  if (give_indexes){
    return(corner_indexes)
  }else {
    corner_number <- 0
    for(i in index_vector){
      if ( i %in% corner_indexes){
        corner_number <- corner_number + 1
      }
      
    } # for loop 
    return(corner_number)
    
  } # else statement 
  
   
} # corner number function 
