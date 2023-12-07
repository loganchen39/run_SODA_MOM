#!/bin/tcsh

#PBS  -A UMCP0009   
#PBS  -l walltime=12:00:00              
# #PBS  -l select=1:ncpus=36:mpiprocs=36
#PBS  -l select=1:ncpus=1:mpiprocs=1 
#PBS  -N comp372
#PBS  -j oe
#PBS  -q regular
 
ncl ncks_compression.ncl >&! ncl_compression_001.log
 
exit 0
