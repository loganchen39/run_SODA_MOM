load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_OCEAN = "/aosc/greenland/soda3.4.2/ORIGINAL/ocean"
    DIR_EVAP  = "/aosc/greenland/soda3.4.2/ORIGINAL/extract_ocean_evap"

    FN_PREF_OCEAN = "soda3.4.2_5dy_ocean_or_"
    FN_PREF_EVAP  = "soda3.4.2_5dy_evap_heat_or_"

    jul_day_19910123 = greg2jul(1991, 1 , 23, -1)
    jul_day_20160531 = greg2jul(2016, 5 , 31, -1)

    i_jul_day = jul_day_19910123

    do while (i_jul_day .lt. jul_day_20160531)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)

        greg         = jul2greg(i_jul_day + 2)
        i_yr         = greg(0)
        i_mon        = greg(1)
        i_day        = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_ocean  = FN_PREF_OCEAN + str_fn_cycle + ".nc"
        fn_nc_evap   = FN_PREF_EVAP  + str_fn_cycle + ".nc"

        if (isfilepresent(DIR_OCEAN + "/" + fn_nc_ocean)) then
            fl_nc_ocean = addfile(DIR_OCEAN + "/" + fn_nc_ocean, "r")
            fl_nc_evap  = addfile(DIR_EVAP  + "/" + fn_nc_evap , "c")

            fl_nc_evap->evap_heat = fl_nc_ocean->evap_heat
        else
            print("File " + fn_nc_ocean + " not existed!")
        end if


        greg         = jul2greg(i_jul_day + 7)
        i_yr         = greg(0)
        i_mon        = greg(1)
        i_day        = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_ocean  = FN_PREF_OCEAN + str_fn_cycle + ".nc"
        fn_nc_evap   = FN_PREF_EVAP  + str_fn_cycle + ".nc"

        if (isfilepresent(DIR_OCEAN + "/" + fn_nc_ocean)) then
            fl_nc_ocean = addfile(DIR_OCEAN + "/" + fn_nc_ocean, "r")
            fl_nc_evap  = addfile(DIR_EVAP  + "/" + fn_nc_evap , "c")

            fl_nc_evap->evap_heat = fl_nc_ocean->evap_heat
        else
            print("File " + fn_nc_ocean + " not existed!")
        end if

        i_jul_day = i_jul_day + 10
    end do

    system("exit 0")
end
