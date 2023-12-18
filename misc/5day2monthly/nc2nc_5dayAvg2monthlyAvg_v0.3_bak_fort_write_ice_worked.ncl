load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"

external LIBCLG "/glade/u/home/lgchen/lib/fortran/libclg.so"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_ROOT_SODA_ANALYSIS = "/glade/scratch/lgchen/project/MOM_run/SODA_MOM5_sea_ice_2011_2013/test2/MOM_SODA"

    VAR_STATIC  = (/"xt", "yt", "nv", "ct", "xb", "yb"/)
    VAR_DYNAMIC = (/"CN", "HI"/)  ; time
    N_VAR_STATIC  = dimsizes(VAR_STATIC )
    N_VAR_DYNAMIC = dimsizes(VAR_DYNAMIC)

    ; dimensions
    xt   = 1440
    yt   = 1070
    time = 2     ; UNLIMITED
    nv   = 2
    ct   = 5
    xb   = 1441
    yb   = 1071

    avg_CN = new ((/1, ct, yt, xt/), "float", -1.e34)
    avg_HI = new ((/1,     yt, xt/), "float", -1.e34)

    avg_CN = 0.0
    avg_HI = 0.0

    ; dimension file example
    FL_NC_DIM = addfile(DIR_ROOT_SODA_ANALYSIS + "/20110101/history/20110101.ice_month.nc", "r")


    START_YEAR  = 2011
    START_MONTH = 1
    START_DAY   = 1
    END_YEAR    = 2014  ; 2011
    END_MONTH   = 1 
    END_DAY     = 1

    julian_day_20110101 = greg2jul(2011, 1 , 1 , -1)
    julian_day_20140101 = greg2jul(2014, 1 , 1 , -1)
;   julian_day_20111001 = greg2jul(2011, 10, 1 , -1)
;   print("julian_day_20110101 = " + julian_day_20110101 + ", julian_day_20140101 = " + julian_day_20140101)
    
    i_jul_day = julian_day_20110101
    curr_yr   = 2011
    curr_mon  = 1

    do while(i_jul_day .lt. julian_day_20140101)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_month = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon)
        str_date  = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_date = " + str_date)

        curr_dinm = days_in_month(curr_yr, curr_mon)

        abs_fn_nc_5day_avg = DIR_ROOT_SODA_ANALYSIS + "/" + str_date + "/history/" + str_date + ".ice_month.nc"
        fl_nc_5day_avg     = addfile(abs_fn_nc_5day_avg, "r")

        if (i_yr .eq. curr_yr .and. i_mon .eq. curr_mon) then
            if (i_day + 9 .le. curr_dinm) then
                avg_CN(0, :, :, :) = avg_CN(0, :, :, :) + 5.0*(fl_nc_5day_avg->CN(0, :, :, :) + fl_nc_5day_avg->CN(1, :, :, :))
                avg_HI(0,    :, :) = avg_HI(0,    :, :) + 5.0*(fl_nc_5day_avg->HI(0,    :, :) + fl_nc_5day_avg->HI(1,    :, :))

                if (i_day + 9 .eq. curr_dinm) then
                    print("i_day + 9 .eq. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                        + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                    avg_CN = 1.0*avg_CN / curr_dinm
                    avg_HI = 1.0*avg_HI / curr_dinm

                    LIBCLG::write_out_5dayavg2monthlyavg_soda_mom_ice(curr_yr, curr_mon, avg_CN, avg_HI  \
                        , xt, yt, ct)

                    ; re-initialize for the next month
                    if (curr_mon .lt. 12) then
                        curr_mon = curr_mon + 1
                    else if (curr_mon .eq. 12) then
                        curr_mon = 1
                        curr_yr  = curr_yr + 1
                    end if
                    end if
                    curr_dinm = days_in_month(curr_yr, curr_mon)

                    avg_CN = 0.0 
                    avg_HI = 0.0 
                end if  ; end of "if (i_day + 9 .eq. curr_dinm) then"
            else if (i_day + 4 .le. curr_dinm) then
                avg_CN(0, :, :, :) = avg_CN(0, :, :, :) + (5.0*fl_nc_5day_avg->CN(0, :, :, :)  \ 
                                   + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->CN(1, :, :, :))
                avg_HI(0,    :, :) = avg_HI(0,    :, :) + (5.0*fl_nc_5day_avg->HI(0,    :, :)  \ 
                                   + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->HI(1,    :, :))

                print("i_day + 4 .le. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                    + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                avg_CN = 1.0*avg_CN / curr_dinm
                avg_HI = 1.0*avg_HI / curr_dinm

                LIBCLG::write_out_5dayavg2monthlyavg_soda_mom_ice(curr_yr, curr_mon, avg_CN, avg_HI  \
                    , xt, yt, ct)

                ; re-initialize for the next month
                prev_dinm = curr_dinm

                if (curr_mon .lt. 12) then
                    curr_mon = curr_mon + 1
                else if (curr_mon .eq. 12) then
                    curr_mon = 1
                    curr_yr  = curr_yr + 1
                end if
                end if
                curr_dinm = days_in_month(curr_yr, curr_mon)
 
                avg_CN(0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->CN(1, :, :, :)
                avg_HI(0,    :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->HI(1,    :, :)
            else if (i_day + 4 .gt. curr_dinm)
                avg_CN(0, :, :, :) = avg_CN(0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->CN(0, :, :, :)
                avg_HI(0,    :, :) = avg_HI(0,    :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->HI(0,    :, :)

                print("i_day + 4 .gt. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                    + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                avg_CN = 1.0*avg_CN / curr_dinm
                avg_HI = 1.0*avg_HI / curr_dinm

                LIBCLG::write_out_5dayavg2monthlyavg_soda_mom_ice(curr_yr, curr_mon, avg_CN, avg_HI  \
                    , xt, yt, ct)
 
                ; re-initialize for the next month
                prev_dinm = curr_dinm

                if (curr_mon .lt. 12) then
                    curr_mon = curr_mon + 1
                else if (curr_mon .eq. 12) then
                    curr_mon = 1
                    curr_yr  = curr_yr + 1
                end if
                end if
                curr_dinm = days_in_month(curr_yr, curr_mon)
 
                avg_CN (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->CN (0, :, :, :) + 5.0*fl_nc_5day_avg->CN (1, :, :, :))
                avg_HI (0,    :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->HI (0,    :, :) + 5.0*fl_nc_5day_avg->HI (1,    :, :))
            end if
            end if
            end if
        else
            print("ERROR: i_yr .ne. curr_yr .or. i_mon .ne. curr_mon, i_yr = " + i_yr + ", i_mon = " + i_mon)
            exit()
        end if

        i_jul_day = i_jul_day + 10
    end do  ; end of "do while(i_jul_day .lt. julian_day_20140101)"
end
