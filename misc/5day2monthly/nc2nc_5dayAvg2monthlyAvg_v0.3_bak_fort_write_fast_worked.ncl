; #/glade/apps/opt/ncl/6.2.0/intel/12.1.5/bin/ncl
; 
; #BSUB -P UMCP0006                   # project code
; #BSUB -W 12:00                      # wall-clock time (hrs:mins)
; #BSUB -n 1                          # number of tasks in job         
; #BSUB -J 5dayAvg2monthlyAvg         # job name
; #BSUB -o 5dayAvg2monthlyAvg.%J.out  # output file name in which %J is replaced by the job ID
; #BSUB -e 5dayAvg2monthlyAvg.%J.err  # error file name in which %J is replaced by the job ID
; #BSUB -q premium                    # queue: small, premium, regular, etc.
; #BSUB -N                            # sends report to you by e-mail when the job finishes

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"

external LIBCLG "/glade/u/home/lgchen/lib/fortran/libclg.so"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_ROOT_SODA_ANALYSIS = "/glade/scratch/lgchen/project/MOM_run/SODA_Reanalysis_2011_2013/test1/MOM_SODA"

    VAR_STATIC  = (/"xt_ocean", "yt_ocean", "nv", "st_ocean", "st_edges_ocean", "xu_ocean", "yu_ocean", "sw_ocean"  \
        , "sw_edges_ocean", "geolon_t", "geolat_t"/)
    VAR_DYNAMIC = (/"temp", "salt", "u", "v", "sea_level", "wt", "tau_x", "tau_y"/)  ; time
    N_VAR_STATIC  = dimsizes(VAR_STATIC )
    N_VAR_DYNAMIC = dimsizes(VAR_DYNAMIC)

    ; dimensions
    xt_ocean       = 1440
    yt_ocean       = 1070
    time           = 2     ; UNLIMITED
    nv             = 2
    st_ocean       = 50
    st_edges_ocean = 51
    xu_ocean       = 1440
    yu_ocean       = 1070
    sw_ocean       = 50
    sw_edges_ocean = 51

    avg_temp      = new ((/1, st_ocean, yt_ocean, xt_ocean/), "float", -1.e20)
    avg_salt      = new ((/1, st_ocean, yt_ocean, xt_ocean/), "float", -1.e20)
    avg_u         = new ((/1, st_ocean, yu_ocean, xu_ocean/), "float", -1.e20)
    avg_v         = new ((/1, st_ocean, yu_ocean, xu_ocean/), "float", -1.e20)
    avg_sea_level = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_wt        = new ((/1, sw_ocean, yt_ocean, xt_ocean/), "float", -1.e20)
    avg_tau_x     = new ((/1,           yu_ocean, xu_ocean/), "float", -1.e20)
    avg_tau_y     = new ((/1,           yu_ocean, xu_ocean/), "float", -1.e20)

    avg_temp      = 0.0
    avg_salt      = 0.0
    avg_u         = 0.0
    avg_v         = 0.0
    avg_sea_level = 0.0
    avg_wt        = 0.0
    avg_tau_x     = 0.0
    avg_tau_y     = 0.0

    ; dimension file example
    FL_NC_DIM = addfile(DIR_ROOT_SODA_ANALYSIS + "/20110101/history/20110101.ocean.nc", "r")


    START_YEAR  = 2011
    START_MONTH = 1
    START_DAY   = 1
    END_YEAR    = 2014
    END_MONTH   = 1
    END_DAY     = 1

    julian_day_20110101 = greg2jul(2011, 1, 1 , -1)
    julian_day_20140101 = greg2jul(2014, 1, 1 , -1)
    print("julian_day_20110101 = " + julian_day_20110101 + ", julian_day_20140101 = " + julian_day_20140101)
    
