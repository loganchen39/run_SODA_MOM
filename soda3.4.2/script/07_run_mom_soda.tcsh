#!/bin/tcsh

###bsub << EOF
##### LSF batch script to run an MPI application
####BSUB -P UMCP0006            # project code
####BSUB -W 01:00               # wall-clock time (hrs:mins)
####BSUB -n 512                 # number of tasks in job         
####BSUB -R "span[ptile=16]"    # run 16 MPI tasks per node
####BSUB -J MOM_ORG             # job name
####BSUB -o MOM_ORG.%J.out      # output file name in which %J is replaced by the job ID
####BSUB -e MOM_ORG.%J.err      # error file name in which %J is replaced by the job ID
####BSUB -q premium             # queue: small, premium, regular, etc.
####BSUB -N                     # sends report to you by e-mail when the job finishes


# script command arguments
set STR_PREV_CYCLE        = $1
set STR_CURR_CYCLE        = $2
set START_YEAR            = $3
set START_MONTH           = $4
set START_DAY             = $5
set DIR_CODE_MOM_SODA     = $6
set DIR_INPUT_DATA_MOM    = $7
set DIR_ROOT_RUN_MOM_SODA = $8
set DIR_ROOT_RUN_SODA     = $9
set STR_TIME              = $STR_CURR_CYCLE

echo STR_PREV_CYCLE        = $STR_PREV_CYCLE
echo STR_CURR_CYCLE        = $STR_CURR_CYCLE
echo START_YEAR            = $START_YEAR
echo START_MONTH           = $START_MONTH
echo START_DAY             = $START_DAY
echo DIR_CODE_MOM_SODA     = $DIR_CODE_MOM_SODA
echo DIR_INPUT_DATA_MOM    = $DIR_INPUT_DATA_MOM
echo DIR_ROOT_RUN_MOM_SODA = $DIR_ROOT_RUN_MOM_SODA
echo DIR_ROOT_RUN_SODA     = $DIR_ROOT_RUN_SODA
echo STR_TIME              = $STR_TIME


# Minimal runscript for MOM experiments
set type          = MOM_SIS   
set platform      = cheyenne
set name          = $STR_TIME

# number of processors. Note: If you change npes you may need to change
# the layout in the corresponding namelist
set npes          = 8              

cd $DIR_CODE_MOM_SODA          # have to have this for "root" to be correct
set root          = $cwd       # or the upper-level directory: $cwd:h
set code_dir      = $root/src
rm work
ln -sf $DIR_ROOT_RUN_MOM_SODA ./work
set workdir       = $root/work
set expdir        = $workdir/$name
set inputDataDir  = $expdir/INPUT 

set diagtable     = $inputDataDir/diag_table
set datatable     = $inputDataDir/data_table
set fieldtable    = $inputDataDir/field_table
set namelist      = $inputDataDir/input.nml

set executable    = $root/exec/$platform/$type/fms_$type.x
# set archive       = $ARCHIVE/$type #Large directory to host the input and output data.


