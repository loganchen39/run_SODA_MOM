#!/bin/tcsh

#BSUB -P UMCP0006                  # project code
#BSUB -W 12:00                     # wall-clock time (hrs:mins)
#BSUB -n 1                         # number of tasks in job         
##BSUB -R "span[ptile=16]"         # run 16 MPI tasks per node
#BSUB -J SODA_5day2monthly         # job name
#BSUB -o SODA_5day2monthly.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e SODA_5day2monthly.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                   # queue
#BSUB -N                           # sends report to you by e-mail when the job finishes

#cd $DIR_CODE_REGRID_MOM2SODA/workdir/2011_2013
#set str_time = $STR_CURR_CYCLE

ncl MOM2SODA_interp_2011_2013_use_linint2.ncl >&! ncl_bsub_0.log

exit 0
