edge_to_interior<- function(r, ...){
  
  results <- list()  
  
  outer<- get_outer_edges(r)
  inner<- get_interior_vertices(r)
  
  if(outer$size <= 1){
    ratio <- 0
  }else{
    ratio <- inner$number/(outer$number+inner$number)
  }
  
  results$ratio <- ratio
  results$size <- outer$size
  return(results)
}