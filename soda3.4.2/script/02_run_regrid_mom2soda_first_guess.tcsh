#!/bin/tcsh


set STR_CURR_CYCLE           = $1
set DIR_CODE_REGRID_MOM2SODA = $2
set DIR_ROOT_RUN_MOM_ORG     = $3
set DIR_ROOT_RUN_SODA        = $4

echo STR_CURR_CYCLE           = $STR_CURR_CYCLE
echo DIR_CODE_REGRID_MOM2SODA = $DIR_CODE_REGRID_MOM2SODA
echo DIR_ROOT_RUN_MOM_ORG     = $DIR_ROOT_RUN_MOM_ORG
echo DIR_ROOT_RUN_SODA        = $DIR_ROOT_RUN_SODA


cd $DIR_CODE_REGRID_MOM2SODA/workdir/soda3.4.2
set str_time = $STR_CURR_CYCLE

ln -sf $DIR_ROOT_RUN_MOM_ORG/$str_time/history/$str_time.ocean.nc ./MOM.ocean.nc 
rm -f fms.$str_time.out
# mpirun.lsf regrid.exe > fms.$str_time.out
mpiexec_mpt -n 512 regrid.exe > fms.$str_time.out
mv -f regrid_MOM2SODA.nc $DIR_ROOT_RUN_SODA/$str_time.regrid_MOM2SODA.nc

exit 0
