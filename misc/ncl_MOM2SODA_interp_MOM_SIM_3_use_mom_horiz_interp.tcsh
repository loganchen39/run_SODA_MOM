#!/bin/tcsh

#BSUB -P UMCP0006                # project code
#BSUB -W 12:00                    # wall-clock time (hrs:mins)
#BSUB -n 1                       # number of tasks in job         
##BSUB -R "span[ptile=16]"       # run 16 MPI tasks per node
#BSUB -J MOM_SIM_interp         # job name
#BSUB -o MOM_SIM_interp.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e MOM_SIM_interp.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                 # queue
#BSUB -N                         # sends report to you by e-mail when the job finishes

ncl MOM2SODA_interp_MOM_SIM_3_use_mom_horiz_interp.ncl >&! ncl_bsub_10.log
 
exit 0
