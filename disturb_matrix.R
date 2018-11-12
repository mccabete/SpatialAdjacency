#' @param ages matrix of stand age
#' @param p.init disturbance initiation probability
#' @param years number of years to simulate
#'
#' @return matrix of ages
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
  


#' @param ages matrix of stand age
#' @param p.init disturbance initiation probability (scalar or vector)
#' @param ps spread probability (scalar or matrix)
#' @param years number of years to simulate
#' @param maxAge if ps or p.init are scaler, what's the matrix dimension? 
#' @param returnAll return all years or just the last?
#'
#' @return
#' @export
#'
#' @examples
contagion_disturb_raster <- function (ages, p.init, ps, years, maxAge=100, returnAll = FALSE){
  
  if(is_scalar_double(p.init)) p.init = rep(p.init,maxAge)
  if(is_scalar_double(ps)) ps <- matrix(ps,maxAge,maxAge)
  nr <- nrow(ages)
  nc <- ncol(ages)
    
  for( j in seq_len(years)){
    print(j)
    
    ages = ages + 1
    ageT = ages; ageT[ages>maxAge] <- maxAge
    
    disturbed <- rbinom(length(ages), 1, p.init[ageT]) # Coin flip per disturbence
    
    queue <- which(disturbed==1)
    
    while(length(queue)>0){
      if(ages[queue[1]]>0){
        ## determine location of disturbance
        x <- queue[1]%%nr
        y <- ceiling(queue[1]/nr)
        
        ## check spread probability in each direction
        spread <- rep(0,4)
        myAge = ageT[x,y]
        spread[1] <- ifelse(y<nc,ps[myAge,ageT[x,y+1]],0) # north
        spread[2] <- ifelse(x<nr,ps[myAge,ageT[x+1,y]],0) # east
        spread[3] <- ifelse(y>1,ps[myAge,ageT[x,y-1]],0) # south
        spread[4] <- ifelse(x>1,ps[myAge,ageT[x-1,y]],0) # west
        spread[is.na(spread)] <- 0 ## catch previously disturbed
        
        ## put new disturbances in the queue
        newD <- rbinom(4,1,spread)
        if(newD[1]) queue[length(queue)+1] <- (y)*nr+x
        if(newD[2]) queue[length(queue)+1] <- (y-1)*nr+x+1
        if(newD[3]) queue[length(queue)+1] <- (y-2)*nr+x
        if(newD[4]) queue[length(queue)+1] <- (y-1)*nr+x-1
        
        ## place disturbance on site
        ages[queue[1]] <- 0  
      }
      
      #remove from queue
      queue <- queue[-1]
    }
      
  } 
  
  return(ages)
} ## takes raster and disturbs it for a number of years

