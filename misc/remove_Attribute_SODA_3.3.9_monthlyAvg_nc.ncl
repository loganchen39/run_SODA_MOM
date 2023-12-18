load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_ROOT = "/aosc/desert/chepurin/SODA3.3.1"
    DIR_DATA_BIN  = DIR_DATA_ROOT + "/binary"
    DIR_DATA_NC   = DIR_DATA_ROOT + "/REGRIDED"


    START_YEAR = 1980
    END_YEAR   = 2015
    
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        print("i_yr = " + str_year)
        fn_nc    = "soda3.3.1_mn_ocean_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "w")

        str_cmd = "ncatted -a _FillValue,time,d,f,0.0 " + DIR_DATA_NC + "/" + fn_nc
      ; print(str_cmd)
        system(str_cmd)

        str_cmd = "ncatted -a _FillValue,latitude,d,f,0.0 " + DIR_DATA_NC + "/" + fn_nc
      ; print(str_cmd)
        system(str_cmd)

        str_cmd = "ncatted -a _FillValue,longitude,d,f,0.0 " + DIR_DATA_NC + "/" + fn_nc
      ; print(str_cmd)
        system(str_cmd)

        str_cmd = "ncatted -a _FillValue,depth,d,f,0.0 " + DIR_DATA_NC + "/" + fn_nc
      ; print(str_cmd)
        system(str_cmd)
    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
