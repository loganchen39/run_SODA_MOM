#!/bin/tcsh

#PBS  -A UMCP0009   
#PBS  -l walltime=12:00:00
#PBS  -l select=16:ncpus=32:mpiprocs=32 
#PBS  -N soda342
#PBS  -j oe
# #PBS  -q premium
#PBS  -q regular
 
ncl SODA_MOM_1979_2014.ncl >&! ncl_bsub_092.log
 
exit 0
