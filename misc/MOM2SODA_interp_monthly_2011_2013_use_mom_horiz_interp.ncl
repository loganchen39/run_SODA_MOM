load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_CODE_MOM_REGRID = "/glade/u/home/lgchen/project/mom_Gena/src/postprocessing/regrid/workdir/2011_2013_monthly_avg"
    DIR_ROOT_MOM_SODA   = "/glade/scratch/lgchen/project/MOM_run/SODA_Reanalysis_2011_2013/test3/MOM_SODA"

    FN_NC_SODA_GRID = "/glade/p/work/lgchen/data/SODA/SODA_2.2.4_200812.cdf"
    FN_NC_MOM_GRID  = DIR_ROOT_MOM_SODA + "/monthly_avg_ocean/201101.ocean.nc"

    N_LON_SODA = 720
    N_LAT_SODA = 330
    N_DEP_SODA = 40

    N_LON_MOM = 1440
    N_LAT_MOM = 1070
    N_DEP_MOM = 50

    dep_soda  = new((/N_DEP_SODA/), "double", -9.99e+33)
    dep_t_mom = new((/N_DEP_MOM/), "double", -9.99e+33)
    dep_w_mom = new((/N_DEP_MOM/), "double", -9.99e+33)

    fl_nc_soda_grid = addfile(FN_NC_SODA_GRID, "r")
    dep_soda        = fl_nc_soda_grid->depth  ; 5.01, 15.07, ..., 5125, 5375;

    fl_nc_mom_grid = addfile(FN_NC_MOM_GRID, "r")
    dep_t_mom      = fl_nc_mom_grid->st_ocean  ; 5.03354978561401, 15.1006498336792, ..., 5185.11083984375, 5395.02294921875;
    dep_w_mom      = fl_nc_mom_grid->sw_ocean  ; 10.067099571228, 20.1599998474121, ..., 5290.06689453125, 5500;


    VAR_3D_NM_SODA = (/"temp", "salt", "u", "v", "w" /)
    VAR_3D_NM_MOM  = (/"temp", "salt", "u", "v", "wt"/)

    VAR_2D_NM_SODA = (/"ssh"      , "taux" , "tauy" /)
    VAR_2D_NM_MOM  = (/"sea_level", "tau_x", "tau_y"/)

    N_VAR_3D       = dimsizes(VAR_3D_NM_SODA)
    N_VAR_2D       = dimsizes(VAR_2D_NM_SODA)

    var_3d_soda_tmp   = new((/N_DEP_MOM , N_LAT_SODA, N_LON_SODA/), "float", -9.99e+33)
    var_3d_soda_rot   = new((/N_DEP_SODA, N_LAT_SODA, N_LON_SODA/), "float", -9.99e+33)
    var_3d_soda       = new((/N_DEP_SODA, N_LAT_SODA, N_LON_SODA/), "float", -9.99e+33)

    var_2d_soda_rot = new((/            N_LAT_SODA, N_LON_SODA/), "float", -9.99e+33)
    var_2d_soda     = new((/            N_LAT_SODA, N_LON_SODA/), "float", -9.99e+33)


    temp_att               = True
    temp_att@long_name     = "TEMPERATURE"
    temp_att@units         = "deg. C"

    salt_att               = True
    salt_att@long_name     = "SALINITY"
;   salt_att@units         = "g/kg"
    salt_att@units         = "psu"

    u_att                  = True
    u_att@long_name        = "ZONAL VELOCITY"
    u_att@units            = "m/sec"

    v_att                  = True
    v_att@long_name        = "MERIDIONAL VELOCITY"
    v_att@units            = "m/sec"

    w_att                  = True
    w_att@long_name        = "VERTICAL VELOCITY"
    w_att@units            = "m/sec"

    taux_att               = True
    taux_att@long_name     = "TAU X"
    taux_att@units         = "N/m^2"

    tauy_att               = True
    tauy_att@long_name     = "TAU Y"
    tauy_att@units         = "N/m^2"

    ssh_att                = True
    ssh_att@long_name      = "SEA LEVEL HEIGHT"
    ssh_att@units          = "m"


    system("cd " + DIR_CODE_MOM_REGRID)

    do i_yr = 2011, 2012  ; 2013
        do i_mon = 1, 12
            str_date   = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon)
            print("current month: " + str_date)

            fn_nc_mom  = str_date + ".ocean.nc"

            ; do horizontal interpolation with MOM postprocessing regrid tool
            system("ln -sf " + DIR_ROOT_MOM_SODA + "/monthly_avg_ocean/" + fn_nc_mom + " ./MOM.ocean.nc")
            system("rm fms." + str_date + ".out")
            system("mpirun.lsf regrid.exe >&! fms." + str_date + ".out")

            fn_nc_soda = "SODA_3.0_" + str_date + ".nc"
            system("mv -f " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA   \
                + "/MOM2SODA_interp/with_MOM_regrid/" + fn_nc_soda)


