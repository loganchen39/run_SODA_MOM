#!/bin/tcsh

#BSUB -P UMCP0006                   # project code
#BSUB -W 12:00                      # wall-clock time (hrs:mins)
# #BSUB -W 01:00                      # wall-clock time (hrs:mins)
#BSUB -n 512                        # number of tasks in job         
# #BSUB -R "span[ptile=16]"         # run 16 MPI tasks per node
#BSUB -J soda342                    # job name
#BSUB -o soda342.%J.out             # output file name in which %J is replaced by the job ID
#BSUB -e soda342.%J.err             # error file name in which %J is replaced by the job ID
# #BSUB -q premium                  # queue
#BSUB -q regular                    # queue
#BSUB -N                            # sends report to you by e-mail when the job finishes
 
ncl SODA_MOM_1979_2014.ncl >&! ncl_bsub_063.log
 
exit 0
