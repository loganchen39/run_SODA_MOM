load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")


    DIR_ROOT_MOM_SODA = "/glade/scratch/lgchen/project/MOM_run/SODA_1979_2014/test2_Gena_restart/MOM_SODA"

    FN_NC_SODA_GRID = "/glade/p/work/lgchen/data/SODA/SODA_2.2.4_201012.cdf"
    FN_NC_MOM_GRID  = DIR_ROOT_MOM_SODA + "/19790101/history/19790101.ice.nc"
    FN_NC_topog     = "/glade/p/work/lgchen/data/MOM5/INPUT/topog.nc"

    N_LON_SODA = 720
    N_LAT_SODA = 330
    N_DEP_SODA = 5
    N_TIME     = 2

    N_LON_MOM = 1440
    N_LAT_MOM = 1070
    N_DEP_MOM = 5 
    N_TIME    = 2

    lon_soda = new((/N_LON_SODA/), "double", -1.0e20)
    lat_soda = new((/N_LAT_SODA/), "double", -1.0e20)
    dep_soda = new((/N_DEP_SODA/), "double", -1.0e20)

    lon_t_mom = new((/N_LAT_MOM, N_LON_MOM/), "double", -1.0e20)
    lat_t_mom = new((/N_LAT_MOM, N_LON_MOM/), "double", -1.0e20)
    dep_t_mom = new((/N_DEP_MOM/), "double", -1.0e20)


    fl_nc_soda_grid = addfile(FN_NC_SODA_GRID, "r")
    lon_soda        = fl_nc_soda_grid->LON   ; 0.25, 0.75, ..., 359.25, 359.75; 
    lon_soda        = lon_soda - 280.0       ; -279.75, ..., 79.75; 
  ; print(lon_soda)
    lat_soda        = fl_nc_soda_grid->LAT    ; -75.25, -74.75, ..., 88.75, 89.25;

    fl_nc_mom_grid = addfile(FN_NC_MOM_GRID, "r")
    fl_nc_topog    = addfile(FN_NC_topog   , "r")
    lon_t_mom      = fl_nc_topog->x_T
    lat_t_mom      = fl_nc_topog->y_T
    dep_t_mom      = fl_nc_mom_grid->ct 


    VAR_3D_NM_SODA = (/"cn"/)
    VAR_3D_NM_MOM  = (/"cn"/)

    VAR_2D_NM_SODA = (/"hi", "hs", "mi"/)
    VAR_2D_NM_MOM  = (/"hi", "hs", "mi"/)

    N_VAR_3D       = dimsizes(VAR_3D_NM_SODA)
    N_VAR_2D       = dimsizes(VAR_2D_NM_SODA)

    var_3d_mom      = new((/N_TIME, N_DEP_MOM , N_LAT_MOM , N_LON_MOM /), "float", -1.0e20)
    var_3d_soda_tmp = new((/N_TIME, N_DEP_MOM , N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)
    var_3d_soda_rot = new((/N_TIME, N_DEP_SODA, N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)
    var_3d_soda     = new((/N_TIME, N_DEP_SODA, N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)

    var_2d_mom      = new((/N_TIME,             N_LAT_MOM , N_LON_MOM /), "float", -1.0e20)
    var_2d_soda_rot = new((/N_TIME,             N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)
    var_2d_soda     = new((/N_TIME,             N_LAT_SODA, N_LON_SODA/), "float", -1.0e20)


    cn_att               = True
    cn_att@long_name     = "ice concentration"
    cn_att@units         = "0-1"
  ; cn_att@missing_value = -1.e+34 
  ; cn_att@_FillValue    = -1.e+34 
    cn_att@cell_methods  = "time: mean"
    cn_att@time_avg_info = "average_T1,average_T2,average_DT"

    hi_att               = True
    hi_att@long_name     = "ice thickness"
    hi_att@units         = "m-ice"
  ; hi_att@missing_value = -1.e+34 
  ; hi_att@_FillValue    = -1.e+34 
    hi_att@cell_methods  = "time: mean"
    hi_att@time_avg_info = "average_T1,average_T2,average_DT"

    hs_att               = True
    hs_att@long_name     = "snow thickness"
    hs_att@units         = "m-snow"
  ; hs_att@missing_value = -1.e+34 
  ; hs_att@_FillValue    = -1.e+34 
    hs_att@cell_methods  = "time: mean"
    hs_att@time_avg_info = "average_T1,average_T2,average_DT"

    mi_att               = True
    mi_att@long_name     = "ice mass"
    mi_att@units         = "kg/m^2"
  ; mi_att@missing_value = -1.e+34 
  ; mi_att@_FillValue    = -1.e+34 
    mi_att@cell_method   = "time: mean"
    mi_att@time_avg_info = "average_T1,average_T2,average_DT"


    jul_day_19790101 = greg2jul(1979, 1 , 1 , -1)
    jul_day_19861230 = greg2jul(1986, 12, 30, -1)

    i_jul_day = jul_day_19790101

    do while(i_jul_day .lt. jul_day_19861230)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)

        fn_nc_mom  = str_curr_cycle + ".ice.nc"
        fn_nc_soda = "SODA_ice_3.0_" + str_curr_cycle + ".nc"

        ; mom file
        fl_nc_mom = addfile(DIR_ROOT_MOM_SODA + "/" + str_curr_cycle + "/history/" + fn_nc_mom, "r")


        ; create and define SODA ice reanalysis file
        system("rm " + DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/with_NCL_rcm2rgrid_ice/" + fn_nc_soda)
        fl_nc_soda = addfile(DIR_ROOT_MOM_SODA + "/MOM2SODA_interp/with_NCL_rcm2rgrid_ice/" + fn_nc_soda, "c")
     
        global_att = True
        global_att@description = "SODA ice reanalysis generated with MOM5"
        fileattdef(fl_nc_soda, global_att)

        ; define file dimensions
        dim_names = (/"time", "ct"      , "yt"      , "xt"      /)
        dim_sizes = (/N_TIME, N_DEP_SODA, N_LAT_SODA, N_LON_SODA/)
        dim_unlim = (/True  , False     , False     , False     /)
        filedimdef(fl_nc_soda, dim_names, dim_sizes, dim_unlim)

        ; copy dimension vars directly from old SODA file, no need to define.
        fl_nc_soda->time       = fl_nc_mom->time
        fl_nc_soda->ct         = fl_nc_mom->ct
        fl_nc_soda->yt         = fl_nc_soda_grid->LAT     
        fl_nc_soda->xt         = fl_nc_soda_grid->LON

        ; define file vars with their dims and attributes
        filevardef(fl_nc_soda, "cn"  , "float", (/"time", "ct", "yt", "xt"/))
        filevardef(fl_nc_soda, (/"hi", "hs", "mi"/), (/"float", "float", "float"/), (/"time", "yt", "xt"/))


        cn_att@history = "From " + str_curr_cycle + ".ice.nc"
        filevarattdef(fl_nc_soda, "cn", cn_att)
        fl_nc_soda->cn@_FillValue   = -1.e+34
        fl_nc_soda->cn@missingvalue = -1.e+34

        hi_att@history = "From " + str_curr_cycle + ".ice.nc"
        filevarattdef(fl_nc_soda, "hi", hi_att)
        fl_nc_soda->hi@_FillValue   = -1.e+34
        fl_nc_soda->hi@missingvalue = -1.e+34

        hs_att@history = "From " + str_curr_cycle + ".ice.nc"
        filevarattdef(fl_nc_soda, "hs", hs_att)
        fl_nc_soda->hs@_FillValue   = -1.e+34
        fl_nc_soda->hs@missingvalue = -1.e+34

        mi_att@history = "From " + str_curr_cycle + ".ice.nc"
        filevarattdef(fl_nc_soda, "mi", mi_att)
        fl_nc_soda->mi@_FillValue   = -1.e+34
        fl_nc_soda->mi@missingvalue = -1.e+34
       

        do i_var_3d = 0, N_VAR_3D - 1
            print("i_var_3d = " + i_var_3d)

            var_3d_mom               = fl_nc_mom->$VAR_3D_NM_MOM(i_var_3d)$(:, :, :, :)
            print("Running rcm2rgrid ...")
          ; var_3d_soda_tmp          = linint2  (lon_t_mom, lat_t_mom, var_3d_mom, True, lon_soda, lat_soda, 0)
            var_3d_soda_tmp          = rcm2rgrid(lat_t_mom, lon_t_mom, var_3d_mom,       lat_soda, lon_soda, 1)
            ; no rotation
            fl_nc_soda->$VAR_3D_NM_SODA(i_var_3d)$ = var_3d_soda_tmp
        end do 


        do i_var_2d = 0, N_VAR_2D - 1
            print("i_var_2d = " + i_var_2d)

            var_2d_mom      = fl_nc_mom->$VAR_2D_NM_MOM(i_var_2d)$(:, :, :)
          ; var_2d_soda_rot = linint2  (lon_t_mom, lat_t_mom, var_2d_mom, True, lon_soda, lat_soda, 0)
            var_2d_soda_rot = rcm2rgrid(lat_t_mom, lon_t_mom, var_2d_mom,       lat_soda, lon_soda, 1)

            ; no rotation
            fl_nc_soda->$VAR_2D_NM_SODA(i_var_2d)$ = var_2d_soda_rot
        end do 

        exit()
    end do      ; end of "do while(i_jul_day .lt. jul_day_19861230)"

end
