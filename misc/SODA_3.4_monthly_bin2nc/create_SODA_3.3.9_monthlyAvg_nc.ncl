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

  ; var_nm_monthly = (/"ssh", "mlt", "mlp", "mls", "net_heating", "salt_flux_total", "anompb", "taux", "tauy"  \
  ;     , "temp", "salt", "u", "v", "wt", "prho"/)
    var_nm_monthly = (/"temp", "salt", "wt", "ssh", "mlt", "mlp", "mls", "anompb", "net_heating"  \
        , "salt_flux_total", "prho", "u", "v", "taux", "tauy"/)
    var_3d = (/True, True, True, False, False, False, False, False, False, False, True, True, True, False, False/)

  ; var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 62, 112, 162, 212, 262/)
    var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 59, 109, 159, 209, 259/)
    var_long_name = (/"Potential temperature"                                             \
                    , "Practical Salinity"                                                \
                    , "dia-surface velocity T-points"                                     \
                    , "effective sea level (eta_t + patm/(rho0*g)) on T cells"            \
                    , "mixed layer depth determined by temperature criteria"              \
                    , "Depth of potential density mixed layer"                            \
                    , "mixed layer depth determined by salinity criteria"                 \
                    , "T-cell bottom pressure - rho0*grav*ht"                             \
                    , "surface ocean heat flux coming through coupler and mass transfer"  \
                    , "sfc_salt_flux_total"                                               \
                    , "potential density referenced to 0 dbar"                            \
                    , "i-current"                                                         \
                    , "j-current"                                                         \
                    , "i-directed wind stress forcing u-velocity"                         \
                    , "j-directed wind stress forcing v-velocity"/)

    var_units     = (/"degrees C", "psu", "m/sec", "meter", "m", "m", "m", "dbar", "Watts/m^2"  \
                    , "kg/(m^2*sec)", "kg/m^3", "m/sec", "m/sec", "N/m^2", "N/m^2"/)

    var_valid_range = (/(/-10., 500./), (/-10., 100./), (/-100000., 100000./), (/-1000., 1000./)  \
                    , (/0., 1000000./), (/-1000000., 1000000./), (/0., 1000000./), (/-1000000., 1000000./)  \
                    , (/-10000., 10000./), (/-10000., 10000./), (/-10., 100000./), (/-10., 10./)  \
                    , (/-10., 10./), (/-10., 10./), (/-10., 10./)/)

    var_missing_value = -1.e+20
    var_cell_methods  = "time: mean"
    var_time_avg_info = "average_T1,average_T2,average_DT"
    var_coordinates   = "geolon_t geolat_t"

    var_standard_name = (/"sea_water_potential_temperature"  \
                        , "sea_water_salinity"               \
                        , ""                                 \
                        , "sea_surface_height_above_geoid"   \
                        , ""                                 \
                        , ""                                 \
                        , ""                                 \
                        , ""                                 \
                        , ""                                 \
                        , ""                                 \
                        , "sea_water_potential_density"      \
                        , "sea_water_x_velocity"             \
                        , "sea_water_y_velocity"             \
                        , "surface_downward_x_stress"        \
                        , "surface_downward_y_stress"/)


    N_VAR        = dimsizes(var_nm_monthly)  ; 15

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 50

    START_YEAR = 1980
    END_YEAR   = 2015
    

    time      = new((/N_MONTH/), "float")
    latitude  = new((/NY     /), "float")
    longitude = new((/NX     /), "float")
    depth     = new((/NZ     /), "float")

    time      = fspan(1, 12, 12)
    latitude  = fspan(-74.75, 89.75, 330)
    longitude = fspan(0.25, 359.75, 720)
    depth     = (/5.03355, 15.10065, 25.21935, 35.35845, 45.57635  \
                , 55.86325, 66.26175, 76.80285, 87.57695, 98.62325 \
                , 110.0962, 122.1067, 134.9086, 148.7466, 164.0538 \
                , 181.3125, 201.2630, 224.7773, 253.0681, 287.5508 \
                , 330.0078, 382.3651, 446.7263, 524.9824, 618.7031 \
                , 728.6921, 854.9935, 996.7153, 1152.376, 1319.997 \
                , 1497.562, 1683.057, 1874.788, 2071.252, 2271.323 \
                , 2474.043, 2678.757, 2884.898, 3092.117, 3300.086 \
                , 3508.633, 3717.567, 3926.813, 4136.251, 4345.864 \
                , 4555.566, 4765.369, 4975.209, 5185.111, 5395.023/)

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

    depth_att            = True
  ; depth_att@_FillValue = -1.e+20
    depth_att@axis       = "Z"
    depth_att@units      = "m"
    depth_att@long_name  = "depth"

    var = new((/NZ, NY, NX/), "float", -1.e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda3.3.1_mn_ocean_" + str_year + ".grd"
        print("i_yr = " + str_year)

        fn_nc    = "soda3.3.1_mn_ocean_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "c")

        ; define file (global) attributes
        print("Defining file attribute ...")
        global_att             = True
        global_att@description = "soda3.3.1 monthly average data with MOM5 driven by MERRA2 forcing!"
        fileattdef(fl_nc, global_att)

        ; define file dimensions
        print("Defining file dimensions ...")
        dim_names = (/"time" , "latitude", "longitude", "depth"/)
        dim_sizes = (/N_MONTH, NY        , NX         , NZ     /)  
        dim_unlim = (/True   , False     , False      , False  /)  
        filedimdef(fl_nc, dim_names, dim_sizes, dim_unlim)

        ; define dimension vars
        filevardef(fl_nc, "time"     , "float", (/"time"     /))
        filevardef(fl_nc, "latitude" , "float", (/"latitude" /))
        filevardef(fl_nc, "longitude", "float", (/"longitude"/))
        filevardef(fl_nc, "depth"    , "float", (/"depth"    /))

        fl_nc->time      = time
        fl_nc->latitude  = latitude
        fl_nc->longitude = longitude
        fl_nc->depth     = depth

        filevarattdef(fl_nc, "time"     , time_att     )
        filevarattdef(fl_nc, "latitude" , latitude_att )
        filevarattdef(fl_nc, "longitude", longitude_att)
        filevarattdef(fl_nc, "depth"    , depth_att    )

        print("Defining file var ...") 

        var_att = True
        do i_var = 0, 14
            if (var_3d(i_var)) then
                filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "depth", "latitude", "longitude"/))
            else
                filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "latitude", "longitude"/))
            end if

            var_att@standard_name = var_standard_name(i_var)

          ; var_att@coordinates   = var_coordinates  
          ; var_att@time_avg_info = var_time_avg_info
            var_att@cell_methods  = var_cell_methods
            var_att@missing_value = var_missing_value 
            var_att@valid_range   = var_valid_range(i_var, :)
            var_att@units         = var_units      (i_var)
            var_att@long_name     = var_long_name  (i_var)
            
            filevarattdef(fl_nc, var_nm_monthly(i_var), var_att)           
        end do

        do i_var = 0, 14
          ; fl_nc->$var_nm_monthly(i_var)$@_FillValue   = -9.99e+8
          ; fl_nc->$var_nm_monthly(i_var)$@missingvalue = -1.e+20
        end do
    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
