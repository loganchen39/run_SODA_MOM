load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

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
