load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

;   setfileoption("nc", "format", "netcdf4") 

    DIR_ROOT_MOM_SODA = "/glade/scratch/lgchen/project/MOM_run/SODA_Reanalysis_2011_2013/test1/MOM_SODA"

    FN_NC_SODA_GRID = "/glade/p/work/lgchen/data/SODA/SODA_2.2.4_201012.cdf"
    FN_NC_MOM_GRID  = DIR_ROOT_MOM_SODA + "/monthly_avg/201101.ocean.nc"

    N_LON_SODA = 720
    N_LAT_SODA = 330
    N_DEP_SODA = 40

    N_LON_MOM = 1440
    N_LAT_MOM = 1070
    N_DEP_MOM = 50

    lon_soda = new((/N_LON_SODA/), "double", -1.0e20)
    lat_soda = new((/N_LAT_SODA/), "double", -1.0e20)
    dep_soda = new((/N_DEP_SODA/), "double", -1.0e20)

    lon_t_mom = new((/N_LON_MOM/), "double", -1.0e20)
    lat_t_mom = new((/N_LAT_MOM/), "double", -1.0e20)
    dep_t_mom = new((/N_DEP_MOM/), "double", -1.0e20)

    lon_u_mom = new((/N_LON_MOM/), "double", -1.0e20)
    lat_u_mom = new((/N_LAT_MOM/), "double", -1.0e20)
    dep_w_mom = new((/N_DEP_MOM/), "double", -1.0e20)


    fl_nc_soda_grid = addfile(FN_NC_SODA_GRID, "r")
    lon_soda        = fl_nc_soda_grid->LON  ; 0.25, 0.75, ..., 359.25, 359.75; 
    lon_soda        = lon_soda - 280.0      ; -279.75, ..., 79.75; 
