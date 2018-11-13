#!/bin/bash -l
#$ -j y
#$ -l mem_per_core=18G
#$ -l h_rt=72:00:00
#$ -N make_oregon_7_1


module load R/3.5.0
module load gcc/7.2.0
module load gdal/2.2.3-unified
module load proj4/5.1.0

Rscript make_oregon_7_1.R
