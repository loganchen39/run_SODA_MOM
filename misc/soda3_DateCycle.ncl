; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    DIR_ROOT_SODA    = "/aosc/greenland"
    DIR_EM_SODA      = "/aosc/greenland/cera20c_runs/soda3"
    DIR_EM_SODA_TEMP = "/aosc/greenland/cera20c_runs/soda3/temp"

    ; six reanalysis for 19800101-20091224
    jul_day_19800101 = greg2jul(1980, 1 , 1 , -1)
    jul_day_20161231 = greg2jul(2016, 12, 31, -1)

    i_jul_day = jul_day_19800101

    do while (i_jul_day .le. jul_day_20161231)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)


        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
