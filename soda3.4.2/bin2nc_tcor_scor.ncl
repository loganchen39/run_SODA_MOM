load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")
    
    ;DIR_SODA2MOM = "/glade/u/home/chepurin/SODA0/exec"

    nl = integertochar(10)  ; newline character

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; define and write the soda generated correctors result to a new netCDF file
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    ;command         = "rm " + DIR_SODA2MOM + "/correctors.nc"
    command         = "rm ./correctors.nc"
    system(command)
    fl_nc           = addfile("./correctors.nc", "c")
    fl_nc_axis      = addfile("/glade/p/work/lgchen/data/SODA_MOM/regrid_mom2soda_firstGuess/case1_20050101_10/20140917_corr_salt_nan/correctors_per_10days.nc", "r")    
    fl_nc_time_axis = addfile("/glade/p/work/lgchen/data/MOM5/RESTART_20050101000000_Gena/ocean_temp_salt.res.nc", "r")

    ; define file (global) attributes
    global_att = True
    global_att@description = "source: soda generaed correctors result" + nl  \
        + "tcor and scor"
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
   
    fl_nc->time(0)  =  fl_nc_time_axis->Time(0)
    fl_nc->xt_ocean =  fl_nc_axis->xt_ocean
    fl_nc->yt_ocean =  fl_nc_axis->yt_ocean
    fl_nc->st_ocean =  fl_nc_axis->st_ocean

    ; define file variables with their dimensions and attributes
    filevardef(fl_nc, "tcor", "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))    
    filevardef(fl_nc, "scor", "float", (/"time", "st_ocean", "yt_ocean", "xt_ocean"/))    

    tcor_att               = True
    tcor_att@description   = "SODA generated temperature correctors"
    tcor_att@units         = "degrees C"
;   tcor_att@_FillValue    = -1.e20
;   tcor_att@missing_value = -1.e20
    
    scor_att               = True
    scor_att@description   = "SODA generated salinity correctors"
    scor_att@units         = "psu"
;   scor_att@_FillValue    = -1.e20
;   scor_att@missing_value = -1.e20

    filevarattdef(fl_nc, "tcor", tcor_att)
    filevarattdef(fl_nc, "scor", scor_att)

;    tcor = fbindirread(DIR_SODA2MOM + "/correctors.dat", 0, (/50, 180, 360/), "float")
;    scor = fbindirread(DIR_SODA2MOM + "/correctors.dat", 1, (/50, 180, 360/), "float")

    tcor = fbindirread("correctors.dat", 0, (/50, 180, 360/), "float")
    scor = fbindirread("correctors.dat", 1, (/50, 180, 360/), "float")

  ; tcor(34:, :, :) = 0.0  ; previously 27 which corresponds to level 854.994, 28 => 996.715, 34 => 2071.252
  ; scor(34:, :, :) = 0.0
    tcor            = where(abs(tcor) .gt. 5000.0 .or. ismissing(tcor) .or. isnan_ieee(tcor), 0.0, tcor)
    scor            = where(abs(scor) .gt. 5000.0 .or. ismissing(scor) .or. isnan_ieee(scor), 0.0, scor)

    fl_nc->tcor(0, :, :, :) = tcor
    fl_nc->scor(0, :, :, :) = scor

    system("exit 0")
end
   
    
