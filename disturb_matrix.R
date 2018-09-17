#' Title
#'
#' @param ages matrix of stand age
#' @param p.init disturbance initiation probability
#' @param years number of years to simulate
#'
#' @return
#' @export
#'
#' @examples
gap_disturb_raster <- function (ages, p.init, years){
  
  results <- list()
  
  for( j in seq_len(years)){
    
    ages = ages + 1
    
    disturbed <- rbinom(length(ages), 1, p.init) # Coin flip per disturbence
    
    ages[which(disturbed==1)] <- 0
    
  } 
  
  return(ages)
} ## takes raster and disturbs it for a number of years
  

