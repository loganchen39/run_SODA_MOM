load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    DIR_ROOT_MOM_SODA = "/glade2/scratch2/lgchen/project/soda3.11.1"

    jul_day_20061230 = greg2jul(2006, 12, 30, -1)
    jul_day_20070101 = greg2jul(2007, 1 , 1 , -1)
  ; jul_day_20161231 = greg2jul(2016, 12, 31, -1)
    
    i_jul_day = jul_day_20061230

    do while(i_jul_day .le. jul_day_20070101)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)

        str_cmd = "rm " + DIR_ROOT_MOM_SODA + "/MOM_org/" + str_curr_cycle + "/RESTART/*"
        system(str_cmd)

        i_jul_day        = i_jul_day + 10
    end do
end
