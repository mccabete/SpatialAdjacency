### get_outer_edges

get_outer_edges <- function(r, directions = 4, classes = FALSE, FRAME = TRUE, ...){
  
  outer_edges<- list()
  
  ## Check that the raster uses NA's as background state
  has_NA <-NA %in% values(r)
  
  # Make indexable matrix of r
  index_r <- cbind( values(r), seq(1:ncell(r)))
  
  if( ! has_NA ){
    print("WARNING, this raster seems to not use NA's as background state. This could mean that the number of edge cells is inflated if value-cells are on a boarder of the raster ")
  }
  
  ## Give frame of NA's
  if(has_NA & FRAME){
    
    r_ncol <- ncol(r)
    r_nrow <- nrow(r)
    n_ncell <- (ncol(r) + 2) * (nrow(r) + 2)
    
    #Make new values vector
    n_vals <- rep(NA, n_ncell)
    n_ncol <- ncol(r) + 2
    mult_row <- 0
    
    for(i in 1:ncell(r)){
      
      new_index <- n_ncol + 1 + mult_row + index_r[i,2]
      n_vals[new_index] <- index_r[i,1]
      
      if(((new_index + 1) %% n_ncol) == 0){
        mult_row<- mult_row+2
      }
      
    }
    
    
    r<- raster(nrows = r_nrow+2, ncol = r_ncol +2, vals = n_vals)
  }
  
  
  ## Get outer boundary
  bound_r <- boundaries(r, type = "outer", directions = 4, classes= classes)
  
  ## account for every time the outher boundary touches the raster itself
  
  ## Prep the indexes
  new_index_r <- cbind( values(r), seq(1:ncell(r)))
  new_index_r <- na.omit(new_index_r) ## need a new index
  
  tmp_bound_r<-values(bound_r)
  tmp_bound_r[tmp_bound_r ==0] <- NA
  
  Adjacent <- cbind(tmp_bound_r, 1:ncell(bound_r))
  Adjacent <- na.omit(Adjacent)
  
  ## get the adjacentcy 
  touching<-adjacent(r, cells = new_index_r[,2] ,directions = 4, target =    Adjacent[,2])
  
  outer_edges$cells <- touching
  outer_edges$number <- length(touching[,1])
  outer_edges$size <- length(new_index_r[,2])
  
  return(outer_edges)
}
