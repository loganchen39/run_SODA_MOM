load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_BIN = "/aosc/greenland/soda3.4.1/REGRIDED"
    DIR_DATA_NC  = "/homes/metofac/lchen/project/SODA_3.3_monthly_bin2nc/soda3.4.1"

    var_nm_monthly = (/"ssh", "mlt", "mlp", "mls", "hflx", "sflx",           "taux", "tauy"  \
        , "temp", "salt", "u", "v", "w", "prho"/)
    var_units     = (/"m", "m", "m", "m", "Watts/m^2", "kg/(m^2*sec)",         "", ""  \
                    , "C deg", "PSU", "m/s", "m/s", "m/s", ""/)
  ; var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 62, 112, 162, 212, 262/)
    var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 58, 108, 158, 208, 258/)
    var_long_name = (/"Sea Surface Height"                                                                        \
                    , "Mixed layer depth determined by temperature"                                               \
                    , "Mixed layer depth determined by potential density"                                         \
                    , "Mixed layer depth determined by salinity"                                                  \
                    , "Surface ocean heat flux coming through coupler and mass transfer, (Watts/m^2)"             \
                    , "Sfc_salt_flux_total, (kg/(m^2*sec))"                                                       \
                    , "Zonal windstress"                                                                          \
                    , "Meredialanl windstress"                                                                    \
                    , "Potential temperature (C deg)"                                                             \
                    , "Salinity (PSU)"                                                                            \
                    , "Zonal velosity"                                                                            \
                    , "Meredianal velosity"                                                                       \
                    , "Vertical velosity"                                                                         \
                    , "Potential density"/)

    N_VAR        = dimsizes(var_nm_monthly)  ; 14

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 50

    START_YEAR = 1980
    END_YEAR   = 2015
    

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

  ; var = new((/NZ, NY, NX/), "float", -1.0e20)
    var = new((/NZ, NY, NX/), "float", -9.99e8)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        print("i_yr = " + str_year)
        fn_bin   = "soda3.4.1_mn_ocean_reg_" + str_year + ".grd"

        fn_nc    = "soda3.4.1_mn_ocean_reg_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "c")

        ; define file (global) attributes
        print("Defining file attribute ...")
        global_att             = True
        global_att@description = "SODA_3.4.1 monthly data with MOM5 driven by ERA-Interim forcing!"
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

        var_att           = True
        do i_var = 0, 7
            filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "latitude", "longitude"/))

            var_att@long_name = var_long_name(i_var)
            var_att@units     = var_units    (i_var)
            filevarattdef(fl_nc, var_nm_monthly(i_var), var_att)
        end do

        do i_var = 8, 13
            filevardef(fl_nc, var_nm_monthly(i_var), "float", (/"time", "depth", "latitude", "longitude"/))

            var_att@long_name = var_long_name(i_var)
            var_att@units     = var_units    (i_var)
            filevarattdef(fl_nc, var_nm_monthly(i_var), var_att)
        end do

        print("Assigning file var ...") 

        do i_mon = 1, 12
            do i_var = 0, 7
                var(0, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*308 + i_var, (/NY, NX/), "float")
                fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :) = var(0, :, :)
            end do

            do i_var = 8, 13
                do i_rec = 0, 49
                    var(i_rec, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*308 + 8 + (i_var-8)*50 + i_rec, (/NY, NX/), "float")
                end do

                fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :, :) = var(:, :, :)
            end do
        end do

        do i_var = 0, 13
            fl_nc->$var_nm_monthly(i_var)$@_FillValue   = -9.99e+8
            fl_nc->$var_nm_monthly(i_var)$@missingvalue = -9.99e+8
        end do

      ; fl_nc->$var_nm_monthly(i_var)$@_FillValue = -1.0e20
    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
