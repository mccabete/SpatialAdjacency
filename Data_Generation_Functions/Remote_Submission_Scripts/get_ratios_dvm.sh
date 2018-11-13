#!/bin/bash -l
#$ -l mem_per_core=18G
#$ -l h_rt=72:00:00
#$ -pe omp 28
#$ -o ../qlog
#$ -j y
#$ -N oregon_dist_7_1_2014
#$ -m e

module load R/3.5.0
module load gcc/7.2.0
module load gdal/2.2.3-unified
module load proj4/5.1.0

Rscript dvm_code_v2.R 2014
