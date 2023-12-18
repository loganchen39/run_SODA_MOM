load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_MOM_SODA   = "/gpfs/fs1/scratch/lgchen/project/soda3.4.2/MOM_SODA/MOM2SODA_interp/ocean/transferred"


    jul_day_20161227 = greg2jul(2016, 12, 27, -1)
    jul_day_20171222 = greg2jul(2017, 12, 22, -1)


  ; jul_day_20151225 = greg2jul(2015, 12, 25, -1)

    i_jul_day = jul_day_20161227

    do while (i_jul_day .le. jul_day_20171222)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)

        ; ocean
        greg  = jul2greg(i_jul_day + 2)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_f64 = "soda3.4.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        fn_nc_f32 = "soda3.4.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"

        system("cdo -f nc -b F32 copy " + DIR_DATA_MOM_SODA + "/double/" + fn_nc_f64 + " " + DIR_DATA_MOM_SODA + "/float/" + fn_nc_f32)


        greg  = jul2greg(i_jul_day + 7)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_f64 = "soda3.4.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        fn_nc_f32 = "soda3.4.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"

        system("cdo -f nc -b F32 copy " + DIR_DATA_MOM_SODA + "/double/" + fn_nc_f64 + " " + DIR_DATA_MOM_SODA + "/float/" + fn_nc_f32)


        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
