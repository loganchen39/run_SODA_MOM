load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    ; Directories
    DIR_SCRIPT               = "/glade/u/home/lgchen/project/SODA_MOM/rocoto_xml/soda3.4.2/script"
    DIR_CODE_MOM_ORG         = "/glade/work/lgchen/project/soda3.4.2_exe"  ; work -> "soda3.4.2/MOM_org"
  ; DIR_CODE_REGRID_MOM2SODA = DIR_CODE_MOM_ORG + "/src/postprocessing/regrid"  ; "/workdir/SODA_3.5_1"
    DIR_CODE_REGRID_MOM2SODA = "/glade/work/lgchen/project/MOM_TEST_Gena_SODA3.4.2a_20170503/MOM_TEST_mpt2.9/MOM_TEST/src/postprocessing/regrid/"  ; "/workdir/soda3.4.2"
    DIR_CODE_SODA            = "/glade/u/home/lgchen/project/SODA_run/run/soda3.4.2"
    FN_EXE_SODA              = "soda.exe"
    DIR_CODE_REGRID_3D_SODA2MOM = "/glade/work/lgchen/project/MOM_TEST_Gena_SODA3.4.2a_20170503/MOM_TEST_mpt2.9/MOM_TEST/src/preprocessing/regrid_3d/"  ; /workdir/soda3.4.2 
    DIR_CODE_MOM_SODA        = "/glade/work/lgchen/project/soda3.4.2_exe"

    DIR_ROOT_DATA      = "/glade/work/lgchen/data"
    DIR_INPUT_DATA_MOM = DIR_ROOT_DATA + "/MOM5"
    DIR_OBS_DATA_SODA  = DIR_ROOT_DATA + "/SODA"

    DIR_ROOT_RUN_MOM      = "/glade/scratch/lgchen/project/soda3.4.2/2019"
    DIR_ROOT_RUN_MOM_ORG  = DIR_ROOT_RUN_MOM + "/MOM_org"
    DIR_ROOT_RUN_SODA     = DIR_ROOT_RUN_MOM + "/SODA"
    DIR_ROOT_RUN_MOM_SODA = DIR_ROOT_RUN_MOM + "/MOM_SODA"

    DIR_LOG = "/glade/u/home/lgchen/project/SODA_MOM/rocoto_xml/soda3.4.2/log"

    PROC_MOM  = 512
    PROC_SODA = 32


    jul_day_20190625 = greg2jul(2019, 6 , 25, -1)
  ; jul_day_20150825 = greg2jul(2015, 8 , 25, -1)
    jul_day_20200131 = greg2jul(2020, 1 , 31, -1)
    
    i_jul_day = jul_day_20190625

  ; str_prev_cycle = "null"      ; it can not be ""
    str_prev_cycle = "20190615"


    do while(i_jul_day .lt. jul_day_20200131)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        greg       = jul2greg(i_jul_day+5)
        i_yr_soda  = greg(0)
        i_mon_soda = greg(1)
        i_day_soda = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_prev_cycle = " + str_prev_cycle)
        print("str_curr_cycle = " + str_curr_cycle)


        ; 01_MOM_org
        print("01_MOM_org ...")
      ; print("MOM_org_start_time: " + systemfunc("date"))
        str_cmd = DIR_SCRIPT + "/01_run_mom_org.tcsh " + str_prev_cycle + " " + str_curr_cycle + " "  \
            + i_yr + " " + i_mon + " " + i_day + " " + DIR_CODE_MOM_ORG + " " + DIR_INPUT_DATA_MOM    \
            + " " + DIR_ROOT_RUN_MOM
        system(str_cmd)
      ; print("MOM_org_end_time: " + systemfunc("date"))
        fn_exist_check = DIR_ROOT_RUN_MOM_ORG + "/" + str_curr_cycle + "/history/" + str_curr_cycle + ".ocean.nc"
        if (.not. isfilepresent(fn_exist_check)) then
            print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 01_MOM_org, file not existed!")
            exit()
        end if


        ; 02_regrid_mom2soda_first_guess
        print("02_regrid_mom2soda_first_guess ...")
        str_cmd = DIR_SCRIPT + "/02_run_regrid_mom2soda_first_guess.tcsh " + str_curr_cycle + " "  \
            + DIR_CODE_REGRID_MOM2SODA + " " +  DIR_ROOT_RUN_MOM_ORG + " " + DIR_ROOT_RUN_SODA
        system(str_cmd)
      ; fn_exist_check = DIR_ROOT_RUN_SODA + "/" + str_curr_cycle + ".regrid_MOM2SODA.nc"
      ; if (.not. isfilepresent(fn_exist_check)) then
      ;     print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 02_regrid_mom2soda_first_guess, file not existed!")
      ;     exit()
      ; end if


        ; 03_nc2bin_mom2soda_first_guess
        print("03_nc2bin_mom2soda_first_guess ...")
        str_cmd = "ncl " + "str_time=" + str_curr_cycle + " " + DIR_SCRIPT + "/03_nc2bin_mom2soda_first_guess.ncl" 
        print(str_cmd)
        system(str_cmd)
      ; fn_exist_check = DIR_ROOT_RUN_SODA + "/" + str_curr_cycle + ".first_guess.dat"
      ; if (.not. isfilepresent(fn_exist_check)) then
      ;     print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 03_nc2bin_mom2soda_first_guess, file not existed!")
      ;     exit()
      ; end if


        ; 04_run_soda
        print("04_run_soda ...")
        print("SODA_start_time: " + systemfunc("date"))
        str_cmd = DIR_SCRIPT + "/04_run_soda.tcsh " + str_curr_cycle + " " + DIR_CODE_SODA + " "  \
            + DIR_ROOT_RUN_SODA + " " + i_yr_soda + " " + i_mon_soda + " " + i_day_soda
        system(str_cmd)
        print("SODA_end_time: " + systemfunc("date"))
      ; fn_exist_check = DIR_ROOT_RUN_SODA + "/" + str_curr_cycle + ".correctors.dat"
      ; if (.not. isfilepresent(fn_exist_check)) then
      ;     print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 04_run_soda, file not existed!")
      ;     exit()
      ; end if
      


        ; 05_bin2nc_soda_correctors_temp_salt_corr
        print("05_bin2nc_soda_correctors_temp_salt_corr ...")
        str_cmd = "ncl " + "str_time=" + str_curr_cycle + " " + DIR_SCRIPT + "/05_bin2nc_soda_correctors_temp_salt_corr.ncl" 
        system(str_cmd)
      ; fn_exist_check = DIR_ROOT_RUN_SODA + "/" + str_curr_cycle + ".correctors.nc"
      ; if (.not. isfilepresent(fn_exist_check)) then
      ;     print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 05_nc2bin_mom2soda_first_guess, file not existed!")
      ;     exit()
      ; end if
      

        ; 06_run_regrid_3d_soda2mom_correctors
        print("06_run_regrid_3d_soda2mom_correctors ...")
        str_cmd = DIR_SCRIPT + "/06_run_regrid_3d_soda2mom_correctors.tcsh " + str_curr_cycle + " " + DIR_CODE_REGRID_3D_SODA2MOM  \
            + " " + DIR_ROOT_RUN_SODA
        system(str_cmd)
      ; fn_exist_check = DIR_ROOT_RUN_SODA + "/" + str_curr_cycle + ".soda2mom.correctors.nc"
      ; if (.not. isfilepresent(fn_exist_check)) then
      ;     print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 06_run_regrid_3d_soda2mom_correctors, file not existed!")
      ;     exit()
      ; end if

      
      ; ; 06_2_set_soda2mom_corrector_scor_tcor_zero
      ; print("06_2_set_soda2mom_corrector_scor_tcor_zero ...")
      ; str_cmd = "ncl " + "str_time=" + str_curr_cycle + " " + DIR_SCRIPT + "/06_2_set_soda2mom_corrector_scor_tcor_zero.ncl" 
      ; system(str_cmd)
      ; fn_exist_check = DIR_ROOT_RUN_SODA + "/" + str_curr_cycle + ".soda2mom.correctors.nc"
      ; if (.not. isfilepresent(fn_exist_check)) then
      ;     print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 06_2_set_soda2mom_corrector_scor_tcor_zero, file not existed!")
      ;     exit()
      ; end if


        ; 07_run_mom_soda
        print("07_run_mom_soda ...")
      ; start_time = get_cpu_time()
      ; print("MOM_SODA_start_time: " + systemfunc("date"))
        str_cmd = DIR_SCRIPT + "/07_run_mom_soda.tcsh " + str_prev_cycle + " " + str_curr_cycle + " "  \
            + i_yr + " " + i_mon + " " + i_day + " " + DIR_CODE_MOM_SODA + " " + DIR_INPUT_DATA_MOM    \
            + " " + DIR_ROOT_RUN_MOM_SODA + " " + DIR_ROOT_RUN_SODA
        system(str_cmd)
      ; print("CPU_time_MOM_SODA: " + (get_cpu_time() - start_time))
      ; print("MOM_SODA_end_time: " + systemfunc("date"))

      ; fn_exist_check = DIR_ROOT_RUN_MOM_SODA + "/" + str_curr_cycle + "/history/" + str_curr_cycle + ".ocean.nc"
      ; if (.not. isfilepresent(fn_exist_check)) then
      ;     print("ERROR: str_curr_cycle = " + str_curr_cycle + ", 07_run_mom_soda, file not existed!")
      ;     exit()
      ; end if

        str_prev_cycle = str_curr_cycle
        i_jul_day        = i_jul_day + 10
    end do  ; end of "do while(i_jul_day .lt. jul_day_20140101)"
end
