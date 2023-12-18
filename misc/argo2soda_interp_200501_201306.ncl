load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

;   setfileoption("nc", "format", "netcdf4") 

    DIR_ROOT_ARGO        = "/glade/p/work/lgchen/data/argo_from_jim"
    DIR_ROOT_ARGO_OUTPUT = "/glade/scratch/lgchen/data/argo_from_jim"

    FN_NC_ARGO      = DIR_ROOT_ARGO + "/argo_200501_201306_grd.nc"
    FN_NC_SODA_GRID = "/glade/p/work/lgchen/data/SODA/SODA_2.2.4_201012.cdf"
    FN_NC_MOM5_GRID = "/glade/scratch/lgchen/project/MOM_run/SODA_Reanalysis_2011_2013/test1/MOM_SODA/20110101/history/20110101.ocean.nc"

    N_LON_SODA     = 720
    N_LAT_SODA     = 330
    N_DEP_SODA     = 40
    N_DEP_SODA_v50 = 50

    N_LON_ARGO = 360
    N_LAT_ARGO = 180
    N_DEP_ARGO = 27

    lon_soda     = new((/N_LON_SODA    /), "double", -1.0e20)
    lat_soda     = new((/N_LAT_SODA    /), "double", -1.0e20)
    dep_soda     = new((/N_DEP_SODA    /), "double", -1.0e20)
    dep_soda_v50 = new((/N_DEP_SODA_v50/), "double", -1.0e20)

    lon_argo = new((/N_LON_ARGO/), "float", -999.0)
    lat_argo = new((/N_LAT_ARGO/), "float", -999.0)
    dep_argo = new((/N_DEP_ARGO/), "float", -999.0)

    fl_nc_soda_grid = addfile(FN_NC_SODA_GRID, "r")
    lon_soda        = fl_nc_soda_grid->LON
    lat_soda        = fl_nc_soda_grid->LAT
    dep_soda        = fl_nc_soda_grid->DEPTH

    fl_nc_mom5_grid = addfile(FN_NC_MOM5_GRID, "r")
    dep_soda_v50    = fl_nc_mom5_grid->st_ocean

    fl_nc_argo = addfile(FN_NC_ARGO, "r")
    lon_argo   = fl_nc_argo->LONGITUDE
    lat_argo   = fl_nc_argo->LATITUDE
    dep_argo   = fl_nc_argo->LEVEL

    VAR_3D_NM_ARGO = (/"TEMP", "SALT", "PTEMP", "PDEN", "ADDEP", "SPICE"/)
    N_VAR_3D       = dimsizes(VAR_3D_NM_ARGO)

    var_3d_argo     = new((/N_DEP_ARGO    , N_LAT_ARGO, N_LON_ARGO/), "float", -999.0)
    var_3d_soda_tmp = new((/N_DEP_ARGO    , N_LAT_SODA, N_LON_SODA/), "float", -999.0)
    var_3d_soda     = new((/N_DEP_SODA    , N_LAT_SODA, N_LON_SODA/), "float", -999.0)
    var_3d_soda_v50 = new((/N_DEP_SODA_v50, N_LAT_SODA, N_LON_SODA/), "float", -999.0)


    TEMP_att               = True
    TEMP_att@units         = "degC"
    TEMP_att@title         = "Argo Temperature Monthly Mean"
    TEMP_att@long_name     = "Argo Temperature Monthly Mean"
    TEMP_att@missing_value = -999.0

    SALT_att               = True
    SALT_att@units         = "PSU"
    SALT_att@title         = "Argo Salinity Monthly Mean"
    SALT_att@long_name     = "Argo Salinity Monthly Mean"
    SALT_att@missing_value = -999.0

    PTEMP_att               = True
    PTEMP_att@units         = "degC"
    PTEMP_att@title         = "Argo Potential Temperature Monthly Mean"
    PTEMP_att@long_name     = "Argo Potential Temperature Monthly Mean"
    PTEMP_att@missing_value = -999.0

    PDEN_att               = True
    PDEN_att@units         = "kg/m3"
    PDEN_att@title         = "Argo Potential Density Monthly Mean"
    PDEN_att@long_name     = "Argo Potential Density Monthly Mean"
    PDEN_att@missing_value = -999.0

    ADDEP_att               = True
    ADDEP_att@units         = "dynamic meters"
    ADDEP_att@title         = "Argo-Aviso Absolute Dynamic Depth Monthly Mean"
    ADDEP_att@long_name     = "Argo-Aviso Absolute Dynamic Depth Monthly Mean"
    ADDEP_att@missing_value = -999.0

    SPICE_att               = True
    SPICE_att@units         = "unity"
    SPICE_att@title         = "Argo Spiciness Monthly Mean"
    SPICE_att@long_name     = "Argo Spiciness Monthly Mean"
    SPICE_att@missing_value = -999.0

    VAR_3D_ATT_NM_ARGO = (/TEMP_att, SALT_att, PTEMP_att, PDEN_att, ADDEP_att, SPICE_att/)

    cnt_time = 84  ; 0
