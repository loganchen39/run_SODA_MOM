load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"

external LIBCLG "/glade/u/home/lgchen/lib/fortran/libclg.so"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_ROOT = "/glade/scratch/lgchen/tmp/20170203_soda3.4.1_mn_bin"
    DIR_DATA_BIN  = DIR_DATA_ROOT
    DIR_DATA_NC   = DIR_DATA_ROOT + "/netcdf"

  ; var_nm_monthly = (/"hi", "hs", "mi", "cn"/)
  ; var_3d = (/False, False, False, True/)

    var_nm_monthly = (/"hi", "mi", "hs", "ui", "vi", "cn"/)
    var_3d = (/False, False, False, False, False, True/)

    var_start_rec = (/0, 1, 2, 3, 4, 5/)  ; 10 for one record
    var_long_name = (/"Sea Ice Thickness"  \
                    , "Sea Ice  Mass"      \
                    , "Snow Thickness"     \
                    , "Sea Ice velocity in X-direction"  \
                    , "Sea Ice velocity in Y-direction"  \
                    , "Sea Ice Concentration"/)

    var_units     = (/"m-ice", "kg/m^2", "m-snow", "m/s", "m/s", "0-1"/)

  ; var_valid_range = (/(/-10., 500./), (/-10., 100./), (/-100000., 100000./), (/-1000., 1000./)/)

    var_missing_value = -1.e+20
  ; var_cell_methods  = (/"time: mean", "time: mean", "time: mean", "time: mean ct: mean"/)
  ; var_time_avg_info = "average_T1,average_T2,average_DT"
  ; var_coordinates   = "geolon_t geolat_t"

  ; var_standard_name = (/"sea_water_potential_temperature"  \
  ;                     , "sea_water_salinity"               \
  ;                     , ""                                 \
  ;                     , "sea_surface_height_above_geoid"   \
  ;                     , ""                                 \
  ;                     , ""                                 \
  ;                     , ""                                 \
  ;                     , ""                                 \
  ;                     , ""                                 \
  ;                     , ""                                 \
  ;                     , "sea_water_potential_density"      \
  ;                     , "sea_water_x_velocity"             \
  ;                     , "sea_water_y_velocity"             \
  ;                     , "surface_downward_x_stress"        \
  ;                     , "surface_downward_y_stress"/)


    N_VAR        = dimsizes(var_nm_monthly)  ; 6 

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 5 

    START_YEAR = 1980
    END_YEAR   = 2015
    

    time      = new((/N_MONTH/), "float")
    latitude  = new((/NY     /), "float")
    longitude = new((/NX     /), "float")
    level     = new((/NZ     /), "float")

    time      = fspan(1, 12, 12)
    latitude  = fspan(-74.75, 89.75, 330)
    longitude = fspan(0.25, 359.75, 720)
    level     = (/0.0, 0.1, 0.3, 0.7, 1.1/)

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

    level_att            = True
  ; level_att@_FillValue = -1.e+20
    level_att@axis       = "Z"
    level_att@units      = "m"
    level_att@long_name  = "depth"

    var = new((/NZ, NY, NX/), "float", -1.e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda3.4.1_mn_ice_reg_" + str_year + ".grd"
        print("i_yr = " + str_year)

        fn_nc    = "soda3.4.1_mn_ice_reg_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "c")

        ; define file (global) attributes
        print("Defining file attribute ...")
        global_att             = True
        global_att@description = "soda3.4.1 ice monthly average data with MOM5 driven by ERA-Interim forcing!"
        fileattdef(fl_nc, global_att)

        ; define file dimensions
        print("Defining file dimensions ...")
        dim_names = (/"time" , "latitude", "longitude", "level"/)
        dim_sizes = (/N_MONTH, NY        , NX         , NZ     /)  
        dim_unlim = (/True   , False     , False      , False  /)  
        filedimdef(fl_nc, dim_names, dim_sizes, dim_unlim)

        ; define dimension vars
        filevardef(fl_nc, "time"     , "float", (/"time"     /))
        filevardef(fl_nc, "latitude" , "float", (/"latitude" /))
        filevardef(fl_nc, "longitude", "float", (/"longitude"/))
        filevardef(fl_nc, "level"    , "float", (/"level"    /))

        fl_nc->time      = time
        fl_nc->latitude  = latitude
        fl_nc->longitude = longitude
        fl_nc->level     = level

        filevarattdef(fl_nc, "time"     , time_att     )
        filevarattdef(fl_nc, "latitude" , latitude_att )
        filevarattdef(fl_nc, "longitude", longitude_att)
        filevarattdef(fl_nc, "level"    , level_att    )

        print("Defining file var ...") 

        var_att = True
        do i_var = 0, 5 
            if (var_3d(i_var)) then
                filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "level", "latitude", "longitude"/))
            else
                filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "latitude", "longitude"/))
            end if

          ; var_att@standard_name = var_standard_name(i_var)

          ; var_att@coordinates   = var_coordinates  
          ; var_att@time_avg_info = var_time_avg_info
          ; var_att@cell_methods  = var_cell_methods(i_var)
            var_att@missing_value = var_missing_value 
          ; var_att@valid_range   = var_valid_range(i_var, :)
            var_att@units         = var_units      (i_var)
            var_att@long_name     = var_long_name  (i_var)
            
            filevarattdef(fl_nc, var_nm_monthly(i_var), var_att)           
        end do
    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
