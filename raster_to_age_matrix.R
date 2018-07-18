# Note: this function interperates differences in cell 
# values to be differences in age. This doesn't have to be the case. 



r <- raster(ncol=5, nrow=5)


values(r) <- c(NA,NA,NA,NA,NA,
               NA,5,2,1,NA,
               NA,NA,3,NA,NA,
               NA,1,NA,NA,NA,
               NA,NA,NA,NA,NA)

raster_to_age_matrix <- function(r) {
  
  total_area <- nrow(r) * ncol(r)
  vals <- getValues(r)
  background <- total_area - length(na.omit(vals))
  age_classes <- unique(vals)
  age_classes <- as.character(age_classes)
  
  ## Make empty age matrix
  age_matrix <- matrix(nrow = length(age_classes), ncol = length(age_classes))
  rownames(age_matrix) <- age_classes
  colnames(age_matrix) <- age_classes
  
  total_age_number <- freq(r)
  
  ## Make a list of cell numbers for every age class
  cell_numbers <- list()
  for(i in seq_along(age_classes)){
    #tmp <- r
    just_num <- vals
    if (!is.na(age_classes[i])){
      just_num[ just_num != age_classes[i]] <- NA
    }
    
    if(is.na(age_classes[i])){
      just_num[ is.na(just_num)] <- -9999
      just_num[ just_num != -9999] <- NA
    }
    
    just_num <- cbind(just_num, seq(1, length(vals)))
    indices <- na.omit(just_num)[,2]
    cell_numbers[[i]] <- cbind(indices, rep(age_classes[i], length(indices)))
    
  }
  
  ## Make a stack of exclusivly every age class
  stack <- stack(r)
  for(i in seq_along(age_classes)){
    tmp <- r
    just_num <- vals
    if (!is.na(age_classes[i])){
      just_num[ just_num != age_classes[i]] <- NA
    }
    
    if(is.na(age_classes[i])){
      just_num[ is.na(just_num)] <- -9999
      just_num[ just_num != -9999] <- NA
    }
    
    values (tmp) <- just_num
    stack <- addLayer(stack, tmp)
  }
  names(stack) <-  c("original", age_classes)
  stack <- dropLayer(stack, 1)
  layers <- names(stack)
  
  ## Fill in adjacentcies
  for (j in  seq_along(age_classes)){
    cell_num_main <- as.numeric(cell_numbers[[j]][,1])
    age_main <- unique(cell_numbers[[j]][,2])
    for(i in seq_along(layers) ){

      cell_num_small <- as.numeric(cell_numbers[[i]][,1])
      age_small <- as.numeric(cell_numbers[[i]][,2])
      
      
      adj <- adjacent(r, cells = cell_num_main,target = cell_num_small)
      if ( is.na(age_main)){
        count <- total_age_number[,2][is.na(total_age_number[,1])]
        
      }else{
        
        count <- total_age_number[,2][total_age_number[,1] == age_main]
      }
      
      percent <-length(adj[,1]) / count
      
    age_matrix[j,i] <- percent
      
      }

  }
  

}