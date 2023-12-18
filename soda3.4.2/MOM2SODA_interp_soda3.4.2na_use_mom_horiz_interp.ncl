load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_CODE_MOM_REGRID = "/gpfs/fs1/work/lgchen/project/MOM_TEST_Gena_SODA3.4.2a_20170503/MOM_TEST/src/postprocessing/regrid/workdir/soda3.4.2na_ocean_avg"
  ; DIR_ROOT_MOM_SODA   = "/glade2/scratch2/lgchen/project/soda3.4.2na/MOM_SODA"
    DIR_ROOT_MOM_SODA   = "/gpfs/fs1/scratch/lgchen/project/soda3.4.2na/MOM_SODA"

  ; system("cd " + DIR_CODE_MOM_REGRID)  ; not useful anyway

    jul_day_20161107 = greg2jul(2016, 11, 7 , -1)
    jul_day_20161217 = greg2jul(2016, 12, 17, -1)

    i_jul_day = jul_day_20161107

    do while (i_jul_day .le. jul_day_20161217)
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
        fn_nc_mom = "soda3.4.2na_5dy_ocean_or_" + str_fn_cycle + ".nc"

        system("ln -sf " + DIR_ROOT_MOM_SODA + "/link_forRegrid/" + fn_nc_mom + " ./MOM.ocean.nc")
        system("rm fms." + str_fn_cycle + ".out")
      ; system("mpirun.lsf  regrid.exe >&! fms." + str_fn_cycle + ".out")
        system("mpiexec_mpt regrid.exe >&! fms." + str_fn_cycle + ".out")

        fn_nc_soda = "soda3.4.2na_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        system("mv -f " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA   \   
            + "/MOM2SODA_interp/ocean/" + fn_nc_soda)


        greg  = jul2greg(i_jul_day + 7)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_mom = "soda3.4.2na_5dy_ocean_or_" + str_fn_cycle + ".nc"

        system("ln -sf " + DIR_ROOT_MOM_SODA + "/link_forRegrid/" + fn_nc_mom + " ./MOM.ocean.nc")
        system("rm fms." + str_fn_cycle + ".out")
      ; system("mpirun.lsf  regrid.exe >&! fms." + str_fn_cycle + ".out")
        system("mpiexec_mpt regrid.exe >&! fms." + str_fn_cycle + ".out")

        fn_nc_soda = "soda3.4.2na_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        system("mv -f " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA   \   
            + "/MOM2SODA_interp/ocean/" + fn_nc_soda)


        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
