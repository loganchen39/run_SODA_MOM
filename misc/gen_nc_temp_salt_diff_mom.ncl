load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl" 


begin
    fl_nc_withoutSoda = addfile("/glade/p/work/lgchen/project/MOM_test/TEST2/history/00010101.ocean.nc"             , "r")
    fl_nc_withSoda    = addfile("/glade/p/work/lgchen/project/MOM_test/TEST3_SODA_correct/history/00010101.ocean.nc", "r")

    temp_diff = fl_nc_withSoda->temp - fl_nc_withoutSoda->temp
    salt_diff = fl_nc_withSoda->salt - fl_nc_withoutSoda->salt
 
    fl_nc_diff = addfile("./temp_salt_diff.nc", "c")

    nl = integertochar(10)  ; newline character
    
    ; define file (global) attributes
    global_att = True
    global_att@description = "source: MOM5 temp and salt diff between" + nl  \
        + "with and without SODA correction."
    fileattdef(fl_nc_diff, global_att)

    ; define file dimensions
    dim_names = (/"time", "st_ocean", "xt_ocean", "yt_ocean"/)
    dim_sizes = (/2     , 50        , 1440      , 1070      /)  
    dim_unlim = (/True  , False     , False     , False     /)  
    filedimdef(fl_nc_diff, dim_names, dim_sizes, dim_unlim)

    ; define dimension vars
    filevardef(fl_nc_diff, "time"    , "double", (/"time"    /))    
    filevardef(fl_nc_diff, "xt_ocean", "double", (/"xt_ocean"/))    
    filevardef(fl_nc_diff, "yt_ocean", "double", (/"yt_ocean"/))    
    filevardef(fl_nc_diff, "st_ocean", "double", (/"st_ocean"/))    
   
    fl_nc_diff->time     =  fl_nc_withSoda->time
    fl_nc_diff->xt_ocean =  fl_nc_withSoda->xt_ocean
    fl_nc_diff->yt_ocean =  fl_nc_withSoda->yt_ocean
    fl_nc_diff->st_ocean =  fl_nc_withSoda->st_ocean

    ; define file variables with their dimensions and attributes
    filevardef(fl_nc_diff, "temp_diff", "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))    
    filevardef(fl_nc_diff, "salt_diff", "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))    

    temp_diff_att               = True
    temp_diff_att@description   = "SODA generated temperature correctors"
    temp_diff_att@units         = "degrees C"
    temp_diff_att@_FillValue    = -1.e20
    temp_diff_att@missing_value = -1.e20
    
    salt_diff_att               = True
    salt_diff_att@description   = "SODA generated salinity correctors"
    salt_diff_att@units         = "psu"
    salt_diff_att@_FillValue    = -1.e20
    salt_diff_att@missing_value = -1.e20 

    fl_nc_diff->temp_diff(:, :, :, :) = temp_diff
    fl_nc_diff->salt_diff(:, :, :, :) = salt_diff
end

