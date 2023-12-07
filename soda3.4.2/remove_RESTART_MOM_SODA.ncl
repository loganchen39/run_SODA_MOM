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

        jul_day_next = i_jul_day + 10
        greg_next    = jul2greg(jul_day_next)
        yr_next      = greg_next(0)
        mon_next     = greg_next(1)
        day_next     = greg_next(2)

        jul_day_next_next = i_jul_day + 20
        greg_next_next    = jul2greg(jul_day_next_next)
        yr_next_next      = greg_next_next(0)
        mon_next_next     = greg_next_next(1)
        day_next_next     = greg_next_next(2)       

        if ((i_mon .eq. 6 .and. mon_next .eq. 6 .and. mon_next_next .eq. 7)  \
            .or. (i_mon .eq. 12 .and. mon_next .eq. 12 .and. mon_next_next .eq. 1)) then
 
        else
            str_cmd = "rm " + DIR_ROOT_MOM_SODA + "/MOM_SODA/" + str_curr_cycle + "/RESTART/*"
            system(str_cmd)
        end if

        i_jul_day        = i_jul_day + 10
    end do
end