# Create MOM run directories and link/copy related data/configuration files
cd $workdir
mkdir -p $name
mkdir -p $name/INPUT
cd $name/INPUT
ln -sf $DIR_INPUT_DATA_MOM/INPUT_0/*.nc                         .
# ln -sf /glade/p/univ/umcp0009/FORCING/MOM0.1_FromGena_SuccessfulRunning/INPUT/*  .

# ln -sf $DIR_INPUT_DATA_MOM/forcing/ERA_I/*.nc                   .
# ln -sf $DIR_INPUT_DATA_MOM/forcing/ERA_I/2016/*.nc                   .
# ln -sf $DIR_INPUT_DATA_MOM/forcing/ERA_I/19790101_20161231/*.nc                   .
# ln -sf /glade2/h2/umcp0009/FORCING/ERA_I/2016_TimeAttributeCorrected/*.nc                   .

# ln -sf $DIR_INPUT_DATA_MOM/forcing/ERA_I/2016_2018/*.nc .
ln -sf /glade/scratch/lgchen/data/ERA5/netCDF/forcing/2018_2019/*.nc .
ln -sf $DIR_ROOT_RUN_SODA/$name.soda2mom.correctors.nc   ./ocean_cor.res.nc
if ($name == 19800101) then
    ln -sf /gpfs/fs1/work/lgchen/data/MOM5/RESTART/RESTART.19800101.20170721_Gena/*  .
#   ln -sf /glade/p/univ/umcp0009/FORCING/MOM0.1_FromGena_SuccessfulRunning/RESTART/* .
else
    ln -sf $DIR_ROOT_RUN_MOM_SODA/$STR_PREV_CYCLE/RESTART/*   .
#   ln -sf /glade/p/univ/umcp0009/FORCING/MOM0.1_FromGena_SuccessfulRunning/RESTART/* .
endif
rm -f data_table
rm -f field_table
rm -f diag_table
rm -f input.nml

# cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/19790101_20161231/data_table_19790101_20161231    ./data_table
# cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/19790101_20161231/field_table                     ./field_table   
# cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/19790101_20161231/diag_table_analysis             ./diag_table
# cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/19790101_20161231/input_analysis.nml              ./input.nml.template

cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/soda342_run/data_table_ERA5_2019            ./data_table
cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/soda342_run/field_table                     ./field_table   
cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/soda342_run/diag_table_analysis             ./diag_table
cp $DIR_INPUT_DATA_MOM/forcing/ERA_I/nml_table_soda342a/soda342_run/input_analysis.nml              ./input.nml.template
sed '/current_date/s/1980,1,1/'$START_YEAR','$START_MONTH','$START_DAY'/' input.nml.template >&! input.nml


#===========================================================================
# The user need not change any of the following
#===========================================================================
source $root/bin/environs.$platform  # environment variables and loadable modules

set mppnccombine  = $root/bin/mppnccombine.$platform  # path to executable mppnccombine
set time_stamp    = $root/bin/time_stamp.csh          # path to cshell to generate the date

set echo

# Check if the user has extracted the input data
if ( ! -d $inputDataDir ) then
    echo "ERROR: the experiment directory '$inputDataDir' does not exist or does not \
          contain input and preprocessing data directories!"
    echo "Please copy the input data from the MOM data directory. This may required \
          downloading data from a remote git annex if you do not already have the data locally."
    exit 1
endif

# setup directory structure
# if ( ! -d $expdir )         mkdir -p $expdir
if ( ! -d $expdir/RESTART ) mkdir -p $expdir/RESTART

# Check the existance of essential input files
if ( ! -e $inputDataDir/grid_spec.nc ) then
    echo "ERROR: required input file does not exist $inputDataDir/grid_spec.nc "
    exit 1
endif
if ( ! -e $inputDataDir/ocean_temp_salt.res.nc ) then
    echo "ERROR: required input file does not exist $inputDataDir/ocean_temp_salt.res.nc "
    exit 1
endif

# make sure executable is up to date
# set makeFile = Makefile
# cd $executable:h
# make -f $makeFile
# if ( $status != 0 ) then
#     unset echo
#     echo "ERROR: make failed"
#     exit 1
# endif

# Change to expdir
cd $expdir

# Create INPUT directory. Make a link instead of copy
# if ( ! -d $expdir/INPUT   ) mkdir -p $expdir/INPUT
if ( ! -e $namelist ) then
    echo "ERROR: required input file does not exist $namelist "
    exit 1
endif
if ( ! -e $datatable ) then
    echo "ERROR: required input file does not exist $datatable "
    exit 1
endif
if ( ! -e $diagtable ) then
    echo "ERROR: required input file does not exist $diagtable "
    exit 1
endif
if ( ! -e $fieldtable ) then
    echo "ERROR: required input file does not exist $fieldtable "
    exit 1
endif

cp $namelist   input.nml
cp $datatable  data_table
cp $diagtable  diag_table
cp $fieldtable field_table 


#Preprocessings
$root/exp/preprocessing.csh
  
# set runCommand = "mpirun.lsf $executable >fms.out"
set runCommand = "mpiexec_mpt -n 512 $executable >fms.out"
echo "About to run the command $runCommand"
$runCommand  # run the model

set model_status = $status
if ( $model_status != 0) then
    echo "ERROR: Model failed to run to completion"
    exit 1
endif


# generate date for file names
set begindate = `$time_stamp -bf digital`
if ( $begindate == "" ) set begindate = tmp`date '+%j%H%M%S'`
set enddate = `$time_stamp -ef digital`
if ( $enddate == "" ) set enddate = tmp`date '+%j%H%M%S'`
if ( -f time_stamp.out ) rm -f time_stamp.out

# get a tar restart file
cd RESTART
cp $expdir/input.nml .
cp $expdir/*_table .

# combine netcdf files
if ( $npes > 1 ) then
    #Concatenate blobs restart files. mppnccombine would not work on them.
    ncecat ocean_blobs.res.nc.???? ocean_blobs.res.nc
    rm ocean_blobs.res.nc.????
    set file_previous = ""
    set multires = (`ls *.nc.????`)

    foreach file ( $multires )
        if ( $file:r != $file_previous:r ) then
            set input_files = ( `ls $file:r.????` )
                if ( $#input_files > 0 ) then
                    $mppnccombine -n4 $file:r $input_files
                    if ( $status != 0 ) then
                        echo "ERROR: in execution of mppnccombine on restarts"
                        exit 1
                    endif
                    rm $input_files
                endif
        else
            continue
        endif
        set file_previous = $file
    end
endif

cd $expdir
mkdir history
mkdir ascii
# rename ascii files with the date
foreach out (`ls *.out`)
    mv $out ascii/$begindate.$out
end

# combine netcdf files
if ( $npes > 1 ) then
    #Don't combine blobs history files. They need special handling.
    mv ocean_blobs.nc.???? history/
    set file_previous = ""
    set multires = (`ls *.nc.????`)

    foreach file ( $multires )
        if ( $file:r != $file_previous:r ) then
            set input_files = ( `ls $file:r.????` )
            if ( $#input_files > 0 ) then
                $mppnccombine -n4 $file:r $input_files
                if ( $status != 0 ) then
                    echo "ERROR: in execution of mppnccombine on restarts"
                    exit 1
                endif
                rm $input_files
            endif
        else
            continue
        endif
        set file_previous = $file
    end
endif

# rename nc files with the date
foreach ncfile (`/bin/ls *.nc`)
#   mv $ncfile history/$begindate.$ncfile
    mv $ncfile history/$ncfile
end

unset echo

echo end_of_run
echo "NOTE: Natural end-of-script."


## Archive the results
# cd $workdir
# tar cvf $name.output.tar --exclude=data_table --exclude=diag_table --exclude=field_table \
#     --exclude=fms_$type.x --exclude=input.nml --exclude=INPUT $name
# gzip $name.output.tar
# mv $name.output.tar.gz $archive/

exit 0

###EOF
