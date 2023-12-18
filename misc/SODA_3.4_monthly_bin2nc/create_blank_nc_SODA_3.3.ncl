load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_BIN = "/glade/p/umcp0006/lgchen/project/MOM_run/SODA_3.3_1/monthly/binary_gena"
    DIR_DATA_NC  = "/glade/p/umcp0006/lgchen/project/MOM_run/SODA_3.3_1/monthly/nc_ligang"

  ; fn_bin_daily = (/"precsnoocnb.dat", "qv2m.dat", "rainocnb.dat", "slp.dat", "swgdnb.dat", "t2mb.dat", "u10mb.dat", "v10mb.dat"/)
    var_nm_monthly = (/"ssh", "mlt", "mlp", "mls", "sbd", "sbdmld", "sbddhdt", "sbdhorz", "sbdvert", "anompb", "taux", "tauy"  \
        , "temp", "salt", "u", "v", "w", "prho"/)
    var_units     = (/"m", "m", "m", "m", "kg/sec", "m", "kg/sec", "kg/sec", "kg/sec", "dbar", "", ""  \
                    , "C deg", "PSU", "m/s", "m/s", "m/s", ""/)
    var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 62, 112, 162, 212, 262/)
    var_long_name = (/"Sea Surface Height"                                                                        \
                    , "Mixed lyer depth etermined by temperature"                                                 \
                    , "Mixed lyer depth etermined by potential density"                                           \
                    , "Mixed lyer depth etermined by salinity"                                                    \
                    , "Rate of mass transferred below the mixed layer base (kg/sec)"                              \
                    , "Mixed layer depth used for subduction diagnostics (m)"                                     \
                    , "Rate of mass transferred below the mixed layer base due to dh/dt (kg/sec)"                 \
                    , "Rate of mass transferred below the mixed layer base due to horizontal advection (kg/sec)"  \
                    , "Rate of mass transferred below the mixed layer base due to vertical advection (kg/sec)"    \
                    , "T-cell bottom preasure minus rh0*grav*ht (dbar)"                                           \
                    , "Zonal windstress"                                                                          \
                    , "Meredialanl windstress"                                                                    \
                    , "Potential temperature (C deg)"                                                             \
                    , "Salinity (PSU)"                                                                            \
                    , "Zonal velosity"                                                                            \
                    , "Meredianal velosity"                                                                       \
                    , "Vertical velosity"                                                                         \
                    , "Potential density"/)

    N_VAR        = dimsizes(var_nm_monthly)

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 50

    START_YEAR = 1980
    END_YEAR   = 1989
    

    time      = new((/N_MONTH/), "float")
    latitude  = new((/NY   /), "float")
    longitude = new((/NX   /), "float")
    depth     = new((/NZ   /), "float")

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
    time_att@long_nime  = "time"
    time_att@units      = "month"
  ; time_att@calendar   = "julian"
  ; time_att@modulo     = " "
  ; time_att@modulo_beg = "1980-01-01 00:00:00"
  ; time_att@modulo_end = "2015-12-31 00:00:00"
   
    latitude_att           = True
    latitude_att@long_name = "latitude"
    latitude_att@units     = "degrees_north"
    latitude_att@axis      = "Y"
 
    longitude_att           = True
    longitude_att@long_name = "longitude"
    longitude_att@units     = "degrees_east"
    longitude_att@modulo    = 360.
    longitude_att@axis      = "X"

    depth_att           = True
    depth_att@long_name = "depth"
    depth_att@units     = "m"
    depth_att@axis      = "Z"

    var = new((/NZ, NY, NX/), "float", -1.0e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda_3.3_mn_ocean_" + str_year + ".grd"

        fn_nc    = "soda_3.3_mn_ocean_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "c")

        ; define file (global) attributes
        print("Defining file attribute ...")
        global_att             = True
        global_att@description = "SODA_3.3 monthly data with MOM5 driven by merra2!"
        fileattdef(fl_nc, global_att)

        ; define file dimensions
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

        var_att           = True
        do i_var = 0, 11
            filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "latitude", "longitude"/))

            var_att@long_name = var_long_name(i_var)
            var_att@units     = var_units    (i_var)
            filevarattdef(fl_nc, var_nm_monthly(i_var), var_att)
        end do

        do i_var = 12, 17
            filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "depth", "latitude", "longitude"/))

            var_att@long_name = var_long_name(i_var)
            var_att@units     = var_units    (i_var)
            filevarattdef(fl_nc, var_nm_monthly(i_var), var_att)
        end do

        print("Assigning file var ...") 

      ; ; the following NCL write out is too slow to be practical!
      ; do i_mon = 1, 12
      ;    do i_var = 0, 11
      ;        var(0, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*312 + i_var, (/NY, NX/), "float")
      ;        fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :) = var(0, :, :)
      ;    end do

      ;    do i_var = 12, 17
      ;        do i_rec = 0, 49
      ;            var(i_rec, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*312 + 12 + (i_var-12)*50 + i_rec, (/NY, NX/), "float")
      ;        end do

      ;        fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :, :) = var(:, :, :)
      ;    end do
      ; end do

        do i_var = 0, 17
            fl_nc->$var_nm_monthly(i_var)$@_FillValue   = -9.99e+8
            fl_nc->$var_nm_monthly(i_var)$@missingvalue = -9.99e+8
        end do
    end do
end