;   print(lon_soda)
    lat_soda        = fl_nc_soda_grid->LAT  ; -75.25, -74.75, ..., 88.75, 89.25;
    dep_soda        = fl_nc_soda_grid->DEPTH  ; 5.01, 15.07, ..., 5125, 5375;

    fl_nc_mom_grid = addfile(FN_NC_MOM_GRID, "r")
    lon_t_mom      = fl_nc_mom_grid->xt_ocean  ; -279.875, -279.625, ..., 79.625, 79.875;
    lat_t_mom      = fl_nc_mom_grid->yt_ocean  ; -80.0210149417876, -79.9154163525827, ..., 89.8416837378448, 89.9472823270499;
    dep_t_mom      = fl_nc_mom_grid->st_ocean  ; 5.03354978561401, 15.1006498336792, ..., 5185.11083984375, 5395.02294921875;
    lon_u_mom      = fl_nc_mom_grid->xu_ocean  ; -279.75, -279.5, ..., 79.5, 79.75, 80 ;
    lat_u_mom      = fl_nc_mom_grid->yu_ocean  ; -79.9682156471851, -79.8626170579802, ..., 89.8944830324473, 90;
    dep_w_mom      = fl_nc_mom_grid->sw_ocean  ; 10.067099571228, 20.1599998474121, ..., 5290.06689453125, 5500;


    VAR_3D_NM_SODA = (/"TEMP", "SALT", "U", "V", "W" /)
    VAR_3D_NM_MOM  = (/"temp", "salt", "u", "v", "wt"/)

    VAR_2D_NM_SODA = (/"SSH"      , "TAUX" , "TAUY" /)
    VAR_2D_NM_MOM  = (/"sea_level", "tau_x", "tau_y"/)

    N_VAR_3D       = dimsizes(VAR_3D_NM_SODA)
    N_VAR_2D       = dimsizes(VAR_2D_NM_SODA)

    var_3d_mom      = new((/N_DEP_MOM , N_LAT_MOM , N_LON_MOM /), "float", -1.0e20)
    var_3d_soda_tmp = new((/N_DEP_MOM , N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)
    var_3d_soda_rot = new((/N_DEP_SODA, N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)
    var_3d_soda     = new((/N_DEP_SODA, N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)

    var_2d_mom      = new((/            N_LAT_MOM , N_LON_MOM /), "float", -1.0e20)
    var_2d_soda_rot = new((/            N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)
    var_2d_soda     = new((/            N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)


    TEMP_att               = True
    TEMP_att@long_name     = "TEMPERATURE"
    TEMP_att@units         = "deg. C"
    TEMP_att@long_name_mod = "monthly average"

    SALT_att               = True
    SALT_att@long_name     = "SALINITY"
;   SALT_att@units         = "g/kg"
    SALT_att@units         = "psu"
    SALT_att@long_name_mod = "monthly average"

    U_att                  = True
    U_att@long_name        = "ZONAL VELOCITY"
    U_att@units            = "m/sec"
    U_att@long_name_mod    = "monthly average"

    V_att                  = True
    V_att@long_name        = "MERIDIONAL VELOCITY"
    V_att@units            = "m/sec"
    V_att@long_name_mod    = "monthly average"

    W_att                  = True
    W_att@long_name        = "VERTICAL VELOCITY"
    W_att@units            = "m/sec"
    W_att@long_name_mod    = "monthly average"

    TAUX_att                  = True
    TAUX_att@long_name        = "TAU X"
    TAUX_att@units            = "N/m^2"
    TAUX_att@long_name_mod    = "monthly average"

    TAUY_att                  = True
    TAUY_att@long_name        = "TAU Y"
    TAUY_att@units            = "N/m^2"
    TAUY_att@long_name_mod    = "monthly average"

    SSH_att                  = True
;   SSH_att@missingvalue     = -1.0e20
    SSH_att@long_name        = "SEA LEVEL HEIGHT"
    SSH_att@units            = "m"
    SSH_att@long_name_mod    = "monthly average"


    do i_yr = 2011, 2013
        do i_mon = 1, 12
            str_date   = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon)
            print("current month: " + str_date)

            fn_nc_mom  = str_date + ".ocean.nc"
            fn_nc_soda = "SODA_2.2.4_" + str_date + ".cdf"

            ; mom file
            fl_nc_mom = addfile(DIR_ROOT_MOM_SODA + "/monthly_avg/" + fn_nc_mom, "r")


            ; create and define SODA reanalysis file
            system("rm " + DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/" + fn_nc_soda)
            fl_nc_soda = addfile(DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/" + fn_nc_soda, "c")
     
            ; define file (global) attributes)
            setfileoption(fl_nc_soda, "DefineMode", True)

            global_att = True
            global_att@description = "SODA reanalysis generated with MOM5"
            fileattdef(fl_nc_soda, global_att)

            ; define file dimensions
            dim_names = (/"DEPTH"   , "LAT"     , "LON"     , "bnds"/)
            dim_sizes = (/N_DEP_SODA, N_LAT_SODA, N_LON_SODA, 2     /)
            dim_unlim = (/False     , False     , False     , False /)
            filedimdef(fl_nc_soda, dim_names, dim_sizes, dim_unlim)

            ; copy dimension vars directly from old SODA file, no need to define.
            fl_nc_soda->LON        = fl_nc_soda_grid->LON
            fl_nc_soda->LON_bnds   = fl_nc_soda_grid->LON_bnds(0:N_LON_SODA-1, 0:1)
            fl_nc_soda->LAT        = fl_nc_soda_grid->LAT     
            fl_nc_soda->LAT_bnds   = fl_nc_soda_grid->LAT_bnds
            fl_nc_soda->DEPTH      = fl_nc_soda_grid->DEPTH
            fl_nc_soda->DEPTH_bnds = fl_nc_soda_grid->DEPTH_bnds

            ; define file vars with their dims and attributes
;           filevardef(fl_nc_soda, "TEMP", "float", (/"DEPTH", "LAT", "LON"/))
            filevardef(fl_nc_soda, (/"TEMP", "SALT", "U"  , "V", "W"/), (/"float", "float", "float", "float", "float"/), (/"DEPTH", "LAT", "LON"/))
            filevardef(fl_nc_soda, (/"TAUX", "TAUY", "SSH"          /), (/"float", "float", "float"                  /), (/         "LAT", "LON"/))


            TEMP_att@history       = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "TEMP", TEMP_att)
            fl_nc_soda->TEMP@_FillValue = -1.e20

            SALT_att@history = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "SALT", SALT_att)
            fl_nc_soda->SALT@_FillValue = -1.e20

            U_att@history = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "U", U_att)
            fl_nc_soda->U@_FillValue = -1.e20

            V_att@history = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "V", V_att)
            fl_nc_soda->V@_FillValue = -1.e20
           
            W_att@history = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "W", W_att)
            fl_nc_soda->W@_FillValue = -1.e20

            TAUX_att@history = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "TAUX", TAUX_att)
            fl_nc_soda->TAUX@_FillValue = -1.e20

            TAUY_att@history = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "TAUY", TAUY_att)
            fl_nc_soda->TAUY@_FillValue = -1.e20

            SSH_att@history = "From " + str_date + ".ocean.nc"
            filevarattdef(fl_nc_soda, "SSH", SSH_att)
            fl_nc_soda->SSH@_FillValue = -1.e20

