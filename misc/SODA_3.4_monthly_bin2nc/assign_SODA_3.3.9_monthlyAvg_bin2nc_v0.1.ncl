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

    var_nm_monthly = (/"ssh", "mlt", "mlp", "mls", "hflx", "sflx", "anompb", "taux", "tauy"  \
        , "temp", "salt", "u", "v", "w", "prho"/)
    var_units     = (/"m", "m", "m", "m", "Watts/m^2", "kg/(m^2*sec)", "dbar", "", ""  \
                    , "C deg", "PSU", "m/s", "m/s", "m/s", ""/)
  ; var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 62, 112, 162, 212, 262/)
    var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 59, 109, 159, 209, 259/)
    var_long_name = (/"Sea Surface Height"                                                                        \
                    , "Mixed layer depth determined by temperature"                                               \
                    , "Mixed layer depth determined by potential density"                                         \
                    , "Mixed layer depth determined by salinity"                                                  \
                    , "Surface ocean heat flux coming through coupler and mass transfer, (Watts/m^2)"             \
                    , "Sfc_salt_flux_total, (kg/(m^2*sec))"                                                       \
                    , "T-cell bottom preasure minus rh0*grav*ht (dbar)"                                           \
                    , "Zonal windstress"                                                                          \
                    , "Meredialanl windstress"                                                                    \
                    , "Potential temperature (C deg)"                                                             \
                    , "Salinity (PSU)"                                                                            \
                    , "Zonal velosity"                                                                            \
                    , "Meredianal velosity"                                                                       \
                    , "Vertical velosity"                                                                         \
                    , "Potential density"/)

    N_VAR        = dimsizes(var_nm_monthly)  ; 15

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

    var = new((/NZ, NY, NX/), "float", -1.0e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda3.3.1_mn_ocean_" + str_year + ".grd"
        print("i_yr = " + str_year)

        fn_nc    = "SODA_3.3.0_mn_ocean_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "w")

        print("Assigning file var ...") 

        do i_mon = 1, 12
            print("i_mon = " + sprinti("%0.2i", i_mon))

            do i_var = 0, 8
              ; print("i_var = " + sprinti("%0.2i", i_var))

                var(0, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*309 + i_var, (/NY, NX/), "float")
              ; fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :) = var(0, :, :)
              ; LIBCLG::write_out_monthlyAvg_nc_SODA_339(i_yr, i_mon, i_var, var_nm_monthly(i_var), var)
                LIBCLG::write_out_monthlyavg_nc_soda_339(i_yr, i_mon, i_var, var_nm_monthly(i_var), var)
            end do

            do i_var = 9, 14
              ; print("i_var = " + sprinti("%0.2i", i_var))

                do i_rec = 0, 49
                    var(i_rec, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*309 + 9 + (i_var-9)*50 + i_rec, (/NY, NX/), "float")
                end do

              ; fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :, :) = var(:, :, :)
              ; LIBCLG::write_out_monthlyAvg_nc_SODA_339(i_yr, i_mon, i_var, var_nm_monthly(i_var), var)
                LIBCLG::write_out_monthlyavg_nc_soda_339(i_yr, i_mon, i_var, var_nm_monthly(i_var), var)
            end do
        end do

      ; do i_var = 0, 14
      ;     fl_nc->$var_nm_monthly(i_var)$@_FillValue   = -9.99e+8
      ;     fl_nc->$var_nm_monthly(i_var)$@missingvalue = -9.99e+8
      ; end do
    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
