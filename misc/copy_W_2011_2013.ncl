load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    setfileoption("nc", "format", "netcdf4") 

    DIR_ROOT_MOM_SODA = "/glade/scratch/lgchen/project/MOM_run/SODA_Reanalysis_2011_2013/test1/MOM_SODA/MOM2SODA_interp"

    N_LON_SODA = 720
    N_LAT_SODA = 330
    N_DEP_SODA = 40

    do i_yr = 2011, 2013
        do i_mon = 1, 12
            str_date   = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon)
            print("current month: " + str_date)

            fn_nc_soda = "SODA_2.2.4_" + str_date + ".cdf"

            fl_nc_soda = addfile(DIR_ROOT_MOM_SODA + "/result_1/" + fn_nc_soda, "w")
            fl_nc_w    = addfile(DIR_ROOT_MOM_SODA + "/"          + fn_nc_soda, "r")
            fl_nc_soda->W = (/fl_nc_w->W/)
        end do  ; end of "do i_mon = 1, 12"
    end do      ; end of "do i_yr = 2011, 2013"
end
