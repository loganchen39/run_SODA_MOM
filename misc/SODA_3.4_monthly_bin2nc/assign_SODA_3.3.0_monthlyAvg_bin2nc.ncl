load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"

external LIBCLG "/glade/u/home/lgchen/lib/fortran/libclg.so"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_ROOT = "/glade/scratch/lgchen/project/SODA_3.3.0/month_avg"
    DIR_DATA_BIN  = DIR_DATA_ROOT + "/binary/ocean"
    DIR_DATA_NC   = DIR_DATA_ROOT + "/netcdf/ocean"

  ; var_nm_monthly = (/"ssh", "mlt", "mlp", "mls", "hflx", "sflx", "anompb", "taux", "tauy"  \
  ;     , "temp", "salt", "u", "v", "w", "prho"/)
    var_nm_monthly = (/"temp", "salt", "wt", "ssh", "mlt", "mlp", "mls", "anompb", "net_heating"  \
        , "salt_flux_total", "prho", "u", "v", "taux", "tauy"/)
    var_3d = (/True, True, True, False, False, False, False, False, False, False, True, True, True, False, False/)

  ; var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 62, 112, 162, 212, 262/)
  ; var_start_rec = (/0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 59, 109, 159, 209, 259/)
  ; var_start_rec = (/0, 50, 100, 150, 151, 152, 153, 154, 155, 156, 206, 256, 306, 307, 308/)
    var_start_rec = (/9, 59, 209, 0, 1, 2, 3, 6, 4, 5, 259, 109, 159, 7, 8/)


    N_VAR        = dimsizes(var_nm_monthly)  ; 15

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 50

    START_YEAR = 1980
    END_YEAR   = 2015
    

    var = new((/NZ, NY, NX/), "float", -1.0e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda3.3.0_mn_ocean_" + str_year + ".grd"
        print("i_yr = " + str_year)

        fn_nc    = "soda3.3.0_mn_ocean_reg_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "w")

        print("Assigning file var ...") 

        do i_mon = 1, 12
            print("i_mon = " + sprinti("%0.2i", i_mon))
 
            do i_var = 0, 14
                if (var_3d(i_var)) then
                    do i_rec = 0, 49
                        var(i_rec, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*309 + var_start_rec(i_var) + i_rec, (/NY, NX/), "float")
                    end do
                    var = where(var .eq. -9.99e+8, -1.e+20, var)
                    
                    LIBCLG::write_out_monthlyavg_nc_soda_330(i_yr, i_mon, 1, var_nm_monthly(i_var), var)
                else
                    var(0, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*309 + var_start_rec(i_var), (/NY, NX/), "float")
                    var = where(var .eq. -9.99e+8, -1.e+20, var)

                    LIBCLG::write_out_monthlyavg_nc_soda_330(i_yr, i_mon, 0, var_nm_monthly(i_var), var)
                end if
            end do
        end do
    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
