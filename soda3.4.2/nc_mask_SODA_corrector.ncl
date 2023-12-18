load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    fn_nc_topog = "/glade/p/work/lgchen/data/MOM5/INPUT/topog.nc"
    fn_nc_corr_per_10days =  \
        "/glade/p/work/lgchen/data/SODA_MOM/regrid_mom2soda_firstGuess/case1_20050101_10/20140917_ok/correctors_soda2mom_per_sec_destGrid_mom5_to_soda1x1_rename2tcor_setzero_NCL_failed.nc"

    fl_nc_topog           = addfile(fn_nc_topog, "r")
    fl_nc_corr_per_10days = addfile(fn_nc_corr_per_10days, "rw")

    ; do i_v_lev = 0, 49
    ;     fl_nc_corr_per_10days->tcor(0, i_v_lev, :, :) = where(i_v_lev + 1 .le. fl_nc_topog->num_levels + 1.0e-5  \
    ;         , fl_nc_corr_per_10days->tcor(0, i_v_lev, :, :), 0)
    ;     fl_nc_corr_per_10days->scor(0, i_v_lev, :, :) = where(i_v_lev + 1 .le. fl_nc_topog->num_levels + 1.0e-5  \
    ;         , fl_nc_corr_per_10days->scor(0, i_v_lev, :, :), 0)
    ; end do


    fl_nc_corr_per_10days->tcor = 0.0
    fl_nc_corr_per_10days->scor = 0.0
end
