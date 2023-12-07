#!/usr/bin/python3

# set Big Endian for read and write.

# Set up directories.
DIR_SCRIPT                  = "/glade/u/home/lgchen/project/SODA_MOM/rocoto_xml/soda3.4.2/script"
DIR_CODE_MOM_ORG            = "/glade/work/lgchen/project/soda3.4.2_exe"  # work -> "soda3.4.2/MOM_org"
DIR_CODE_REGRID_MOM2SODA    = "/glade/work/lgchen/project/MOM_TEST_Gena_SODA3.4.2a_20170503/MOM_TEST_mpt2.9/MOM_TEST/src/postprocessing/regrid/"  # "/workdir/soda3.4.2"
DIR_CODE_SODA               = "/glade/u/home/lgchen/project/SODA_run/run/soda3.4.2"
FN_EXE_SODA                 = "soda.exe"
DIR_CODE_REGRID_3D_SODA2MOM = "/glade/work/lgchen/project/MOM_TEST_Gena_SODA3.4.2a_20170503/MOM_TEST_mpt2.9/MOM_TEST/src/preprocessing/regrid_3d/"  # /workdir/soda3.4.2
DIR_CODE_MOM_SODA           = "/glade/work/lgchen/project/soda3.4.2_exe"

DIR_ROOT_DATA      = "/glade/work/lgchen/data"
DIR_INPUT_DATA_MOM = DIR_ROOT_DATA + "/MOM5"
DIR_OBS_DATA_SODA  = DIR_ROOT_DATA + "/SODA"

DIR_ROOT_RUN_MOM      = "/glade/scratch/lgchen/project/soda3.4.2/2018"
DIR_ROOT_RUN_MOM_ORG  = DIR_ROOT_RUN_MOM + "/MOM_org"
DIR_ROOT_RUN_SODA     = DIR_ROOT_RUN_MOM + "/SODA"
DIR_ROOT_RUN_MOM_SODA = DIR_ROOT_RUN_MOM + "/MOM_SODA"
DIR_LOG = "/glade/u/home/lgchen/project/SODA_MOM/rocoto_xml/soda3.4.2/log"

PROC_MOM  = 512
PROC_SODA = 32


