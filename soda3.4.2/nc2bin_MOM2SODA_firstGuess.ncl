load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_MOM2SODA = "/glade/scratch/lgchen/project/MOM_run/SODA_Reanalysis_2005_test/temp_corr_only/SODA/regrid_MOM2SODA"

    str_time = getenv("START_YEAR" ) + getenv("START_MONTH") + getenv("START_DAY"  )
    print(str_time)

    fn_nc = str_time + ".regrid_MOM2SODA.nc"
    fl_nc = addfile(DIR_MOM2SODA + "/" + fn_nc, "r")

    fn_bin = str_time + ".first_guess.dat"

    ; process the corrector data and then write it out

    sea_level = fl_nc->sea_level(0, :, :)
    sea_level = where(abs(sea_level) .gt. 1000.0 .or. ismissing(sea_level), 0.0, sea_level)
    ; write out first record of surface 
    fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(fl_nc->sea_level(i_time, :, :)))

    temp = fl_nc->temp(:, :, :, :)
    salt = fl_nc->salt(:, :, :, :)

    temp(0, 27:, :, :) = 0.0
    temp = where(abs(temp) .gt. 500.0 .or. ismissing(temp), 0.0, temp)

    salt = 0.0    

    ; write out 50 vertical records of temperature
    do i_v_level = 0, 49
        fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(temp(0, i_v_level, :, :)))
    end do

    ; write out 50 vertical records of salinity
    do i_v_level = 0, 49
        fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(salt(0, i_v_level, :, :)))
    end do
end
