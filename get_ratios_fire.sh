#!/bin/bash -l
#$ -l mem_per_core=64G

module load R/3.5.0
module load gcc/7.2.0
module load gdal/2.2.3-unified
module load proj4/5.1.0

R_LIBS_USER=/projectnb/dietzelab/mccabete/R/library
echo $R_LIBS_USER

Rscript /usr3/graduate/tmccabe/mccabete/spatialadjacentcy/SpacialAdjacency/GEO_get_spatial_adjacentcy_fire.R 
