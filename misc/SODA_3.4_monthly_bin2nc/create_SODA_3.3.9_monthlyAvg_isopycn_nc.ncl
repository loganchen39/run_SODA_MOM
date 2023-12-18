load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"

external LIBCLG "/glade/u/home/lgchen/lib/fortran/libclg.so"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_ROOT = "/glade/scratch/lgchen/project/SODA_3.3.9/month_avg"
    DIR_DATA_BIN  = DIR_DATA_ROOT + "/binary"
    DIR_DATA_NC   = DIR_DATA_ROOT + "/netcdf"

    var_nm_monthly = (/"depth", "temp", "salt"/)
  ; var_3d = (/True, True, True/)

    var_start_rec = (/0, 16, 32/)
    var_long_name = (/"depth of isoypycn"                              \
                    , "potential temperature at the depth of isopycn"  \
                    , "salinity at the depth of isopycn"/)

    var_units     = (/"m", "degrees C", "psu"/)

  ; var_valid_range = (/(/-10., 500./), (/-10., 100./), (/-100000., 100000./)/)

    var_missing_value = -1.e+20
  ; var_cell_methods  = "time: mean"
  ; var_time_avg_info = "average_T1,average_T2,average_DT"
  ; var_coordinates   = "geolon_t geolat_t"

  ; var_standard_name = (/"sea_water_potential_temperature"  \
  ;                     , "sea_water_salinity"               \
  ;                     , ""/)


    N_VAR        = dimsizes(var_nm_monthly)  ; 3

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 16

    START_YEAR = 1980
    END_YEAR   = 2015
    

    time      = new((/N_MONTH/), "float")
    latitude  = new((/NY     /), "float")
    longitude = new((/NX     /), "float")
  ; depth     = new((/NZ     /), "float")
    z         = new((/NZ     /), "float")

    time      = fspan(1, 12, 12)
    latitude  = fspan(-74.75, 89.75, 330)
    longitude = fspan(0.25, 359.75, 720)
    z         = (/1024.00, 1024.50, 1025.00, 1025.50, 1025.75  \
                , 1026.00, 1026.20, 1026.40, 1026.60, 1026.80  \
                , 1027.00, 1027.20, 1027.40, 1027.60, 1027.80  \
                , 1028.00/)

    time_att            = True
  ; time_att@_FillValue = -1.e+20
    time_att@units      = "month"
    time_att@long_nime  = "time"
  ; time_att@calendar   = "julian"
  ; time_att@modulo     = " "
  ; time_att@modulo_beg = "1980-01-15 00:00:00"
  ; time_att@modulo_end = "2015-12-15 00:00:00"
   
    latitude_att            = True
  ; latitude_att@_FillValue = -1.e+20
    latitude_att@axis       = "Y"
    latitude_att@units      = "degrees_north"
    latitude_att@long_name  = "latitude"
 
    longitude_att            = True
  ; longitude_att@_FillValue = -1.e+20
    longitude_att@axis       = "X"
    longitude_att@modulo     = 360.
    longitude_att@units      = "degrees_east"
    longitude_att@long_name  = "longitude"

    z_att            = True
  ; z_att@_FillValue = -1.e+20
    z_att@axis       = "Z"
    z_att@units      = "m"
    z_att@long_name  = "depth"

    var = new((/NZ, NY, NX/), "float", -1.e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda_3.3.1_mn_isopycn_" + str_year + ".grd"
        print("i_yr = " + str_year)

        fn_nc    = "soda3.3.1_mn_isopycn_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "c")

        ; define file (global) attributes
        print("Defining file attribute ...")
        global_att             = True
        global_att@description = "soda3.3.1 monthly average isopycn data with MOM5 driven by MERRA2 forcing!"
        fileattdef(fl_nc, global_att)

        ; define file dimensions
        print("Defining file dimensions ...")
        dim_names = (/"time" , "latitude", "longitude", "z"/)
        dim_sizes = (/N_MONTH, NY        , NX         , NZ     /)  
        dim_unlim = (/True   , False     , False      , False  /)  
        filedimdef(fl_nc, dim_names, dim_sizes, dim_unlim)

        ; define dimension vars
        filevardef(fl_nc, "time"     , "float", (/"time"     /))
        filevardef(fl_nc, "latitude" , "float", (/"latitude" /))
        filevardef(fl_nc, "longitude", "float", (/"longitude"/))
        filevardef(fl_nc, "z"        , "float", (/"z"        /))

        fl_nc->time      = time
        fl_nc->latitude  = latitude
        fl_nc->longitude = longitude
        fl_nc->z         = z    

        filevarattdef(fl_nc, "time"     , time_att     )
        filevarattdef(fl_nc, "latitude" , latitude_att )
        filevarattdef(fl_nc, "longitude", longitude_att)
        filevarattdef(fl_nc, "z"        , z_att        )

        print("Defining file var ...") 

        var_att = True
        do i_var = 0, 2 
            filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "z", "latitude", "longitude"/))

          ; var_att@standard_name = var_standard_name(i_var)

          ; var_att@coordinates   = var_coordinates  
          ; var_att@time_avg_info = var_time_avg_info
          ; var_att@cell_methods  = var_cell_methods
            var_att@missing_value = var_missing_value 
          ; var_att@valid_range   = var_valid_range(i_var, :)
            var_att@units         = var_units      (i_var)
            var_att@long_name     = var_long_name  (i_var)
            
            filevarattdef(fl_nc, var_nm_monthly(i_var), var_att)           
        end do

    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
