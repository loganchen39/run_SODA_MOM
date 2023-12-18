load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_MOM2SODA = "/glade/p/work/lgchen/data/SODA_MOM/regrid_mom2soda_firstGuess/case1_20050101_10/land_zero"

    fl_nc = addfile(DIR_MOM2SODA + "/regrid_mom2soda_firstGuess_set_land_zero.nc", "r")

    do i_time = 0, 1
        print("i_time = " + i_time)
        fn_bin = "first_guess_" + sprinti("%0.2i", i_time+1) + ".dat"

        ; write out first record of surface 
        fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(fl_nc->sea_level(i_time, :, :)))
        
        ; write out 50 vertical records of temperature
        do i_v_level = 0, 49
            fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(fl_nc->temp(i_time, i_v_level, :, :)))
        end do

        ; write out 50 vertical records of salinity
        do i_v_level = 0, 49
            fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(fl_nc->salt(i_time, i_v_level, :, :)))
        end do
    end do
end
