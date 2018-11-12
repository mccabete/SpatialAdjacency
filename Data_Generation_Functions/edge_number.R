edge_number <- function(nrow, ncol, index_vector = NULL, give_indexes = FALSE){

  total_edge <- (2*(nrow-2)) + (2*(ncol-2))
  side_1 <- rep(NA, total_edge) 
  side_2 <- rep(NA, total_edge) 
  
  for (i in 1:nrow){
    side_1[i] <- 1 + (i-1)*ncol
    side_2[i] <- i * ncol
  }  
  top <- 2:ncol
  bottom <- ((nrow*ncol) - (ncol -1)) : (nrow*ncol)
  
  
  edge_number <- unique(na.omit(c(side_1, side_2, top, bottom)))
  
  corners <- corner_number(nrow, ncol, give_indexes = TRUE)
  edge_number <- edge_number[! edge_number %in% corners] # get edge numbers excluding corners
  
  if (give_indexes){
    return(edge_number)
  }else {
    edge_number_count <- 0
    for (i in index_vector){
      if (i %in% edge_number){
        edge_number_count <- edge_number_count + 1
      }
    }
    
    return(edge_number_count)
  }
}
