load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_MOM_SODA = "/aosc/desert/chepurin/SODA3.3.0/REGRIDED"


    jul_day_19800101 = greg2jul(1980, 1 , 1 , -1)
    jul_day_20151225 = greg2jul(2015, 12, 25, -1)
    jul_day_19991222 = greg2jul(1999, 12, 22, -1)

    i_jul_day = jul_day_19800101

    START_YEAR = 1980
    END_YEAR   = 2015

    i_yr = START_YEAR

    do while (i_yr .le. END_YEAR)
        ; ocean    
        str_yr = sprinti("%0.4i", i_yr)
        print("i_yr = " + str_yr)
        fn_nc_mom  = "soda3.3.0_mn_ocean_" + str_yr + ".grd"
        fn_nc_soda = "soda3.3.0_mn_ocean_reg_" + str_yr + ".grd"
        system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)

      ; ; isopycn  
      ; str_yr = sprinti("%0.4i", i_yr)
      ; fn_nc_mom  = "soda3.3.1_mn_isopycn_" + str_yr + ".nc"
      ; fn_nc_soda = "soda3.3.1_mn_isopycn_reg_" + str_yr + ".nc"
      ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


        i_yr = i_yr + 1
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
