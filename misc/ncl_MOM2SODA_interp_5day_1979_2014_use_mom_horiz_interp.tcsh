#!/bin/tcsh

#BSUB -P UMCP0006                # project code
#BSUB -W 06:00                    # wall-clock time (hrs:mins)
#BSUB -n 1                       # number of tasks in job         
##BSUB -R "span[ptile=16]"       # run 16 MPI tasks per node
#BSUB -J MOM2SODA_interp         # job name
#BSUB -o MOM2SODA_interp.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e MOM2SODA_interp.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                 # queue
#BSUB -N                         # sends report to you by e-mail when the job finishes

ncl MOM2SODA_interp_5day_1979_2014_use_mom_horiz_interp.ncl >&! ncl_bsub_0.log

exit 0