;   do i_yr = 2005, 2013
    do i_yr = 2012, 2013
        do i_mon = 1, 12
            str_date   = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon)
            print("current month: " + str_date + ", cnt_time = " + cnt_time)

            fn_nc_soda = "argo2soda_" + str_date + ".nc"

            ; create and define SODA reanalysis file
            system("rm " + DIR_ROOT_ARGO_OUTPUT + "/argo2soda_interp_v50/" + fn_nc_soda)
            fl_nc_soda = addfile(DIR_ROOT_ARGO_OUTPUT + "/argo2soda_interp_v50/" + fn_nc_soda, "c")
     
            ; define file (global) attributes)
            global_att = True
            global_att@description = "ARGO data 2005-2013 interpolated to SODA grid."
            fileattdef(fl_nc_soda, global_att)

            ; define file dimensions
            dim_names = (/"DEPTH"       , "LAT"     , "LON"     /)
;           dim_sizes = (/N_DEP_SODA    , N_LAT_SODA, N_LON_SODA/)
            dim_sizes = (/N_DEP_SODA_v50, N_LAT_SODA, N_LON_SODA/)
            dim_unlim = (/False         , False     , False     /)
            filedimdef(fl_nc_soda, dim_names, dim_sizes, dim_unlim)

            ; copy dimension vars directly from old SODA file, no need to define.
            fl_nc_soda->LON   = fl_nc_soda_grid->LON
            fl_nc_soda->LAT   = fl_nc_soda_grid->LAT     
;           fl_nc_soda->DEPTH = fl_nc_soda_grid->DEPTH
            fl_nc_soda->DEPTH = (/fl_nc_mom5_grid->st_ocean/)

            ; define file vars with their dims and attributes
            filevardef(fl_nc_soda, VAR_3D_NM_ARGO, (/"float", "float", "float", "float", "float", "float"/), (/"DEPTH", "LAT", "LON"/))

            filevarattdef(fl_nc_soda, "TEMP" , TEMP_att )
            filevarattdef(fl_nc_soda, "SALT" , SALT_att )
            filevarattdef(fl_nc_soda, "PTEMP", PTEMP_att)
            filevarattdef(fl_nc_soda, "PDEN" , PDEN_att )
            filevarattdef(fl_nc_soda, "ADDEP", ADDEP_att)
            filevarattdef(fl_nc_soda, "SPICE", SPICE_att)
            do i_var =0, N_VAR_3D - 1
                fl_nc_soda->$VAR_3D_NM_ARGO(i_var)$@_FillValue = -999.0
            end do

            do i_var_3d = 0, N_VAR_3D - 1
                print("i_var_3d = " + i_var_3d)

                var_3d_argo     = fl_nc_argo->$VAR_3D_NM_ARGO(i_var_3d)$(cnt_time, :, :, :)
                print("Running linint2 ...")
                var_3d_soda_tmp = linint2(lon_argo, lat_argo, var_3d_argo, True, lon_soda, lat_soda, 0)
                print("Running linint1_n ...")
;               var_3d_soda     = linint1_n(dep_argo, var_3d_soda_tmp, False, dep_soda    , 0, 0)
                var_3d_soda_v50 = linint1_n(dep_argo, var_3d_soda_tmp, False, dep_soda_v50, 0, 0)

                print("Writing out ...")
                fl_nc_soda->$VAR_3D_NM_ARGO(i_var_3d)$ = var_3d_soda_v50
            end do 

            cnt_time = cnt_time + 1

            if (i_yr .eq. 2013 .and. i_mon .eq. 6) then
                exit()
            end if 
        end do  ; end of "do i_mon = 1, 12"
    end do      ; end of "do i_yr = 2011, 2013"

end
