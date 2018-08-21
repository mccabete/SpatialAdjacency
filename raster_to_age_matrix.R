# Note: this function interperates differences in cell 
# values to be differences in age. This doesn't have to be the case. 
# requires raster and rlang packages, corner_number and edge_number functions



r <- raster(ncol=5, nrow=5)


values(r) <- c(NA,6,NA,NA,NA,
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
  values <- total_age_number[,1]
  counts <- total_age_number[,2]
  total_age_counts <- cbind(values, counts)
  total_age_counts <- as.data.frame(total_age_counts)
  colnames(total_age_counts) <- c("values", "counts")
  
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
        if (length(adj)<= 2){
          count_small <- length(adj[1])
        }else{
          count_small <- length(adj[,1])
        }
        
      }
      
      ## get total possible adjacentcies (accounting for corners and boarders)
      ncol <- ncol(r)
      nrow <- nrow(r)
      
      edge <- edge_number(nrow, ncol, index_vector = cell_num_main)
      corner <- corner_number(nrow, ncol, index_vector = cell_num_main)
      total_possible <- ((length(cell_num_main) - (edge + corner))*4) + (edge * 3) + (corner*2)
    
      
      percent <- count_small / (total_possible) # multiplying count times four becuase each cell has 4 edges
      #cat( age_main,"adjacent to",age_small,"Percent",percent, count_small, "Total possible adjacent", count*4)
      age_matrix[i,j] <- percent
      
      
      
      } # for loop 

  } # adjacentcy loop
  
  
return (age_matrix)
}

test<- raster_to_age_matrix(r)
