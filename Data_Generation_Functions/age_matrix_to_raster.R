########################
# Function to convert age/ adjacentcy matrix into a raster
# Note: This will be stocastic. The adjacentcy doesn't prescribe 
# WHERE the two age classes touch, only what percentege of a single age class 
# is touching anouther age class
########################
age_matrix_to_raster <- function(age_matrix, ncols, nrows){
  r <- raster(ncols = ncols, nrows = nrows)
  ## Fill in random empty cells
  r[] <- round(runif(ncell(r))*0.7 )
  
 
  return(r)
}