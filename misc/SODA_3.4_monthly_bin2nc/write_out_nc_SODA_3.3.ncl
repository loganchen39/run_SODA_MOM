load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


external LIBCLG "/glade/u/home/lgchen/lib/fortran/libclg.so"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_BIN = "/glade/p/umcp0006/lgchen/project/MOM_run/SODA_3.3_1/monthly/binary_gena"
    DIR_DATA_NC  = "/glade/p/umcp0006/lgchen/project/MOM_run/SODA_3.3_1/monthly/nc_ligang"

    var_nm_monthly = (/"ssh", "mlt", "mlp", "mls", "sbd", "sbdmld", "sbddhdt", "sbdhorz", "sbdvert", "anompb", "taux", "tauy"  \
        , "temp", "salt", "u", "v", "w", "prho"/)

    N_VAR        = dimsizes(var_nm_monthly)

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 50

    START_YEAR = 1980  ; 1980
    END_YEAR   = 1989  ; 2014
    
    var = new((/NZ, NY, NX/), "float", -1.0e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda_3.3_mn_ocean_" + str_year + ".grd"

        fn_nc    = "soda_3.3_mn_ocean_" + str_year + ".nc"
        fl_nc    = addfile(DIR_DATA_NC + "/" + fn_nc, "w")

        print("Assigning file var ...") 

        do i_mon = 1, 12
           do i_var = 0, 11
               var(0, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*312 + i_var, (/NY, NX/), "float")

             ; fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :) = var(0, :, :)
               LIBCLG::write_out_monthlyavg_nc_soda(i_yr, i_mon, i_var, var_nm_monthly(i_var), var)
           end do

           do i_var = 12, 17
               do i_rec = 0, 49
                   var(i_rec, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*312 + 12 + (i_var-12)*50 + i_rec, (/NY, NX/), "float")
               end do

             ; fl_nc->$var_nm_monthly(i_var)$(i_mon-1, :, :, :) = var(:, :, :)
               LIBCLG::write_out_monthlyavg_nc_soda(i_yr, i_mon, i_var, var_nm_monthly(i_var), var)
           end do
        end do
    end do
end
