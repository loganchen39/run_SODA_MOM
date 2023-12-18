load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


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

    avg_temp      = new ((/1, st_ocean, yt_ocean, xt_ocean/), "float")
    avg_salt      = new ((/1, st_ocean, yt_ocean, xt_ocean/), "float")
    avg_u         = new ((/1, st_ocean, yu_ocean, xu_ocean/), "float")
    avg_v         = new ((/1, st_ocean, yu_ocean, xu_ocean/), "float")
    avg_sea_level = new ((/1,           yt_ocean, xt_ocean/), "float")
    avg_wt        = new ((/1, sw_ocean, yt_ocean, xt_ocean/), "float")
    avg_tau_x     = new ((/1,           yu_ocean, xu_ocean/), "float")
    avg_tau_y     = new ((/1,           yu_ocean, xu_ocean/), "float")

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
    julian_day_20130629 = greg2jul(2013, 6, 29, -1)
    print("julian_day_20110101 = " + julian_day_20110101 + ", julian_day_20140101 = " + julian_day_20140101)
    
    i_jul_day = julian_day_20110101
    curr_yr   = 2011
    curr_mon  = 1
;   curr_day  = 1

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
                avg_temp      = avg_temp      + 5.0*(fl_nc_5day_avg->temp     (0, :, :, :) + fl_nc_5day_avg->temp     (1, :, :, :)) / curr_dinm
                avg_salt      = avg_salt      + 5.0*(fl_nc_5day_avg->salt     (0, :, :, :) + fl_nc_5day_avg->salt     (1, :, :, :)) / curr_dinm
                avg_u         = avg_u         + 5.0*(fl_nc_5day_avg->u        (0, :, :, :) + fl_nc_5day_avg->u        (1, :, :, :)) / curr_dinm
                avg_v         = avg_v         + 5.0*(fl_nc_5day_avg->v        (0, :, :, :) + fl_nc_5day_avg->v        (1, :, :, :)) / curr_dinm
                avg_sea_level = avg_sea_level + 5.0*(fl_nc_5day_avg->sea_level(0,    :, :) + fl_nc_5day_avg->sea_level(1,    :, :)) / curr_dinm
                avg_wt        = avg_wt        + 5.0*(fl_nc_5day_avg->wt       (0, :, :, :) + fl_nc_5day_avg->wt       (1, :, :, :)) / curr_dinm
                avg_tau_x     = avg_tau_x     + 5.0*(fl_nc_5day_avg->tau_x    (0,    :, :) + fl_nc_5day_avg->tau_x    (1,    :, :)) / curr_dinm
                avg_tau_y     = avg_tau_y     + 5.0*(fl_nc_5day_avg->tau_y    (0,    :, :) + fl_nc_5day_avg->tau_y    (1,    :, :)) / curr_dinm

                if (i_day + 9 .eq. curr_dinm) then
                    abs_fn_nc_monthly_avg = DIR_ROOT_SODA_ANALYSIS + "/monthly_avg/" + str_month + ".ocean.nc"
                    fl_nc_monthly_avg     = addfile(abs_fn_nc_monthly_avg, "c")
                    
                    ; define file (global) attributes
                    global_att             = True
                    global_att@description = "SODA-MOM5 reanalysis Monthly averaged from original 5-day average output, data are on MOM5's grid."
                    global_att@contact     = "Ligang Chen: lchen2@umd.edu, UMD/AOSC"
                    fileattdef(fl_nc_monthly_avg, global_att)

                    ; define file dimensions
                    dim_names = (/"time", "xt_ocean", "yt_ocean", "st_ocean", "st_edges_ocean", "xu_ocean", "yu_ocean", "sw_ocean", "sw_edges_ocean"/)
                    dim_sizes = (/1     , 1440      , 1070      , 50        , 51              , 1440      , 1070      , 50        , 51              /)
                    dim_unlim = (/True  , False     , False     , False     , False           , False     , False     , False     , False           /)
                    filedimdef(fl_nc_monthly_avg, dim_names, dim_sizes, dim_unlim)

                    ; define dimension and other static vars
                    filevardef(fl_nc_monthly_avg, "time"          , "double", (/"time"          /))
                    filevardef(fl_nc_monthly_avg, "xt_ocean"      , "double", (/"xt_ocean"      /))
                    filevardef(fl_nc_monthly_avg, "yt_ocean"      , "double", (/"yt_ocean"      /))
                    filevardef(fl_nc_monthly_avg, "st_ocean"      , "double", (/"st_ocean"      /))
                    filevardef(fl_nc_monthly_avg, "st_edges_ocean", "double", (/"st_edges_ocean"/))
                    filevardef(fl_nc_monthly_avg, "xu_ocean"      , "double", (/"xu_ocean"      /))
                    filevardef(fl_nc_monthly_avg, "yu_ocean"      , "double", (/"yu_ocean"      /))
                    filevardef(fl_nc_monthly_avg, "sw_ocean"      , "double", (/"sw_ocean"      /))
                    filevardef(fl_nc_monthly_avg, "sw_edges_ocean", "double", (/"sw_edges_ocean"/))

                    filevardef(fl_nc_monthly_avg, "geolon_t", "float", (/"yt_ocean", "xt_ocean"/))
                    filevardef(fl_nc_monthly_avg, "geolat_t", "float", (/"yt_ocean", "xt_ocean"/))
                    
                    fl_nc_monthly_avg->time = 0
                    time_att                = 0
                    time_att@long_name      = "time"
                    time_att@units          = "months since " + sprinti("%0.4i", curr_yr) + "-" + sprinti("%0.2i", curr_mon) + "-15"
                    time_att@cartesian_axis = "T"
                    time_att@calendar       = "JULIAN"
                    time_att@bounds         = "time_bounds"
                    filevarattdef(fl_nc_monthly_avg, "time", time_att)

                    fl_nc_monthly_avg->xt_ocean       = FL_NC_DIM->xt_ocean
                    fl_nc_monthly_avg->yt_ocean       = FL_NC_DIM->yt_ocean
                    fl_nc_monthly_avg->st_ocean       = FL_NC_DIM->st_ocean
                    fl_nc_monthly_avg->st_edges_ocean = FL_NC_DIM->st_edges_ocean
                    fl_nc_monthly_avg->xu_ocean       = FL_NC_DIM->xu_ocean
                    fl_nc_monthly_avg->yu_ocean       = FL_NC_DIM->yu_ocean
                    fl_nc_monthly_avg->sw_ocean       = FL_NC_DIM->sw_ocean
                    fl_nc_monthly_avg->sw_edges_ocean = FL_NC_DIM->sw_edges_ocean
                    fl_nc_monthly_avg->geolon_t       = FL_NC_DIM->geolon_t      
                    fl_nc_monthly_avg->geolat_t       = FL_NC_DIM->geolat_t      

                    ; define file variables with their dimensions and attributes
                    filevardef(fl_nc_monthly_avg, "temp"     , "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))
                    filevardef(fl_nc_monthly_avg, "salt"     , "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))
                    filevardef(fl_nc_monthly_avg, "u"        , "float", (/"time", "st_ocean", "yu_ocean", "xu_ocean"/))
                    filevardef(fl_nc_monthly_avg, "v"        , "float", (/"time", "st_ocean", "yu_ocean", "xu_ocean"/))
                    filevardef(fl_nc_monthly_avg, "sea_level", "float", (/"time",             "yt_ocean", "xt_ocean"/))
                    filevardef(fl_nc_monthly_avg, "wt"       , "float", (/"time", "sw_ocean", "yt_ocean", "xt_ocean"/))
                    filevardef(fl_nc_monthly_avg, "tau_x"    , "float", (/"time",             "yu_ocean", "xu_ocean"/))
                    filevardef(fl_nc_monthly_avg, "tau_y"    , "float", (/"time",             "yu_ocean", "xu_ocean"/))

                    temp_att               = True
                    temp_att@long_name     = "Potential temperature"
                    temp_att@units         = "degrees C"
                    temp_att@valid_range   = -10.f, 500.f  ; may need ""
                    temp_att@missing_value = -1.e+20f
                    temp_att@_FillValue    = -1.e+20f
                    temp_att@cell_methods  = "time: mean"
                    temp_att@coordinates   = "geolon_t geolat_t"
                    temp_att@standard_name = "sea_water_potential_temperature"
                    filevarattdef(fl_nc_monthly_avg, "temp", temp_att)

                    salt_att               = True
                    salt_att@long_name     = "Practical Salinity"
                    salt_att@units         = "psu"
                    salt_att@valid_range   = -10.f, 100.f  ; may need ""
                    salt_att@missing_value = -1.e+20f
                    salt_att@_FillValue    = -1.e+20f
                    salt_att@cell_methods  = "time: mean"
                    salt_att@coordinates   = "geolon_t geolat_t"
                    salt_att@standard_name = "sea_water_salinity"
                    filevarattdef(fl_nc_monthly_avg, "salt", salt_att)

                    u_att               = True
                    u_att@long_name     = "i-current"
                    u_att@units         = "m/sec"
                    u_att@valid_range   = -10.f, 10.f  ; may need ""
                    u_att@missing_value = -1.e+20f
                    u_att@_FillValue    = -1.e+20f
                    u_att@cell_methods  = "time: mean"
                    u_att@coordinates   = "geolon_c geolat_c"
                    u_att@standard_name = "sea_water_x_velocity"
                    filevarattdef(fl_nc_monthly_avg, "u", u_att)

                    v_att               = True
                    v_att@long_name     = "j-current"
                    v_att@units         = "m/sec"
                    v_att@valid_range   = -10.f, 10.f  ; may need ""
                    v_att@missing_value = -1.e+20f
                    v_att@_FillValue    = -1.e+20f
                    v_att@cell_methods  = "time: mean"
                    v_att@coordinates   = "geolon_c geolat_c"
                    v_att@standard_name = "sea_water_y_velocity"
                    filevarattdef(fl_nc_monthly_avg, "v", v_att)

                    sea_level_att               = True
                    sea_level_att@long_name     = "effective sea level (eta_t + patm/(rho0*g)) on T cells"
                    sea_level_att@units         = "meter"
                    sea_level_att@valid_range   = -1000.f, 1000.f  ; may need ""
                    sea_level_att@missing_value = -1.e+20f
                    sea_level_att@_FillValue    = -1.e+20f
                    sea_level_att@cell_methods  = "time: mean"
                    sea_level_att@coordinates   = "geolon_t geolat_t"
                    sea_level_att@standard_name = "sea_surface_height_above_geoid"
                    filevarattdef(fl_nc_monthly_avg, "sea_level", sea_level_att)

                    wt_att               = True
                    wt_att@long_name     = "dia-surface velocity T-points"
                    wt_att@units         = "m/sec"
                    wt_att@valid_range   = -100000.f, 100000.f  ; may need ""
                    wt_att@missing_value = -1.e+20f
                    wt_att@_FillValue    = -1.e+20f
                    wt_att@cell_methods  = "time: mean"
                    wt_att@coordinates   = "geolon_t geolat_t"
                    filevarattdef(fl_nc_monthly_avg, "wt", wt_att)

                    tau_x_att               = True
                    tau_x_att@long_name     = "i-directed wind stress forcing u-velocity"
                    tau_x_att@units         = "N/m^2"
                    tau_x_att@valid_range   = -10.f, 10.f
                    tau_x_att@missing_value = -1.e+20f
                    tau_x_att@_FillValue    = -1.e+20f
                    tau_x_att@cell_methods  = "time: mean"
                    tau_x_att@coordinates   = "geolon_c geolat_c"
                    tau_x_att@standard_name = "surface_downward_x_stress"
                    filevarattdef(fl_nc_monthly_avg, "tau_x", tau_x_att)

                    tau_y_att               = True
                    tau_y_att@long_name     = "j-directed wind stress forcing v-velocity"
                    tau_y_att@units         = "N/m^2"
                    tau_y_att@valid_range   = -10.f, 10.f
                    tau_y_att@missing_value = -1.e+20f
                    tau_y_att@_FillValue    = -1.e+20f
                    tau_y_att@cell_methods  = "time: mean"
                    tau_y_att@coordinates   = "geolon_c geolat_c"
                    tau_y_att@standard_name = "surface_downward_y_stress"
                    filevarattdef(fl_nc_monthly_avg, "tau_y", tau_y_att)

                    fl_nc_monthly_avg->temp      = avg_temp
                    fl_nc_monthly_avg->salt      = avg_salt
                    fl_nc_monthly_avg->u         = avg_u    
                    fl_nc_monthly_avg->v         = avg_v   
                    fl_nc_monthly_avg->sea_level = avg_sea_level
                    fl_nc_monthly_avg->wt        = avg_wt  
                    fl_nc_monthly_avg->tau_x     = avg_tau_x
                    fl_nc_monthly_avg->tau_y     = avg_tau_y

                    ; re-initialize
                    avg_temp      = 0.0 
                    avg_salt      = 0.0 
                    avg_u         = 0.0 
                    avg_v         = 0.0 
                    avg_sea_level = 0.0 
                    avg_wt        = 0.0 
                    avg_tau_x     = 0.0 
                    avg_tau_y     = 0.0

                    if (curr_mon .lt. 12) then
                        curr_mon = curr_mon + 1
                    else if (curr_mon .eq. 12) then
                        curr_mon = 1
                        curr_yr  = curr_yr + 1
                    end if
                    end if
                end if
            else if (i_day + 4 .le. curr_dinm) then
                
            end if
            end if
        else

        end if



        i_jul_day = i_jul_day + 10
    end do











    DIR_SODA2MOM = getenv("DIR_ROOT_RUN_SODA")
    str_time     = getenv("START_YEAR") + getenv("START_MONTH") + getenv("START_DAY")

    nl = integertochar(10)  ; newline character

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; define and write the soda generated correctors result to a new netCDF file
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    fl_nc           = addfile(DIR_SODA2MOM + "/" + str_time + ".correctors.nc", "c")
    fl_nc_axis      = addfile("/glade/p/work/lgchen/data/SODA_MOM/regrid_mom2soda_firstGuess/case1_20050101_10/20140917_corr_salt_nan/correctors_soda2mom_per10days_destGrid_mom5_to_soda1x1_tcor_zero_scor_masked.nc", "r")
    fl_nc_time_axis = addfile("/glade/p/work/lgchen/data/MOM5/RESTART_20050101000000_Gena/ocean_temp_salt.res.nc", "r")

    ; define file (global) attributes
    global_att = True
    global_att@description = "source: soda generaed correctors result" + nl  \
        + "temp and salt"
    fileattdef(fl_nc, global_att)

    ; define file dimensions
    dim_names = (/"time", "st_ocean", "xt_ocean", "yt_ocean"/)
    dim_sizes = (/1     , 50        , 360       , 180       /)
    dim_unlim = (/True  , False     , False     , False     /)
    filedimdef(fl_nc, dim_names, dim_sizes, dim_unlim)

    ; define dimension vars
    filevardef(fl_nc, "time"    , "double", (/"time"    /))    
    filevardef(fl_nc, "xt_ocean", "double", (/"xt_ocean"/))    
    filevardef(fl_nc, "yt_ocean", "double", (/"yt_ocean"/))    
    filevardef(fl_nc, "st_ocean", "double", (/"st_ocean"/))    
   
    fl_nc->time     =  fl_nc_time_axis->Time
    fl_nc->xt_ocean =  fl_nc_axis->xt_ocean
    fl_nc->yt_ocean =  fl_nc_axis->yt_ocean
    fl_nc->st_ocean =  fl_nc_axis->st_ocean

    ; define file variables with their dimensions and attributes
    filevardef(fl_nc, "temp", "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))    
    filevardef(fl_nc, "salt", "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))    

    temp_att               = True
    temp_att@description   = "SODA generated temperature correctors"
    temp_att@units         = "degrees C"
    temp_att@_FillValue    = -1.e20
    temp_att@missing_value = -1.e20
    
    salt_att               = True
    salt_att@description   = "SODA generated salinity correctors"
    salt_att@units         = "psu"
    salt_att@_FillValue    = -1.e20
    salt_att@missing_value = -1.e20   

    fl_nc->temp(0, :, :, :) = fbindirread(DIR_SODA2MOM + "/" + str_time + ".correctors.dat", 0, (/50, 180, 360/), "float")
    fl_nc->salt(0, :, :, :) = fbindirread(DIR_SODA2MOM + "/" + str_time + ".correctors.dat", 1, (/50, 180, 360/), "float")
end
