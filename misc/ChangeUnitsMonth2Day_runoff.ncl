load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    fn_nc_runoff = "/glade/scratch/lgchen/tmp/20170109_Gena_UnitMonth2Day/runoff_ext_1948-2016.nc"
    fl_nc_runoff = addfile(fn_nc_runoff, "w")

    jul_day_19480101 = greg2jul(1948, 1 , 1 , -1)

    i_rec = 0
    
    do i_yr = 1948, 2016
        do i_mon = 1, 12
            print("i_yr = " + sprinti("%0.2i", i_yr) + ", i_mon = " + sprinti("%0.2i", i_mon))

            i_jul_day = greg2jul(i_yr, i_mon, 15, -1)
            fl_nc_runoff->time(i_rec) = i_jul_day - jul_day_19480101 + 1
    
            i_rec = i_rec + 1
        end do
    end do

end
