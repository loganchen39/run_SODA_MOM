load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"

external LIBCLG "/glade/u/home/lgchen/lib/fortran/libclg.so"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

  ; DIR_ROOT_SODA_ANALYSIS = "/glade/scratch/lgchen/project/MOM_run/SODA_1979_2014/test1/MOM_SODA"
    DIR_ROOT_SODA_ANALYSIS = "/glade/p/umcp0006/SODA_338"

  ; VAR_STATIC  = (/"xt_ocean", "yt_ocean", "nv", "st_ocean", "st_edges_ocean", "xu_ocean", "yu_ocean", "sw_ocean"  \
  ;     , "sw_edges_ocean", "geolon_t", "geolat_t"/)
  ; VAR_DYNAMIC = (/"temp", "salt", "u", "v", "ssh", "mlt", "mlp", "mls", "pbot", "wt", "prho", "taux", "tauy"/)  ; time

    VAR_STATIC  = (/"xt_ocean", "yt_ocean", "nv", "st_ocean", "st_edges_ocean", "xu_ocean", "yu_ocean", "sw_ocean"  \
        , "sw_edges_ocean"/)
    VAR_DYNAMIC = (/"temp", "salt", "u", "v", "ssh", "mlt", "mlp", "mls", "anompb", "sbd", "sbd_mld", "sbd_dhdt"  \
        , "sbd_horz", "sbd_vert", "wt", "prho", "taux", "tauy", "hflux_total", "net_heating", "salt_flux_rstr"    \
        , "salt_flux_total"/)  ; time

    N_VAR_STATIC  = dimsizes(VAR_STATIC )
    N_VAR_DYNAMIC = dimsizes(VAR_DYNAMIC)

    ; dimensions
    xt_ocean       = 1440
    yt_ocean       = 1070
  ; time           = 2     ; UNLIMITED
    time           = 1     ; UNLIMITED
    nv             = 2
    st_ocean       = 50
    st_edges_ocean = 51
    xu_ocean       = 1440
    yu_ocean       = 1070
    sw_ocean       = 50
    sw_edges_ocean = 51

    avg_temp            = new ((/1, st_ocean, yt_ocean, xt_ocean/), "float", -1.e20)
    avg_salt            = new ((/1, st_ocean, yt_ocean, xt_ocean/), "float", -1.e20)
    avg_u               = new ((/1, st_ocean, yu_ocean, xu_ocean/), "float", -1.e20)
    avg_v               = new ((/1, st_ocean, yu_ocean, xu_ocean/), "float", -1.e20)
    avg_ssh             = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_mlt             = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_mlp             = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_mls             = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_anompb          = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_sbd             = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_sbd_mld         = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_sbd_dhdt        = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_sbd_horz        = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_sbd_vert        = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_wt              = new ((/1, sw_ocean, yt_ocean, xt_ocean/), "float", -1.e20)
    avg_prho            = new ((/1, st_ocean, yu_ocean, xu_ocean/), "float", -1.e20)
    avg_taux            = new ((/1,           yu_ocean, xu_ocean/), "float", -1.e20)
    avg_tauy            = new ((/1,           yu_ocean, xu_ocean/), "float", -1.e20)
    avg_hflux_total     = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_net_heating     = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_salt_flux_rstr  = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)
    avg_salt_flux_total = new ((/1,           yt_ocean, xt_ocean/), "float", -1.e20)

    avg_temp            = 0.0
    avg_salt            = 0.0
    avg_u               = 0.0
    avg_v               = 0.0
    avg_ssh             = 0.0
    avg_mlt             = 0.0
    avg_mlp             = 0.0
    avg_mls             = 0.0
    avg_anompb          = 0.0
    avg_sbd             = 0.0
    avg_sbd_mld         = 0.0
    avg_sbd_dhdt        = 0.0
    avg_sbd_horz        = 0.0
    avg_sbd_vert        = 0.0
    avg_wt              = 0.0
    avg_prho            = 0.0
    avg_taux            = 0.0
    avg_tauy            = 0.0
    avg_hflux_total     = 0.0
    avg_net_heating     = 0.0
    avg_salt_flux_rstr  = 0.0
    avg_salt_flux_total = 0.0

    ; dimension file example
  ; FL_NC_DIM = addfile(DIR_ROOT_SODA_ANALYSIS + "/19790101/history/19790101.5days.nc", "r")
    FL_NC_DIM = addfile(DIR_ROOT_SODA_ANALYSIS + "/ORIGINAL/ocean_5dy_1980_01_08.nc", "r")


    START_YEAR  = 1980
    START_MONTH = 1
    START_DAY   = 1
    END_YEAR    = 2015
    END_MONTH   = 6
    END_DAY     = 23

    jul_day_19800103 = greg2jul(1980, 1 , 3 , -1)
    jul_day_19811101 = greg2jul(1981, 11, 1 , -1)
    jul_day_20150623 = greg2jul(2015, 6 , 23, -1)

    i_jul_day = jul_day_19800103
    curr_yr   = 1980
    curr_mon  = 1

    do while(i_jul_day .lt. jul_day_20150623)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_month = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon)
        str_date  = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        print("str_date = " + str_date)

        curr_dinm = days_in_month(curr_yr, curr_mon)

        abs_fn_nc_5day_avg = DIR_ROOT_SODA_ANALYSIS + "/ORIGINAL/ocean_5dy_" + str_date + ".nc"
        fl_nc_5day_avg     = addfile(abs_fn_nc_5day_avg, "r")

        if (i_yr .eq. curr_yr .and. i_mon .eq. curr_mon) then
            if (i_day + 2 .le. curr_dinm) then
                avg_temp           (0, :, :, :) = avg_temp           (0, :, :, :) + 5.0 * fl_nc_5day_avg->temp           (0, :, :, :)
                avg_salt           (0, :, :, :) = avg_salt           (0, :, :, :) + 5.0 * fl_nc_5day_avg->salt           (0, :, :, :)
                avg_u              (0, :, :, :) = avg_u              (0, :, :, :) + 5.0 * fl_nc_5day_avg->u              (0, :, :, :)
                avg_v              (0, :, :, :) = avg_v              (0, :, :, :) + 5.0 * fl_nc_5day_avg->v              (0, :, :, :)
                avg_ssh            (0,    :, :) = avg_ssh            (0,    :, :) + 5.0 * fl_nc_5day_avg->ssh            (0,    :, :)
                avg_mlt            (0,    :, :) = avg_mlt            (0,    :, :) + 5.0 * fl_nc_5day_avg->mlt            (0,    :, :)
                avg_mlp            (0,    :, :) = avg_mlp            (0,    :, :) + 5.0 * fl_nc_5day_avg->mlp            (0,    :, :)
                avg_mls            (0,    :, :) = avg_mls            (0,    :, :) + 5.0 * fl_nc_5day_avg->mls            (0,    :, :)

                avg_anompb         (0,    :, :) = avg_anompb         (0,    :, :) + 5.0 * fl_nc_5day_avg->anompb         (0,    :, :)
                avg_sbd            (0,    :, :) = avg_sbd            (0,    :, :) + 5.0 * fl_nc_5day_avg->sbd            (0,    :, :)
                avg_sbd_mld        (0,    :, :) = avg_sbd_mld        (0,    :, :) + 5.0 * fl_nc_5day_avg->sbd_mld        (0,    :, :)
                avg_sbd_dhdt       (0,    :, :) = avg_sbd_dhdt       (0,    :, :) + 5.0 * fl_nc_5day_avg->sbd_dhdt       (0,    :, :)
                avg_sbd_horz       (0,    :, :) = avg_sbd_horz       (0,    :, :) + 5.0 * fl_nc_5day_avg->sbd_horz       (0,    :, :)
                avg_sbd_vert       (0,    :, :) = avg_sbd_vert       (0,    :, :) + 5.0 * fl_nc_5day_avg->sbd_vert       (0,    :, :)

                avg_wt             (0, :, :, :) = avg_wt             (0, :, :, :) + 5.0 * fl_nc_5day_avg->wt             (0, :, :, :)
                avg_prho           (0, :, :, :) = avg_prho           (0, :, :, :) + 5.0 * fl_nc_5day_avg->prho           (0, :, :, :)
                avg_taux           (0,    :, :) = avg_taux           (0,    :, :) + 5.0 * fl_nc_5day_avg->taux           (0,    :, :)
                avg_tauy           (0,    :, :) = avg_tauy           (0,    :, :) + 5.0 * fl_nc_5day_avg->tauy           (0,    :, :)

                avg_hflux_total    (0,    :, :) = avg_hflux_total    (0,    :, :) + 5.0 * fl_nc_5day_avg->hflux_total    (0,    :, :)
                avg_net_heating    (0,    :, :) = avg_net_heating    (0,    :, :) + 5.0 * fl_nc_5day_avg->net_heating    (0,    :, :)
                avg_salt_flux_rstr (0,    :, :) = avg_salt_flux_rstr (0,    :, :) + 5.0 * fl_nc_5day_avg->salt_flux_rstr (0,    :, :)
                avg_salt_flux_total(0,    :, :) = avg_salt_flux_total(0,    :, :) + 5.0 * fl_nc_5day_avg->salt_flux_total(0,    :, :)



                if (i_day + 2 .eq. curr_dinm) then
                    print("i_day + 2 .eq. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                        + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                    avg_temp = 1.0*avg_temp / curr_dinm
                    avg_salt = 1.0*avg_salt / curr_dinm
                    avg_u    = 1.0*avg_u    / curr_dinm
                    avg_v    = 1.0*avg_v    / curr_dinm
                    avg_ssh  = 1.0*avg_ssh  / curr_dinm
                    avg_mlt  = 1.0*avg_mlt  / curr_dinm
                    avg_mlp  = 1.0*avg_mlp  / curr_dinm
                    avg_mls  = 1.0*avg_mls  / curr_dinm

                    avg_anompb   = 1.0*avg_anompb   / curr_dinm
                    avg_sbd      = 1.0*avg_sbd      / curr_dinm
                    avg_sbd_mld  = 1.0*avg_sbd_mld  / curr_dinm
                    avg_sbd_dhdt = 1.0*avg_sbd_dhdt / curr_dinm
                    avg_sbd_horz = 1.0*avg_sbd_horz / curr_dinm
                    avg_sbd_vert = 1.0*avg_sbd_vert / curr_dinm

                    avg_wt   = 1.0*avg_wt   / curr_dinm
                    avg_prho = 1.0*avg_prho / curr_dinm
                    avg_taux = 1.0*avg_taux / curr_dinm
                    avg_tauy = 1.0*avg_tauy / curr_dinm

                    avg_hflux_total     = 1.0*avg_hflux_total     / curr_dinm
                    avg_net_heating     = 1.0*avg_net_heating     / curr_dinm
                    avg_salt_flux_rstr  = 1.0*avg_salt_flux_rstr  / curr_dinm
                    avg_salt_flux_total = 1.0*avg_salt_flux_total / curr_dinm

                  ; LIBCLG::write_out_5dayavg2monthlyavg_soda_mom(curr_yr, curr_mon, avg_temp, avg_salt, avg_u, avg_v  \
                  ;     , avg_sea_level, avg_wt, avg_taux, avg_tauy, xt_ocean, yt_ocean, st_ocean)

                  ; LIBCLG::write_out_5dayavg2monthlyavg_soda_mom_1979_1981(curr_yr, curr_mon, avg_temp, avg_salt, avg_u, avg_v  \
                  ;     , avg_ssh, avg_mlt, avg_mlp, avg_mls, avg_pbot, avg_wt, avg_prho, avg_taux, avg_tauy, xt_ocean, yt_ocean, st_ocean)

                    LIBCLG::write_out_5dayavg2monthlyavg_soda_mom_339(curr_yr, curr_mon, avg_temp, avg_salt, avg_u, avg_v  \
                        , avg_ssh, avg_mlt, avg_mlp, avg_mls, avg_anompb, avg_sbd, avg_sbd_mld, avg_sbd_dhdt, avg_sbd_horz \
                        , avg_sbd_vert, avg_wt, avg_prho, avg_taux, avg_tauy, avg_hflux_total, avg_net_heating             \
                        , avg_salt_flux_rstr, avg_salt_flux_total, xt_ocean, yt_ocean, st_ocean)

                    ; re-initialize for the next month
                    if (curr_mon .lt. 12) then
                        curr_mon = curr_mon + 1
                    else if (curr_mon .eq. 12) then
                        curr_mon = 1
                        curr_yr  = curr_yr + 1
                    end if
                    end if
                    curr_dinm = days_in_month(curr_yr, curr_mon)

                    avg_temp = 0.0 
                    avg_salt = 0.0 
                    avg_u    = 0.0 
                    avg_v    = 0.0 
                    avg_ssh  = 0.0 
                    avg_mlt  = 0.0 
                    avg_mlp  = 0.0 
                    avg_mls  = 0.0 

                    avg_anompb   = 0.0
                    avg_sbd      = 0.0
                    avg_sbd_mld  = 0.0
                    avg_sbd_dhdt = 0.0
                    avg_sbd_horz = 0.0
                    avg_sbd_vert = 0.0

                    avg_wt   = 0.0 
                    avg_prho = 0.0 
                    avg_taux = 0.0 
                    avg_tauy = 0.0

                    avg_hflux_total     = 0.0
                    avg_net_heating     = 0.0
                    avg_salt_flux_rstr  = 0.0
                    avg_salt_flux_total = 0.0
                end if  ; end of "if (i_day + 2 .eq. curr_dinm) then"
            else if (i_day + 2 .gt. curr_dinm)
                avg_temp(0, :, :, :) = avg_temp(0, :, :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->temp(0, :, :, :)
                avg_salt(0, :, :, :) = avg_salt(0, :, :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->salt(0, :, :, :)
                avg_u   (0, :, :, :) = avg_u   (0, :, :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->u   (0, :, :, :)
                avg_v   (0, :, :, :) = avg_v   (0, :, :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->v   (0, :, :, :)
                avg_ssh (0,    :, :) = avg_ssh (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->ssh (0,    :, :)
                avg_mlt (0,    :, :) = avg_mlt (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->mlt (0,    :, :)
                avg_mlp (0,    :, :) = avg_mlp (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->mlp (0,    :, :)
                avg_mls (0,    :, :) = avg_mls (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->mls (0,    :, :)

                avg_anompb  (0,    :, :) = avg_anompb  (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->anompb  (0,    :, :)
                avg_sbd     (0,    :, :) = avg_sbd     (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->sbd     (0,    :, :)
                avg_sbd_mld (0,    :, :) = avg_sbd_mld (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->sbd_mld (0,    :, :)
                avg_sbd_dhdt(0,    :, :) = avg_sbd_dhdt(0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->sbd_dhdt(0,    :, :)
                avg_sbd_horz(0,    :, :) = avg_sbd_horz(0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->sbd_horz(0,    :, :)
                avg_sbd_vert(0,    :, :) = avg_sbd_vert(0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->sbd_vert(0,    :, :)

                avg_wt  (0, :, :, :) = avg_wt  (0, :, :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->wt  (0, :, :, :)
                avg_prho(0, :, :, :) = avg_prho(0, :, :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->prho(0, :, :, :)
                avg_taux(0,    :, :) = avg_taux(0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->taux(0,    :, :)
                avg_tauy(0,    :, :) = avg_tauy(0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->tauy(0,    :, :)

                avg_hflux_total    (0,    :, :) = avg_hflux_total    (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->hflux_total    (0,    :, :)
                avg_net_heating    (0,    :, :) = avg_net_heating    (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->net_heating    (0,    :, :)
                avg_salt_flux_rstr (0,    :, :) = avg_salt_flux_rstr (0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->salt_flux_rstr (0,    :, :)
                avg_salt_flux_total(0,    :, :) = avg_salt_flux_total(0,    :, :) + 1.0*(curr_dinm-i_day+3)*fl_nc_5day_avg->salt_flux_total(0,    :, :)


                print("i_day + 2 .gt. curr_dinm, writing out monthly avg netCDF file. i_yr = " + sprinti("%0.4i", i_yr)  \
                    + ", i_mon = " + sprinti("%0.2i", i_mon) + ", i_day = " + sprinti("%0.2i", i_day) + ", curr_dinm = " + sprinti("%0.2i", curr_dinm))

                avg_temp = 1.0*avg_temp / curr_dinm
                avg_salt = 1.0*avg_salt / curr_dinm
                avg_u    = 1.0*avg_u    / curr_dinm
                avg_v    = 1.0*avg_v    / curr_dinm
                avg_ssh  = 1.0*avg_ssh  / curr_dinm
                avg_mlt  = 1.0*avg_mlt  / curr_dinm
                avg_mlp  = 1.0*avg_mlp  / curr_dinm
                avg_mls  = 1.0*avg_mls  / curr_dinm

                avg_anompb   = 1.0*avg_anompb   / curr_dinm
                avg_sbd      = 1.0*avg_sbd      / curr_dinm
                avg_sbd_mld  = 1.0*avg_sbd_mld  / curr_dinm
                avg_sbd_dhdt = 1.0*avg_sbd_dhdt / curr_dinm
                avg_sbd_horz = 1.0*avg_sbd_horz / curr_dinm
                avg_sbd_vert = 1.0*avg_sbd_vert / curr_dinm

                avg_wt   = 1.0*avg_wt   / curr_dinm
                avg_prho = 1.0*avg_prho / curr_dinm
                avg_taux = 1.0*avg_taux / curr_dinm
                avg_tauy = 1.0*avg_tauy / curr_dinm

                avg_hflux_total     = 1.0*avg_hflux_total     / curr_dinm
                avg_net_heating     = 1.0*avg_net_heating     / curr_dinm
                avg_salt_flux_rstr  = 1.0*avg_salt_flux_rstr  / curr_dinm
                avg_salt_flux_total = 1.0*avg_salt_flux_total / curr_dinm
 
                LIBCLG::write_out_5dayavg2monthlyavg_soda_mom_339(curr_yr, curr_mon, avg_temp, avg_salt, avg_u, avg_v  \
                    , avg_ssh, avg_mlt, avg_mlp, avg_mls, avg_anompb, avg_sbd, avg_sbd_mld, avg_sbd_dhdt, avg_sbd_horz \
                    , avg_sbd_vert, avg_wt, avg_prho, avg_taux, avg_tauy, avg_hflux_total, avg_net_heating             \
                    , avg_salt_flux_rstr, avg_salt_flux_total, xt_ocean, yt_ocean, st_ocean)

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
 
                avg_temp(0, :, :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->temp(0, :, :, :)
                avg_salt(0, :, :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->salt(0, :, :, :)
                avg_u   (0, :, :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->u   (0, :, :, :)
                avg_v   (0, :, :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->v   (0, :, :, :)
                avg_ssh (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->ssh (0,    :, :)
                avg_mlt (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->mlt (0,    :, :)
                avg_mlp (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->mlp (0,    :, :)
                avg_mls (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->mls (0,    :, :)

                avg_anompb  (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->anompb  (0,    :, :)
                avg_sbd     (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->sbd     (0,    :, :)
                avg_sbd_mld (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->sbd_mld (0,    :, :)
                avg_sbd_dhdt(0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->sbd_dhdt(0,    :, :)
                avg_sbd_horz(0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->sbd_horz(0,    :, :)
                avg_sbd_vert(0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->sbd_vert(0,    :, :)

                avg_wt  (0, :, :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->wt  (0, :, :, :)
                avg_prho(0, :, :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->prho(0, :, :, :)
                avg_taux(0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->taux(0,    :, :)
                avg_tauy(0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->tauy(0,    :, :)

                avg_hflux_total    (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->hflux_total    (0,    :, :)
                avg_net_heating    (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->net_heating    (0,    :, :)
                avg_salt_flux_rstr (0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->salt_flux_rstr (0,    :, :)
                avg_salt_flux_total(0,    :, :) = 1.0*(i_day+2-prev_dinm)*fl_nc_5day_avg->salt_flux_total(0,    :, :)
            end if
            end if
            end if
        else
            print("ERROR: i_yr .ne. curr_yr .or. i_mon .ne. curr_mon, i_yr = " + i_yr + ", i_mon = " + i_mon)
            exit()
        end if

        i_jul_day = i_jul_day + 5 
    end do  ; end of "do while(i_jul_day .lt. jul_day_20150623)"
end