;           ; vertical interpolation            
;           ; MOM horizontally interpolated file by MOM regrid
;           fl_nc_mom_regrid = addfile(DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc", "r")


;           ; create and define SODA reanalysis file
;           fn_nc_soda = "SODA_2.2.4_" + str_date + ".cdf"
;           system("rm " + DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/with_MOM_regrid/" + fn_nc_soda)
;           fl_nc_soda = addfile(DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/with_MOM_regrid/" + fn_nc_soda, "c")
;    
;           ; define file (global) attributes)
;           global_att = True
;           global_att@title = "SODA 2.2.4, complement for 2011-2013 with MOM5 model"
;           fileattdef(fl_nc_soda, global_att)

;           ; define file dimensions
;           dim_names = (/"depth"   , "lat"     , "lon"     /)
;           dim_sizes = (/N_DEP_SODA, N_LAT_SODA, N_LON_SODA/)
;           dim_unlim = (/False     , False     , False     /)
;           filedimdef(fl_nc_soda, dim_names, dim_sizes, dim_unlim)

;           ; copy dimension vars directly from old SODA file, no need to define.
;           fl_nc_soda->lon        = fl_nc_soda_grid->lon
;           fl_nc_soda->lat        = fl_nc_soda_grid->lat     
;           fl_nc_soda->depth      = fl_nc_soda_grid->depth

;           ; define file vars with their dims and attributes
;           filevardef(fl_nc_soda, (/"temp", "salt", "u"  , "v", "w"/), (/"float", "float", "float", "float", "float"/), (/"depth", "lat", "lon"/))
;           filevardef(fl_nc_soda, (/"taux", "tauy", "ssh"          /), (/"float", "float", "float"                  /), (/         "lat", "lon"/))

;           filevarattdef(fl_nc_soda, "temp", temp_att)
;           fl_nc_soda->temp@_FillValue = -9.99e+33

;           filevarattdef(fl_nc_soda, "salt", salt_att)
;           fl_nc_soda->salt@_FillValue = -9.99e+33

;           filevarattdef(fl_nc_soda, "u", u_att)
;           fl_nc_soda->u@_FillValue = -9.99e+33

;           filevarattdef(fl_nc_soda, "v", v_att)
;           fl_nc_soda->v@_FillValue = -9.99e+33
;          
;           filevarattdef(fl_nc_soda, "w", w_att)
;           fl_nc_soda->w@_FillValue = -9.99e+33

;           filevarattdef(fl_nc_soda, "taux", taux_att)
;           fl_nc_soda->taux@_FillValue = -9.99e+33

;           filevarattdef(fl_nc_soda, "tauy", tauy_att)
;           fl_nc_soda->tauy@_FillValue = -9.99e+33

;           filevarattdef(fl_nc_soda, "ssh", ssh_att)
;           fl_nc_soda->ssh@_FillValue = -9.99e+33

;           do i_var_3d = 0, N_VAR_3D - 1
;               print("i_var_3d = " + i_var_3d)

;               var_3d_soda_tmp = doubletofloat(fl_nc_mom_regrid->$VAR_3D_NM_MOM(i_var_3d)$(0, :, :, :))
;               var_3d_soda_tmp = where(var_3d_soda_tmp .eq. -1.e20 .or. abs(var_3d_soda_tmp) .gt. 1.e10  \
;                   , var_3d_soda_tmp@_FillValue, var_3d_soda_tmp)
;               print("Running linint1_n ...")
;               if (i_var_3d .ne. N_VAR_3D - 1) then
;                   var_3d_soda_rot = linint1_n(dep_t_mom, var_3d_soda_tmp, False, dep_soda, 0, 0)
;               else  ; "w"
;                   var_3d_soda_rot = linint1_n(dep_w_mom, var_3d_soda_tmp, False, dep_soda, 0, 0)
;               end if
;               var_3d_soda_rot(0, :, :) = var_3d_soda_tmp(0, :, :)

;               ; no rotate
;               var_3d_soda = var_3d_soda_rot
;               print("Writing out ...")
;               fl_nc_soda->$VAR_3D_NM_SODA(i_var_3d)$ = var_3d_soda
;           end do 


;           do i_var_2d = 0, N_VAR_2D - 1
;               print("i_var_2d = " + i_var_2d)
;               var_2d_soda_rot = doubletofloat(fl_nc_mom_regrid->$VAR_2D_NM_MOM(i_var_2d)$(0, :, :))
;               var_2d_soda_rot = where(var_2d_soda_rot .eq. -1.e20 .or. abs(var_2d_soda_rot) .gt. 1.e10  \
;                   , var_2d_soda_rot@_FillValue, var_2d_soda_rot)

;               ; no rotate
;               var_2d_soda = var_2d_soda_rot
;               print("Writing out ...")
;               fl_nc_soda->$VAR_2D_NM_SODA(i_var_2d)$ = var_2d_soda
;           end do 

        end do  ; end of "do i_mon = 1, 12"
    end do      ; end of "do i_yr = 2011, 2013"

end