;           setfileoption(fl_nc_soda, "DefineMode", False)

            do i_var_3d = 0, N_VAR_3D - 1
                print("i_var_3d = " + i_var_3d)

                if (i_var_3d .eq. 0 .or. i_var_3d .eq. 1) then  ; TEMP and SALT
                    var_3d_mom               = fl_nc_mom->$VAR_3D_NM_MOM(i_var_3d)$(0, :, :, :)
                    print("Running linint2 ...")
                    var_3d_soda_tmp          = linint2(lon_t_mom, lat_t_mom, var_3d_mom, True, lon_soda, lat_soda, 0)
                    print("Running linint1_n ...")
                    var_3d_soda_rot          = linint1_n(dep_t_mom, var_3d_soda_tmp, False, dep_soda, 0, 0)
                    var_3d_soda_rot(0, :, :) = var_3d_soda_tmp(0, :, :)

                    ; rotate
                    var_3d_soda(:, :, 0  :159) = var_3d_soda_rot(:, :, 560:719)
                    var_3d_soda(:, :, 160:719) = var_3d_soda_rot(:, :,   0:559)
                    print("Writing out ...")
                    fl_nc_soda->$VAR_3D_NM_SODA(i_var_3d)$ = var_3d_soda
                else if (i_var_3d .eq. 2 .or. i_var_3d .eq. 3) then  ; u, v
                    var_3d_mom               = fl_nc_mom->$VAR_3D_NM_MOM(i_var_3d)$(0, :, :, :)
                    print("Running linint2 ...")
                    var_3d_soda_tmp          = linint2(lon_u_mom, lat_u_mom, var_3d_mom, True, lon_soda, lat_soda, 0)
                    print("Running linint1_n ...")
                    var_3d_soda_rot          = linint1_n(dep_t_mom, var_3d_soda_tmp, False, dep_soda, 0, 0)
                    var_3d_soda_rot(0, :, :) = var_3d_soda_tmp(0, :, :)

                    var_3d_soda(:, :, 0  :159) = var_3d_soda_rot(:, :, 560:719)
                    var_3d_soda(:, :, 160:719) = var_3d_soda_rot(:, :,   0:559)
                    print("Writing out ...")
                    fl_nc_soda->$VAR_3D_NM_SODA(i_var_3d)$ = var_3d_soda
                else  ; "W"
                    var_3d_mom               = fl_nc_mom->$VAR_3D_NM_MOM(i_var_3d)$(0, :, :, :)
                    print("Running linint2 ...")
                    var_3d_soda_tmp          = linint2(lon_t_mom, lat_t_mom, var_3d_mom, True, lon_soda, lat_soda, 0)
                    print("Running linint1_n ...")
                    var_3d_soda_rot          = linint1_n(dep_w_mom, var_3d_soda_tmp, False, dep_soda, 0, 0)
                    var_3d_soda_rot(0, :, :) = var_3d_soda_tmp(0, :, :)

                    var_3d_soda(:, :, 0  :159) = var_3d_soda_rot(:, :, 560:719)
                    var_3d_soda(:, :, 160:719) = var_3d_soda_rot(:, :,   0:559)
                    print("Writing out ...")
                    fl_nc_soda->$VAR_3D_NM_SODA(i_var_3d)$ = var_3d_soda
                end if
                end if
            end do 


            do i_var_2d = 0, N_VAR_2D - 1
                print("i_var_2d = " + i_var_2d)

                if (i_var_2d .eq. 0) then  ; sea_level
                    var_2d_mom      = fl_nc_mom->$VAR_2D_NM_MOM(i_var_2d)$(0, :, :)
                    var_2d_soda_rot = linint2(lon_t_mom, lat_t_mom, var_2d_mom, True, lon_soda, lat_soda, 0)

                    ; rotate
                    var_2d_soda(:, 0  :159) = var_2d_soda_rot(:, 560:719)
                    var_2d_soda(:, 160:719) = var_2d_soda_rot(:,   0:559)
                    fl_nc_soda->$VAR_2D_NM_SODA(i_var_2d)$ = var_2d_soda
                else  ; tau_x, tau_y
                    var_2d_mom = fl_nc_mom->$VAR_2D_NM_MOM(i_var_2d)$(0, :, :)
                    var_2d_soda_rot = linint2(lon_u_mom, lat_u_mom, var_2d_mom, True, lon_soda, lat_soda, 0)

                    var_2d_soda(:, 0  :159) = var_2d_soda_rot(:, 560:719)
                    var_2d_soda(:, 160:719) = var_2d_soda_rot(:,   0:559)
                    fl_nc_soda->$VAR_2D_NM_SODA(i_var_2d)$ = var_2d_soda
                end if
            end do 

        end do  ; end of "do i_mon = 1, 12"
    end do      ; end of "do i_yr = 2011, 2013"

end
