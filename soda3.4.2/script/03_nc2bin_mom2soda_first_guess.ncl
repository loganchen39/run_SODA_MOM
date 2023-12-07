load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

;   DIR_MOM2SODA = getenv("DIR_ROOT_RUN_SODA")
;   DIR_MOM2SODA = "/glade/scratch/lgchen/project/soda3.4.2/SODA"
;   DIR_MOM2SODA = "/glade/scratch/lgchen/project/soda3.4.2/2018/SODA"
    DIR_MOM2SODA = "/glade/scratch/lgchen/project/soda3.4.2/2019/SODA"
    print("DIR_MOM2SODA = " + DIR_MOM2SODA)

;   str_time = getenv("STR_CURR_CYCLE")
    print(str_time)

    fn_nc = str_time + ".regrid_MOM2SODA.nc"
    fl_nc = addfile(DIR_MOM2SODA + "/" + fn_nc, "r")

    fn_bin  = str_time + ".first_guess.dat"
    command = "rm -f " + DIR_MOM2SODA + "/" + fn_bin
    system(command)

    ; process (mask) the corrector data and then write it out

    sea_level = fl_nc->sea_level(0, :, :)
    sea_level = where(abs(sea_level) .gt. 1000.0 .or. ismissing(sea_level), 0.0, sea_level)
    ; write out first record of surface 
    fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(sea_level(:, :)))

    temp = fl_nc->temp(:, :, :, :)
    salt = fl_nc->salt(:, :, :, :)

;   temp = where(abs(temp) .gt. 5000.0 .or. ismissing(temp), 0.0, temp)
;   salt = where(abs(salt) .gt. 5000.0 .or. ismissing(salt), 0.0, salt)

    ; write out 50 vertical records of temperature
    do i_v_level = 0, 49
        fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(temp(0, i_v_level, :, :)))
    end do

    ; write out 50 vertical records of salinity
    do i_v_level = 0, 49
        fbindirwrite(DIR_MOM2SODA + "/" + fn_bin, doubletofloat(salt(0, i_v_level, :, :)))
    end do

    system("exit 0")
end
