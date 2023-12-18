load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_CODE_MOM_REGRID = "/glade/work/lgchen/project/MOM_TEST_Gena_SODA3.4.2a_20170503/MOM_TEST_mpt2.9/MOM_TEST/src/postprocessing/regrid/workdir/soda3.4.2_ocean_avg"
    DIR_ROOT_MOM_SODA   = "/glade/scratch/lgchen/project/soda3.4.2/2018/MOM_SODA"

  ; system("cd " + DIR_CODE_MOM_REGRID)  ; not useful anyway

    jul_day_20171222 = greg2jul(2017, 12, 22, -1)
    jul_day_20181217 = greg2jul(2018, 12, 17, -1)


    i_jul_day = jul_day_20171222

    do while (i_jul_day .le. jul_day_20181217)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)


        ; do horizontal interpolation with MOM postprocessing regrid tool
        ; ocean
        greg  = jul2greg(i_jul_day + 2)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_mom = str_curr_cycle + ".soda3.4.2shrt_5dy_ocean_or_" + str_fn_cycle + ".nc"
        fn_nc_mom = "soda3.4.2_5dy_ocean_or_" + str_fn_cycle + ".nc"

        system("ln -sf " + DIR_ROOT_MOM_SODA + "/link_forRegrid/" + fn_nc_mom + " ./MOM.ocean.nc")
        system("rm fms." + str_fn_cycle + ".out")
      ; system("mpirun.lsf  regrid.exe >&! fms." + str_fn_cycle + ".out")
        system("mpiexec_mpt regrid.exe >&! fms." + str_fn_cycle + ".out")

        fn_nc_soda = "soda3.4.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        system("cdo -f nc -b F32 copy " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/ocean/" + fn_nc_soda)
        system("rm " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc")
      ; system("mv -f " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/ocean/" + fn_nc_soda)


        greg  = jul2greg(i_jul_day + 7)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_mom = "soda3.4.2_5dy_ocean_or_" + str_fn_cycle + ".nc"

        system("ln -sf " + DIR_ROOT_MOM_SODA + "/link_forRegrid/" + fn_nc_mom + " ./MOM.ocean.nc")
        system("rm fms." + str_fn_cycle + ".out")
      ; system("mpirun.lsf  regrid.exe >&! fms." + str_fn_cycle + ".out")
        system("mpiexec_mpt regrid.exe >&! fms." + str_fn_cycle + ".out")

        fn_nc_soda = "soda3.4.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        system("cdo -f nc -b F32 copy " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/ocean/" + fn_nc_soda)
        system("rm " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc")
      ; system("mv -f " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/ocean/" + fn_nc_soda)


      ; ; ice failed
      ; fn_nc_mom = str_curr_cycle + ".ice.nc"

      ; system("ln -sf " + DIR_ROOT_MOM_SODA + "/" + str_curr_cycle + "/history/" + fn_nc_mom + " ./MOM.ocean.nc")
      ; system("ln -sf ./input.nml_ice_19811226_19881219 ./input.nml")
      ; system("rm fms." + str_curr_cycle + ".out")
      ; system("mpirun.lsf regrid.exe >&! fms." + str_curr_cycle + ".out")

      ; fn_nc_soda = "SODA_3.0_ice_" + str_curr_cycle + ".nc"
      ; system("mv -f " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA   \   
      ;     + "/MOM2SODA_interp/with_MOM_regrid_5days/" + fn_nc_soda)
      

        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
