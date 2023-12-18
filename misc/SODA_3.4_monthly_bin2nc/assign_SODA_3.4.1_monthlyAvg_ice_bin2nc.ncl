load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"

external LIBCLG "/glade/u/home/lgchen/lib/fortran/tmp/libclg.so"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_DATA_ROOT = "/glade/scratch/lgchen/tmp/20170203_soda3.4.1_mn_bin"
    DIR_DATA_BIN  = DIR_DATA_ROOT
    DIR_DATA_NC   = DIR_DATA_ROOT + "/netcdf"

    var_nm_monthly = (/"hi", "mi", "hs", "ui", "vi", "cn"/)
    var_3d         = (/False, False, False, False, False, True/)

    var_start_rec  = (/0, 1, 2, 3, 4, 5/)  ; 10 for one record


    N_VAR   = dimsizes(var_nm_monthly)  ; 6 

    N_MONTH = 12    
    NY      = 330
    NX      = 720
    NZ      = 5 

    START_YEAR = 1980
    END_YEAR   = 2015
    

    var = new((/NZ, NY, NX/), "float", -1.0e20)
  
    do i_yr = START_YEAR, END_YEAR
        str_year = sprinti("%0.4i", i_yr)
        fn_bin   = "soda3.4.1_mn_ice_reg_" + str_year + ".grd"
        print("i_yr = " + str_year)

        fn_nc = "soda3.4.1_mn_ice_reg_" + str_year + ".nc"
        fl_nc = addfile(DIR_DATA_NC + "/" + fn_nc, "w")

        print("Assigning file var ...") 

        do i_mon = 1, 12
            print("i_mon = " + sprinti("%0.2i", i_mon))
 
            do i_var = 0, 5
                if (var_3d(i_var)) then
                    do i_rec = 0, 4
                        var(i_rec, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*10 + var_start_rec(i_var) + i_rec, (/NY, NX/), "float")
                    end do
                    var = where(var .eq. -9.99e+8, -1.e+20, var)
                    
                    LIBCLG::write_out_monthlyavg_ice_nc_soda_341(i_yr, i_mon, 1, var_nm_monthly(i_var), var)
                else
                    var(0, :, :) = fbindirread(DIR_DATA_BIN + "/" + fn_bin, (i_mon-1)*10 + var_start_rec(i_var), (/NY, NX/), "float")
                    var = where(var .eq. -9.99e+8, -1.e+20, var)

                    LIBCLG::write_out_monthlyavg_ice_nc_soda_341(i_yr, i_mon, 0, var_nm_monthly(i_var), var)
                end if

            end do


        end do

    end do  ; end of "do i_yr = START_YEAR, END_YEAR"
end
