load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "BigEndian")
  ; setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA    = "/glade/p/work/lgchen/data/SODA/OBS4SODA/BIN"
    DIR_DATA_NC = "/glade/p/umcp0006/lgchen/data/OBS4SODA_ascii2nc"

  ; N_DAY_MAX = (365/5)*(1978-1970+1)  ; 657
  ; N_DAY_MAX = (365/5)*(1979-1970+1)  ; 730
    N_DAY_MAX = (365/5)*(2014-2009+2)
    ; will have "fatal:New: could not create new array:[errno=12]", too large
  ; N_DAY_MAX = (365/5)*(2014-1970+1)  ; 3285,
    N_LAT     = 180
    N_LON     = 360
    N_DEP     = 34

    jul_day = new((/N_DAY_MAX/), "integer", -999)
    depth   = new((/N_DEP/), "float", -1.0e20)
    lat     = new((/N_LAT/), "float", -1.0e20)
    lon     = new((/N_LON/), "float", -1.0e20)
    jul_day = jul_day@_FillValue
    depth   = depth@_FillValue
    lat     = lat@_FillValue
    lon     = lon@_FillValue

    temp    = new((/N_DAY_MAX, N_DEP, N_LAT, N_LON/), "float"  , -999.990)
    n_depth = new((/N_DAY_MAX,        N_LAT, N_LON/), "integer", -999  )
    temp    = temp@_FillValue
    n_depth = n_depth@_FillValue


    TEMP_att               = True
    TEMP_att@units         = "degC"
    TEMP_att@title         = "observational 3D temperature for SODA"
    TEMP_att@long_name     = "observational 3D temperature for SODA"
    TEMP_att@missing_value = -999.990
  ; TEMP_att@_FillValue    = -999.990

    N_DEPTH_att               = True
    N_DEPTH_att@units         = "depth level"
    N_DEPTH_att@title         = "deepest level below which no observation data."
    N_DEPTH_att@long_name     = "deepest level below which no observation data."
    N_DEPTH_att@missing_value = -999
  ; N_DEPTH_att@_FillValue    = -999


  ; VAR_3D_ATT_NM_ARGO = (/TEMP_att, SALT_att, PTEMP_att, PDEN_att, ADDEP_att, SPICE_att/)


    ; set up dep, lat & lon
    depth = (/5.03354978561401, 15.1006498336792, 25.2193508148193,  \
              35.3584518432617, 45.5763511657715, 55.8532485961914,  \
              66.2617492675781, 76.802848815918 , 87.5769500732422,  \
              98.6232528686523, 110.096153259277, 122.106651306152,  \
              134.908554077148, 148.746643066406, 164.053756713867,  \
              181.312454223633, 201.262954711914, 224.777252197266,  \
              253.068145751953, 287.550842285156, 330.007751464844,  \
              382.365051269531, 446.726348876953, 524.982421875   ,  \
              618.703125      , 728.692077636719, 854.993530273438,  \
              996.715270996094, 1152.37609863281, 1319.99670410156,  \
              1497.56188964844, 1683.05725097656, 1874.78820800781,  \
              2071.251953125  /)
    lat = fspan(-89.5, 89.5, 180)
  ; print(lat)
    lon = fspan(1.0, 360.0, 360)
  ; print(lon)


    curr_dep_temp = new((/N_DEP/), "float", -999.990)
    str_delim     = " "
    prev_jul_day  = -999
    cnt_jul_day   = -999

    do i_yr = 2009, 2014 
        str_yr     = sprinti("%0.4i", i_yr)
        print("i_yr = " + str_yr)

        fn         = "t_" + str_yr + ".bin"
        str_fl     = asciiread(DIR_DATA + "/" + fn, -1, "string")
        dim_str_fl = dimsizes(str_fl)
        print("dim_str_fl = " + sprinti("%0.8i", dim_str_fl))

        do i_ln = 0, dim_str_fl - 1
            n_fields = str_fields_count(str_fl(i_ln), str_delim)
            if (n_fields .le. 4) then
                print("ERROR: n_fields .le. 4, i_yr = " + str_yr + ", i_ln = " + sprinti("%0.8i", i_ln))
                exit()
            end if

            curr_jul_day = stringtointeger(str_get_field(str_fl(i_ln), 1, str_delim))
            curr_lat     = stringtofloat  (str_get_field(str_fl(i_ln), 2, str_delim))
            curr_lon     = stringtofloat  (str_get_field(str_fl(i_ln), 3, str_delim))
            curr_n_depth = stringtointeger(str_get_field(str_fl(i_ln), 4, str_delim))
            do i_dep = 0, curr_n_depth - 1
                curr_dep_temp(i_dep) = stringtofloat(str_get_field(str_fl(i_ln), 5+i_dep, str_delim))
            end do

            if (prev_jul_day .eq. -999) then  ; the very begining
                prev_jul_day = curr_jul_day
                cnt_jul_day  = 0
            else if (curr_jul_day .lt. prev_jul_day) then
                print("ERROR: curr_jul_day .lt. prev_jul_day, i_yr = " + str_yr + ", i_ln = " + sprinti("%0.8i", i_ln))
                exit()
            else if (curr_jul_day .gt. prev_jul_day) then  ; a new julian day started
                prev_jul_day = curr_jul_day
                cnt_jul_day  = cnt_jul_day + 1
            else  ; curr_jul_day .eq. prev_jul_day, do nothing

            end if
            end if
            end if

            i_lat = floattointeger(curr_lat + 89.5 + 0.2)  ; 0.2 is used to avoid the floating-point error
            i_lon = floattointeger(curr_lon - 1.0 + 0.2)
            jul_day(cnt_jul_day)                                 = curr_jul_day
            n_depth(cnt_jul_day,                   i_lat, i_lon) = curr_n_depth
            temp   (cnt_jul_day, 0:curr_n_depth-1, i_lat, i_lon) = curr_dep_temp(0:curr_n_depth-1)
        end do

        delete(str_fl)
    end do

    print(cnt_jul_day)


    fn_nc_temp_obs = "t_2009_2014.nc"
    fl_nc_temp_obs = addfile(DIR_DATA_NC + "/" + fn_nc_temp_obs, "c")
    
    ; define file (global) attributes)
    global_att = True
    global_att@description = "observational temperature from ascii to netCDF."
    fileattdef(fl_nc_temp_obs, global_att)

    ; define file dimensions
    dim_names = (/"time"       , "depth", "lat", "lon"/)
    dim_sizes = (/cnt_jul_day+1, N_DEP  , N_LAT, N_LON/)
    dim_unlim = (/True         , False  , False, False/)
    filedimdef(fl_nc_temp_obs, dim_names, dim_sizes, dim_unlim)

    ; define file dimension vars with their dims and attributes
    filevardef(fl_nc_temp_obs, "time" , "integer", (/"time" /))
    filevardef(fl_nc_temp_obs, "depth", "float"  , (/"depth"/))
    filevardef(fl_nc_temp_obs, "lat"  , "float"  , (/"lat"  /))
    filevardef(fl_nc_temp_obs, "lon"  , "float"  , (/"lon"  /))

    ; copy dimension vars directly from old SODA file, no need to define.
    fl_nc_temp_obs->time  = jul_day(0:cnt_jul_day)
    fl_nc_temp_obs->depth = depth
    fl_nc_temp_obs->lat   = lat
    fl_nc_temp_obs->lon   = lon

    ; define and assign file variables
    filevardef(fl_nc_temp_obs, "temp"   , "float", (/"time", "depth", "lat", "lon"/))
    filevardef(fl_nc_temp_obs, "n_depth", "float", (/"time",          "lat", "lon"/))

    filevarattdef(fl_nc_temp_obs, "temp"   , TEMP_att   )
    filevarattdef(fl_nc_temp_obs, "n_depth", N_DEPTH_att)

    fl_nc_temp_obs->temp    = temp   (0:cnt_jul_day, :, :, :)
    fl_nc_temp_obs->n_depth = n_depth(0:cnt_jul_day,    :, :)

    fl_nc_temp_obs->temp@_FillValue    = -999.990
    fl_nc_temp_obs->n_depth@_FillValue = -999
end
