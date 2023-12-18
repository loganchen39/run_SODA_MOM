#!/bin/tcsh

#BSUB -P UMCP0006                # project code
#BSUB -W 02:00                    # wall-clock time (hrs:mins)
#BSUB -n 512                     # number of tasks in job         
# #BSUB -n 511                   # number of tasks in job         
##BSUB -R "span[ptile=16]"       # run 16 MPI tasks per node
#BSUB -J MPI_03         # job name
#BSUB -o MPI_03.%J.out  # output file name in which %J is replaced by the job ID
#BSUB -e MPI_03.%J.err  # error file name in which %J is replaced by the job ID
#BSUB -q premium                 # queue
#BSUB -N                         # sends report to you by e-mail when the job finishes

mpirun.lsf ./soda.exe >&! test.log
# mpirun.lsf /usr/bin/valgrind --log-file=valgrind.%p.out ./soda.exe >&! test.log
# mpirun.lsf /usr/bin/valgrind  ./soda.exe >&! test.log

exit 0