;   julian_day_20110131 = greg2jul(2011, 1, 31, -1)

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

        abs_fn_nc_5day_avg = DIR_ROOT_SODA_ANALYSIS + "/" + str_date + "/history/" + str_date + ".ocean.nc"
        fl_nc_5day_avg     = addfile(abs_fn_nc_5day_avg, "r")

        if (i_yr .eq. curr_yr .and. i_mon .eq. curr_mon) then
            if (i_day + 9 .le. curr_dinm) then
                avg_temp     (0, :, :, :) = avg_temp     (0, :, :, :) + 5.0*(fl_nc_5day_avg->temp     (0, :, :, :) + fl_nc_5day_avg->temp     (1, :, :, :))
                avg_salt     (0, :, :, :) = avg_salt     (0, :, :, :) + 5.0*(fl_nc_5day_avg->salt     (0, :, :, :) + fl_nc_5day_avg->salt     (1, :, :, :))
                avg_u        (0, :, :, :) = avg_u        (0, :, :, :) + 5.0*(fl_nc_5day_avg->u        (0, :, :, :) + fl_nc_5day_avg->u        (1, :, :, :))
                avg_v        (0, :, :, :) = avg_v        (0, :, :, :) + 5.0*(fl_nc_5day_avg->v        (0, :, :, :) + fl_nc_5day_avg->v        (1, :, :, :))
                avg_sea_level(0,    :, :) = avg_sea_level(0,    :, :) + 5.0*(fl_nc_5day_avg->sea_level(0,    :, :) + fl_nc_5day_avg->sea_level(1,    :, :))
                avg_wt       (0, :, :, :) = avg_wt       (0, :, :, :) + 5.0*(fl_nc_5day_avg->wt       (0, :, :, :) + fl_nc_5day_avg->wt       (1, :, :, :))
                avg_tau_x    (0,    :, :) = avg_tau_x    (0,    :, :) + 5.0*(fl_nc_5day_avg->tau_x    (0,    :, :) + fl_nc_5day_avg->tau_x    (1,    :, :))
                avg_tau_y    (0,    :, :) = avg_tau_y    (0,    :, :) + 5.0*(fl_nc_5day_avg->tau_y    (0,    :, :) + fl_nc_5day_avg->tau_y    (1,    :, :))

                if (i_day + 9 .eq. curr_dinm) then
                    print("i_day + 9 .eq. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                        + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                    avg_temp      = 1.0*avg_temp      / curr_dinm
                    avg_salt      = 1.0*avg_salt      / curr_dinm
                    avg_u         = 1.0*avg_u         / curr_dinm
                    avg_v         = 1.0*avg_v         / curr_dinm
                    avg_sea_level = 1.0*avg_sea_level / curr_dinm
                    avg_wt        = 1.0*avg_wt        / curr_dinm
                    avg_tau_x     = 1.0*avg_tau_x     / curr_dinm
                    avg_tau_y     = 1.0*avg_tau_y     / curr_dinm

                    LIBCLG::write_out_5dayavg2monthlyavg_soda_mom(curr_yr, curr_mon, avg_temp, avg_salt, avg_u, avg_v  \
                        , avg_sea_level, avg_wt, avg_tau_x, avg_tau_y, xt_ocean, yt_ocean, st_ocean)

                    ; re-initialize for the next month
                    if (curr_mon .lt. 12) then
                        curr_mon = curr_mon + 1
                    else if (curr_mon .eq. 12) then
                        curr_mon = 1
                        curr_yr  = curr_yr + 1
                    end if
                    end if
                    curr_dinm = days_in_month(curr_yr, curr_mon)

                    avg_temp      = 0.0 
                    avg_salt      = 0.0 
                    avg_u         = 0.0 
                    avg_v         = 0.0 
                    avg_sea_level = 0.0 
                    avg_wt        = 0.0 
                    avg_tau_x     = 0.0 
                    avg_tau_y     = 0.0
                end if  ; end of "if (i_day + 9 .eq. curr_dinm) then"
            else if (i_day + 4 .le. curr_dinm) then
                avg_temp     (0, :, :, :) = avg_temp     (0, :, :, :) + (5.0*fl_nc_5day_avg->temp     (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->temp     (1, :, :, :))
                avg_salt     (0, :, :, :) = avg_salt     (0, :, :, :) + (5.0*fl_nc_5day_avg->salt     (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->salt     (1, :, :, :))
                avg_u        (0, :, :, :) = avg_u        (0, :, :, :) + (5.0*fl_nc_5day_avg->u        (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->u        (1, :, :, :))
                avg_v        (0, :, :, :) = avg_v        (0, :, :, :) + (5.0*fl_nc_5day_avg->v        (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->v        (1, :, :, :))
                avg_sea_level(0,    :, :) = avg_sea_level(0,    :, :) + (5.0*fl_nc_5day_avg->sea_level(0,    :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->sea_level(1,    :, :))
                avg_wt       (0, :, :, :) = avg_wt       (0, :, :, :) + (5.0*fl_nc_5day_avg->wt       (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->wt       (1, :, :, :))
                avg_tau_x    (0,    :, :) = avg_tau_x    (0,    :, :) + (5.0*fl_nc_5day_avg->tau_x    (0,    :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->tau_x    (1,    :, :))
                avg_tau_y    (0,    :, :) = avg_tau_y    (0,    :, :) + (5.0*fl_nc_5day_avg->tau_y    (0,    :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->tau_y    (1,    :, :))

                print("i_day + 4 .le. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                    + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                avg_temp      = 1.0*avg_temp      / curr_dinm
                avg_salt      = 1.0*avg_salt      / curr_dinm
                avg_u         = 1.0*avg_u         / curr_dinm
                avg_v         = 1.0*avg_v         / curr_dinm
                avg_sea_level = 1.0*avg_sea_level / curr_dinm
                avg_wt        = 1.0*avg_wt        / curr_dinm
                avg_tau_x     = 1.0*avg_tau_x     / curr_dinm
                avg_tau_y     = 1.0*avg_tau_y     / curr_dinm

                LIBCLG::write_out_5dayavg2monthlyavg_soda_mom(curr_yr, curr_mon, avg_temp, avg_salt, avg_u, avg_v  \
                    , avg_sea_level, avg_wt, avg_tau_x, avg_tau_y, xt_ocean, yt_ocean, st_ocean)

;               abs_fn_nc_monthly_avg = DIR_ROOT_SODA_ANALYSIS + "/monthly_avg/" + str_month + ".ocean.nc"
;               fl_nc_monthly_avg     = addfile(abs_fn_nc_monthly_avg, "c")
;               define_file_var_att_soda_mom5_5day2monthly(fl_nc_monthly_avg)
;               ; assignment
;               copy_dim_var_soda_mom5_5day2monthly(fl_nc_monthly_avg, FL_NC_DIM)
;               assign_monthly_avg_soda_mom5_5day2monthly(fl_nc_monthly_avg, avg_temp, avg_salt, avg_u, avg_v  \
;                   , avg_sea_level, avg_wt, avg_tau_x, avg_tau_y)

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
 
                avg_temp     (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->temp     (1, :, :, :)
                avg_salt     (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->salt     (1, :, :, :)
                avg_u        (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->u        (1, :, :, :)
                avg_v        (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->v        (1, :, :, :)
                avg_sea_level(0,    :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->sea_level(1,    :, :)
                avg_wt       (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->wt       (1, :, :, :)
                avg_tau_x    (0,    :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->tau_x    (1,    :, :)
                avg_tau_y    (0,    :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->tau_y    (1,    :, :)
            else if (i_day + 4 .gt. curr_dinm)
                avg_temp     (0, :, :, :) = avg_temp     (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->temp     (0, :, :, :)
                avg_salt     (0, :, :, :) = avg_salt     (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->salt     (0, :, :, :)
                avg_u        (0, :, :, :) = avg_u        (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->u        (0, :, :, :)
                avg_v        (0, :, :, :) = avg_v        (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->v        (0, :, :, :)
                avg_sea_level(0,    :, :) = avg_sea_level(0,    :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->sea_level(0,    :, :)
                avg_wt       (0, :, :, :) = avg_wt       (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->wt       (0, :, :, :)
                avg_tau_x    (0,    :, :) = avg_tau_x    (0,    :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->tau_x    (0,    :, :)
                avg_tau_y    (0,    :, :) = avg_tau_y    (0,    :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->tau_y    (0,    :, :)

                print("i_day + 4 .gt. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                    + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                avg_temp      = 1.0*avg_temp      / curr_dinm
                avg_salt      = 1.0*avg_salt      / curr_dinm
                avg_u         = 1.0*avg_u         / curr_dinm
                avg_v         = 1.0*avg_v         / curr_dinm
                avg_sea_level = 1.0*avg_sea_level / curr_dinm
                avg_wt        = 1.0*avg_wt        / curr_dinm
                avg_tau_x     = 1.0*avg_tau_x     / curr_dinm
                avg_tau_y     = 1.0*avg_tau_y     / curr_dinm

                LIBCLG::write_out_5dayavg2monthlyavg_soda_mom(curr_yr, curr_mon, avg_temp, avg_salt, avg_u, avg_v  \
                    , avg_sea_level, avg_wt, avg_tau_x, avg_tau_y, xt_ocean, yt_ocean, st_ocean)
 
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
 
                avg_temp     (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->temp     (0, :, :, :) + 5.0*fl_nc_5day_avg->temp     (1, :, :, :))
                avg_salt     (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->salt     (0, :, :, :) + 5.0*fl_nc_5day_avg->salt     (1, :, :, :))
                avg_u        (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->u        (0, :, :, :) + 5.0*fl_nc_5day_avg->u        (1, :, :, :))
                avg_v        (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->v        (0, :, :, :) + 5.0*fl_nc_5day_avg->v        (1, :, :, :))
                avg_sea_level(0,    :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->sea_level(0,    :, :) + 5.0*fl_nc_5day_avg->sea_level(1,    :, :))
                avg_wt       (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->wt       (0, :, :, :) + 5.0*fl_nc_5day_avg->wt       (1, :, :, :))
                avg_tau_x    (0,    :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->tau_x    (0,    :, :) + 5.0*fl_nc_5day_avg->tau_x    (1,    :, :))
                avg_tau_y    (0,    :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->tau_y    (0,    :, :) + 5.0*fl_nc_5day_avg->tau_y    (1,    :, :))
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
