load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_MOM5   = "/glade/p/work/lgchen/data/MOM5"

    fl_nc_wod13 = addfile(DIR_DATA_MOM5 + "/wod13_with_fill.nc", "w")
    fl_nc_res   = addfile(DIR_DATA_MOM5 + "/RESTART_20110101000000_Gena/ocean_temp_salt.res.nc_org.nc", "r")

    fl_nc_wod13->temp = where(fl_nc_res->temp .eq. 0, 0, fl_nc_wod13->temp)
    fl_nc_wod13->temp = where(fl_nc_res->temp .ne. 0 .and. fl_nc_wod13->temp .eq. 0, fl_nc_res->temp, fl_nc_wod13->temp)
    fl_nc_wod13->salt = where(fl_nc_res->salt .eq. 0, 0, fl_nc_wod13->salt)
    fl_nc_wod13->salt = where(fl_nc_res->salt .ne. 0 .and. fl_nc_wod13->salt .eq. 0, fl_nc_res->salt, fl_nc_wod13->salt)

end
