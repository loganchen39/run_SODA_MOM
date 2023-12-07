#!/bin/tcsh


set STR_CURR_CYCLE              = $1
set DIR_CODE_REGRID_3D_SODA2MOM = $2
set DIR_ROOT_RUN_SODA           = $3
set str_time                    = $STR_CURR_CYCLE

echo STR_CURR_CYCLE              = $STR_CURR_CYCLE
echo DIR_CODE_REGRID_3D_SODA2MOM = $DIR_CODE_REGRID_3D_SODA2MOM
echo DIR_ROOT_RUN_SODA           = $DIR_ROOT_RUN_SODA
echo str_time                    = $str_time


cd $DIR_CODE_REGRID_3D_SODA2MOM/workdir/soda3.4.2
ln -sf $DIR_ROOT_RUN_SODA/$str_time.correctors.nc ./correctors.nc
rm -f fms.out.$str_time
mpiexec_mpt -n  512 regrid_3d.exe > fms.out.$str_time
mv regrid_3d_soda2mom_correctors.nc $DIR_ROOT_RUN_SODA/$str_time.soda2mom.correctors.nc

exit 0
