
# Load Libraries
library(doMC)
library(foreach)
library(parallel)
library(igraph)
library(raster)
library(data.table)

# DENNIS: This option will required 50 GB per node
rasterOptions(maxmemory = 1e+10)

# DENNIS: This is the default value, requires about 8 GB per node
#rasterOptions(maxmemory = 1e+9)

#Detect Cores
nCores <- as.numeric(Sys.getenv("NSLOTS"))
if(is.na(nCores)) {
  # detect core, if not, set nCores=1
  nCores <- detectCores() # use all the cores available
}

# DENNIS: You can reduce the number of cores used to maximize memory per core.
nCores = 10

print(paste("using", nCores, "cores for this job"))
registerDoMC(nCores)

## Set up paths
code_dir <- "/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/code/"
data_dir <- "/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/Oregon/"
disturb_dir <- "/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/LANDFIRE/Previous_files/Florida/"
out_dir <- "/usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/out/"
print(paste0("code_dir=", code_dir))
print(paste0("data_dir=", data_dir))
print(paste0("out_dir=", out_dir))


year_id <- 2014

# Assemble paths to data
raster_img <- paste0(data_dir, "Oregon_7_1_", year_id, ".tif")
disturb_in <- paste0(disturb_dir, "disturb", 2000, ".csv")
out <- paste0(out_dir, "Oregon_7_1_", year_id, "dm2.csv")
print(paste0("raster file:", raster_img))
print(paste0("disturb file:", disturb_in))
print(paste0("out file:", out))

# Load raster and table
fire_only <- raster(raster_img)
csv <- read.table(disturb_in, sep=',', header=TRUE) 

## Write output
print(paste0("starting get_ratio_dist for year ",year_id))

csv_fire <- csv

fire_clump <- clump(fire_only, gaps = FALSE, directions = 4 )
names(fire_clump) <- "fire_clump"

### NEW  
ras_index <- fire_clump
ras_index <- setValues(ras_index, 1:ncell(ras_index))
names(ras_index) <- "index"


# Calculate "sizem" and save as DataFrame.  
# Use this DataFrame to append other columns later.
clump_df <- freq(fire_clump)

# Remove NA values
clump_df = na.omit(clump_df)  # <-DENNIS 10/2/2018: Moved this up, so NA values are removed before clump_list is created.

# Get list of clump IDs
clump_list <- unique(clump_df[,1])

# Update column names
colnames(clump_df) <- c("clno", "sizw")

# <- DENNIS 10/2/2018:  The NA filtering of clump_df was here.

### END NEW

## Get outer boundary
bound_r <- boundaries(fire_clump, type = "outer", directions = 4, classes= FALSE)
names(bound_r) <- "bound_r"

stack <- brick(c(fire_only, fire_clump, ras_index, bound_r))

#rm(ras_index)
#rm(fire_only)
#rm(fire_clump)
#rm(bound_r)



# For each fire clump determine dist_id, dist_name, and ratio
results <- foreach ( i = clump_list, .export=c("stack", "csv_fire"))  %dopar% { 


  print(i)
  filtered_by_clump <- stack[stack$fire_clump == i]

  
  # Extract dist_ids associated with clump
  unique_ids <- unique(filtered_by_clump[,1])
  
  # Extract string values associated with dist_ids
  string_vals <- unique(csv_fire$Dist_Type[csv_fire$Value %in% unique_ids])

  # Get cells touching outer edge
  touching_outer <- adjacent(stack$fire_clump, cells = filtered_by_clump[,3] ,directions = 4, target = stack[stack$bound_r != 0])
  

  # Get interior vertices
  touching_interior <- adjacent(stack$fire_clump, cells = filtered_by_clump[,3] ,directions = 4, target = filtered_by_clump[,3])
  
  # Extract touching cell sizes
  outer_size <- length(touching_outer[,1])
  inner_size <- length(touching_interior[,1])
  
  # Calculate ratio
  ratio_val <- inner_size / (inner_size + outer_size) 
  
  # Save results to a DataFrame
  df <- data.frame(clump_id = i,
                   ids = paste(unique_ids, collapse=' '), 
                   dist_name = paste(string_vals, collapse=', '),
                   ratio = ratio_val

                   )
  
}


# Merge results with clump_df by using the clump id
clump_df <- merge(clump_df, rbindlist(results), by.x='clno', by.y='clump_id')

print(paste0("writing output for year ", year_id) )

write.table(clump_df, out, sep=',') # write result to file name by variable 'out'








