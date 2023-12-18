load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"


begin
    DIR_DATA_SODA = "/glade/scratch/lgchen/project/MOM_run/SODA_1979_2014/test2_Gena_restart/SODA/tmp/2002_2007"

    jul_day_20030105 = greg2jul(2003, 1 , 5 , -1)
    jul_day_20071230 = greg2jul(2007, 12, 30, -1)
    
    i_jul_day = jul_day_20030105
    do while(i_jul_day .le. jul_day_20071230)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)

        str_cmd = "ncks -O --mk_rec_dmn time " + DIR_DATA_SODA + "/" + str_curr_cycle + ".regrid_MOM2SODA.nc "  \
            + DIR_DATA_SODA + "/" + str_curr_cycle + ".regrid_MOM2SODA_rec.nc"
        system(str_cmd)

        i_jul_day = i_jul_day + 10
    end do  ; end of "do while(i_j_day .le. jul_day_20071230)"


    do i_yr = 2002, 2007
        str_yr  = sprinti("%0.4i", i_yr)

        str_cmd = "ncrcat -h -O " + DIR_DATA_SODA + "/" + str_yr + "*.regrid_MOM2SODA_rec.nc " + DIR_DATA_SODA + "/" + str_yr + ".regrid_MOM2SODA.nc"
        system(str_cmd)
    end do    
end
