load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_MOM_SODA   = "/glade2/scratch2/lgchen/project/soda3.4.2_HalfOBS/SODA/correctors.nc"


    jul_day_20081010 = greg2jul(2008, 10, 10, -1)
    jul_day_20161217 = greg2jul(2016, 12, 17, -1)

  ; jul_day_20151225 = greg2jul(2015, 12, 25, -1)

    i_jul_day = jul_day_20081010

    do while (i_jul_day .le. jul_day_20161217)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)


        ; soda corrector
        greg  = jul2greg(i_jul_day + 5)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_mom  = str_curr_cycle + ".correctors.nc"
        fn_nc_soda = "soda3.4.2h_10dy_incr_1x1_" + str_fn_cycle + ".nc"

        system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)

        if (.not. isfilepresent(DIR_DATA_MOM_SODA + "/" + fn_nc_soda)) then
            print ("file not exist: " + fn_nc_soda)
        end if

        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
