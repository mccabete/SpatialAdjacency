# Note: this function interperates differences in cell 
# values to be differences in age. This doesn't have to be the case. 
# requires raster and rlang packages

library(rlang)
# source("./edge_number.R")
# source("./corner_number.R")


raster_to_age_matrix <- function(r) {
  
  ## Add a frame of NA's. This prevents artificial inflation of adjacentcy 
  # Also prevents need for explicit speration fo border and corner cases
  index_r <- cbind( values(r), seq(1:ncell(r)))
  r_ncol <- ncol(r)
  r_nrow <- nrow(r)
  n_ncell <- (ncol(r) + 2) * (nrow(r) + 2)
  
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
  
  ## Start Age matrix on new matrix
  ncol <- ncol(r)
  nrow <- nrow(r)
  total_area <- nrow * ncol
  vals <- getValues(r)
  background <- total_area - length(na.omit(vals))
  age_classes <- unique(vals)
  age_classes <- as.numeric(age_classes)
  age_classes <- sort(age_classes,decreasing = TRUE, na.last = TRUE)
  
  ## Make empty age matrix
  age_matrix <- matrix(nrow = length(age_classes), ncol = length(age_classes))
  rownames(age_matrix) <- age_classes
  colnames(age_matrix) <- age_classes
  
  total_age_number <- freq(r)
  values <- total_age_number[,1]
  counts <- total_age_number[,2]
  total_age_counts <- cbind(values, counts)
  total_age_counts <- as.data.frame(total_age_counts)
  colnames(total_age_counts) <- c("values", "counts")
  
  ## Make a list of cell numbers for every age class
  cell_numbers <- list()
  for(i in seq_along(age_classes)){
    
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
  
  
  ## Fill in adjacentcies
  for (j in  seq_along(age_classes)){
    cell_num_main <- as.numeric(cell_numbers[[j]][,1])
    age_main <- unique(cell_numbers[[j]][,2])
    
    
    for(i in seq_along(age_classes)){

      cell_num_small <- as.numeric(cell_numbers[[i]][,1])
      age_small <- unique(as.numeric(cell_numbers[[i]][,2]))
      
      
      adj <- adjacent(r, cells = cell_num_main,target = cell_num_small) 
     
      
      if ( is.na(age_main)){
        count <- total_age_counts$counts[is.na(total_age_counts$values)]
        
      }else{
        
        count <- na.omit(total_age_counts[total_age_counts$values == age_main,]$counts)
        count <- na.omit(count)
        count <- as.numeric(count)
    
      }
      
      if (is_empty(adj)){
        count_small <- 0
      }else {
        if (length(adj) <= 2){
          count_small <- length(adj[1])
        }else{
          count_small <- length(adj[,1])
        }
        
      }
      
      
      ## get total possible adjacentcies
      total_possible <- count*4 
    
     
      ## existing ajacentcies as ratio of possible adjacentcies 
      percent <-  count_small / total_possible
      #cat( age_main,"adjacent to",age_small,"Percent",percent, count_small)
      age_matrix[j,i] <- percent
      
      ## Special case of NA adj to NA, artifically assigning the remainder to NA/ NA adjacentcy
      # because will always be wrong due to adjacentcy function
      if(i == length(age_classes) & j == length(age_classes)){
        age_matrix[j,i] <- (1 - sum(age_matrix[j,1:(i-1)]))
      }
      
      } # for loop 

  } # adjacentcy loop
  
  
return (age_matrix)
}
