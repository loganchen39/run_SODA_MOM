#! /bin/sh

rm *.err *.out fms.out

bsub << EOF
#!/bin/csh
#
## LSF batch script to run an MPI application
#
#BSUB -P UMCP0006              # project code
#BSUB -W 01:00                 # wall-clock time (hrs:mins)
#BSUB -n 512                   # number of tasks in job         
#BSUB -R "span[ptile=16]"      # run 16 MPI tasks per node
#BSUB -J soda_mpi                # job name
#BSUB -o soda_mpi.%J.out         # output file name in which %J is replaced by the job ID
#BSUB -e soda_mpi.%J.err         # error file name in which %J is replaced by the job ID
# #BSUB -q regular               # queue
#BSUB -q premium               # queue
#BSUB -N                       # sends report to you by e-mail when the job finishes

#run the executable
mpirun.lsf soda.exe >&! fms.out

EOF
