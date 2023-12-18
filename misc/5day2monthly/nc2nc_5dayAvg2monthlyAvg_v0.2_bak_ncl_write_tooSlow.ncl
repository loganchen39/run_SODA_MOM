load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"


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
    START_DAY   = 31
    END_YEAR    = 2014
    END_MONTH   = 1
    END_DAY     = 1

    julian_day_20110101 = greg2jul(2011, 1, 1 , -1)
    julian_day_20110131 = greg2jul(2011, 1, 31, -1)
    julian_day_20140101 = greg2jul(2014, 1, 1 , -1)
    julian_day_20130629 = greg2jul(2013, 6, 29, -1)
    print("julian_day_20110101 = " + julian_day_20110101 + ", julian_day_20140101 = " + julian_day_20140101)
    
;   i_jul_day = julian_day_20110101
    i_jul_day = julian_day_20110131
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

;       abs_fn_nc_monthly_avg = DIR_ROOT_SODA_ANALYSIS + "/monthly_avg/" + str_month + ".ocean.nc"
;       fl_nc_monthly_avg     = addfile(abs_fn_nc_monthly_avg, "c")
        
        abs_fn_nc_5day_avg = DIR_ROOT_SODA_ANALYSIS + "/" + str_date + "/history/" + str_date + ".ocean.nc"
        fl_nc_5day_avg     = addfile(abs_fn_nc_5day_avg, "r")

        if (i_mon .eq. curr_mon) then
            if (i_day + 9 .le. curr_dinm) then
                avg_temp     (0, :, :, :) = avg_temp     (0, :, :, :) + 5.0*(fl_nc_5day_avg->temp     (0, :, :, :) + fl_nc_5day_avg->temp     (1, :, :, :)) / curr_dinm
                avg_salt     (0, :, :, :) = avg_salt     (0, :, :, :) + 5.0*(fl_nc_5day_avg->salt     (0, :, :, :) + fl_nc_5day_avg->salt     (1, :, :, :)) / curr_dinm
                avg_u        (0, :, :, :) = avg_u        (0, :, :, :) + 5.0*(fl_nc_5day_avg->u        (0, :, :, :) + fl_nc_5day_avg->u        (1, :, :, :)) / curr_dinm
                avg_v        (0, :, :, :) = avg_v        (0, :, :, :) + 5.0*(fl_nc_5day_avg->v        (0, :, :, :) + fl_nc_5day_avg->v        (1, :, :, :)) / curr_dinm
                avg_sea_level(0,    :, :) = avg_sea_level(0,    :, :) + 5.0*(fl_nc_5day_avg->sea_level(0,    :, :) + fl_nc_5day_avg->sea_level(1,    :, :)) / curr_dinm
                avg_wt       (0, :, :, :) = avg_wt       (0, :, :, :) + 5.0*(fl_nc_5day_avg->wt       (0, :, :, :) + fl_nc_5day_avg->wt       (1, :, :, :)) / curr_dinm
                avg_tau_x    (0,    :, :) = avg_tau_x    (0,    :, :) + 5.0*(fl_nc_5day_avg->tau_x    (0,    :, :) + fl_nc_5day_avg->tau_x    (1,    :, :)) / curr_dinm
                avg_tau_y    (0,    :, :) = avg_tau_y    (0,    :, :) + 5.0*(fl_nc_5day_avg->tau_y    (0,    :, :) + fl_nc_5day_avg->tau_y    (1,    :, :)) / curr_dinm

                if (i_day + 9 .eq. curr_dinm) then
                    abs_fn_nc_monthly_avg = DIR_ROOT_SODA_ANALYSIS + "/monthly_avg/" + str_month + ".ocean.nc"
                    fl_nc_monthly_avg     = addfile(abs_fn_nc_monthly_avg, "c")
                    
                    define_file_var_att_soda_mom5_5day2monthly(fl_nc_monthly_avg)

                    ; assignment
                    copy_dim_var_soda_mom5_5day2monthly(fl_nc_monthly_avg, FL_NC_DIM)
                    assign_monthly_avg_soda_mom5_5day2monthly(fl_nc_monthly_avg, avg_temp, avg_salt, avg_u, avg_v  \
                        , avg_sea_level, avg_wt, avg_tau_x, avg_tau_y)

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
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->temp     (1, :, :, :)) / curr_dinm
                avg_salt     (0, :, :, :) = avg_salt     (0, :, :, :) + (5.0*fl_nc_5day_avg->salt     (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->salt     (1, :, :, :)) / curr_dinm
                avg_u        (0, :, :, :) = avg_u        (0, :, :, :) + (5.0*fl_nc_5day_avg->u        (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->u        (1, :, :, :)) / curr_dinm
                avg_v        (0, :, :, :) = avg_v        (0, :, :, :) + (5.0*fl_nc_5day_avg->v        (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->v        (1, :, :, :)) / curr_dinm
                avg_sea_level(0,    :, :) = avg_sea_level(0,    :, :) + (5.0*fl_nc_5day_avg->sea_level(0,    :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->sea_level(1,    :, :)) / curr_dinm
                avg_wt       (0, :, :, :) = avg_wt       (0, :, :, :) + (5.0*fl_nc_5day_avg->wt       (0, :, :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->wt       (1, :, :, :)) / curr_dinm
                avg_tau_x    (0,    :, :) = avg_tau_x    (0,    :, :) + (5.0*fl_nc_5day_avg->tau_x    (0,    :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->tau_x    (1,    :, :)) / curr_dinm
                avg_tau_y    (0,    :, :) = avg_tau_y    (0,    :, :) + (5.0*fl_nc_5day_avg->tau_y    (0,    :, :)  \ 
                                          + 1.0*(curr_dinm-i_day-4)*fl_nc_5day_avg->tau_y    (1,    :, :)) / curr_dinm

                abs_fn_nc_monthly_avg = DIR_ROOT_SODA_ANALYSIS + "/monthly_avg/" + str_month + ".ocean.nc"
                fl_nc_monthly_avg     = addfile(abs_fn_nc_monthly_avg, "c")
                define_file_var_att_soda_mom5_5day2monthly(fl_nc_monthly_avg)

                ; assignment
                copy_dim_var_soda_mom5_5day2monthly(fl_nc_monthly_avg, FL_NC_DIM)
                assign_monthly_avg_soda_mom5_5day2monthly(fl_nc_monthly_avg, avg_temp, avg_salt, avg_u, avg_v  \
                    , avg_sea_level, avg_wt, avg_tau_x, avg_tau_y)

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
 
                avg_temp     (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->temp     (1, :, :, :) / curr_dinm
                avg_salt     (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->salt     (1, :, :, :) / curr_dinm
                avg_u        (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->u        (1, :, :, :) / curr_dinm
                avg_v        (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->v        (1, :, :, :) / curr_dinm
                avg_sea_level(0,    :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->sea_level(1,    :, :) / curr_dinm
                avg_wt       (0, :, :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->wt       (1, :, :, :) / curr_dinm
                avg_tau_x    (0,    :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->tau_x    (1,    :, :) / curr_dinm
                avg_tau_y    (0,    :, :) = 1.0*(i_day+9-prev_dinm)*fl_nc_5day_avg->tau_y    (1,    :, :) / curr_dinm
            else if (i_day + 4 .gt. curr_dinm)
                avg_temp     (0, :, :, :) = avg_temp     (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->temp     (0, :, :, :) / curr_dinm
                avg_salt     (0, :, :, :) = avg_salt     (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->salt     (0, :, :, :) / curr_dinm
                avg_u        (0, :, :, :) = avg_u        (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->u        (0, :, :, :) / curr_dinm
                avg_v        (0, :, :, :) = avg_v        (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->v        (0, :, :, :) / curr_dinm
                avg_sea_level(0,    :, :) = avg_sea_level(0,    :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->sea_level(0,    :, :) / curr_dinm
                avg_wt       (0, :, :, :) = avg_wt       (0, :, :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->wt       (0, :, :, :) / curr_dinm
                avg_tau_x    (0,    :, :) = avg_tau_x    (0,    :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->tau_x    (0,    :, :) / curr_dinm
                avg_tau_y    (0,    :, :) = avg_tau_y    (0,    :, :) + 1.0*(curr_dinm-i_day+1)*fl_nc_5day_avg->tau_y    (0,    :, :) / curr_dinm

                abs_fn_nc_monthly_avg = DIR_ROOT_SODA_ANALYSIS + "/monthly_avg/" + str_month + ".ocean.nc"
                system("rm -f " + abs_fn_nc_monthly_avg)
                fl_nc_monthly_avg     = addfile(abs_fn_nc_monthly_avg, "c")

                define_file_var_att_soda_mom5_5day2monthly(fl_nc_monthly_avg)

;               fl_nc_monthly_avg->xt_ocean       = FL_NC_DIM->xt_ocean
;               fl_nc_monthly_avg->yt_ocean       = FL_NC_DIM->yt_ocean
;               copy_dim_var_soda_mom5_5day2monthly(fl_nc_monthly_avg, FL_NC_DIM)

                fl_nc_monthly_avg->temp@_FillValue = -1.e20
                str_var_names = getfilevarnames    (fl_nc_monthly_avg)
                str_temp_att  = getfilevaratts     (fl_nc_monthly_avg, "temp")
                str_temp_typ  = getfilevartypes    (fl_nc_monthly_avg, "temp")
                int_temp_dim  = getfilevardimsizes (fl_nc_monthly_avg, "temp")
                temp_fv       = getFillValue       (fl_nc_monthly_avg->temp)
                avg_temp_fv   = getFillValue       (avg_temp)
                print(str_var_names)
                print(str_temp_att )
                print(str_temp_typ )
                print(int_temp_dim )
                print(temp_fv      )
                print(avg_temp_fv  )

;               assign_monthly_avg_soda_mom5_5day2monthly(fl_nc_monthly_avg, avg_temp, avg_salt, avg_u, avg_v  \
;                   , avg_sea_level, avg_wt, avg_tau_x, avg_tau_y)
                print(fl_nc_monthly_avg->temp(0, 0, 0, :))
                fl_nc_monthly_avg->temp(:, :, :, :)      = avg_temp(:, :, :, :)
                fl_nc_monthly_avg->salt      = avg_salt
                fl_nc_monthly_avg->u         = avg_u
                fl_nc_monthly_avg->v         = avg_v
                fl_nc_monthly_avg->sea_level = avg_sea_level
                fl_nc_monthly_avg->wt        = avg_wt
                fl_nc_monthly_avg->tau_x     = avg_tau_x
                fl_nc_monthly_avg->tau_y     = avg_tau_y



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
 
                avg_temp     (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->temp     (0, :, :, :) + 5.0*fl_nc_5day_avg->temp     (1, :, :, :)) / curr_dinm
                avg_salt     (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->salt     (0, :, :, :) + 5.0*fl_nc_5day_avg->salt     (1, :, :, :)) / curr_dinm
                avg_u        (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->u        (0, :, :, :) + 5.0*fl_nc_5day_avg->u        (1, :, :, :)) / curr_dinm
                avg_v        (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->v        (0, :, :, :) + 5.0*fl_nc_5day_avg->v        (1, :, :, :)) / curr_dinm
                avg_sea_level(0,    :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->sea_level(0,    :, :) + 5.0*fl_nc_5day_avg->sea_level(1,    :, :)) / curr_dinm
                avg_wt       (0, :, :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->wt       (0, :, :, :) + 5.0*fl_nc_5day_avg->wt       (1, :, :, :)) / curr_dinm
                avg_tau_x    (0,    :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->tau_x    (0,    :, :) + 5.0*fl_nc_5day_avg->tau_x    (1,    :, :)) / curr_dinm
                avg_tau_y    (0,    :, :) = (1.0*(i_day+4-prev_dinm)*fl_nc_5day_avg->tau_y    (0,    :, :) + 5.0*fl_nc_5day_avg->tau_y    (1,    :, :)) / curr_dinm
            end if
            end if
            end if
        else
            print("ERROR: i_mon .ne. curr_mon, i_yr = " + i_yr + ", i_mon = " + i_mon)
            exit()
        end if

        i_jul_day = i_jul_day + 10
    end do  ; end of "do while(i_jul_day .lt. julian_day_20140101)"
end
