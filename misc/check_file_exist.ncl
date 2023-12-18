load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"


begin
    DIR_SODA = "/aosc/indian/soda/SODA_3.0/RESTART_WOD13/REGULAR/finished"

    jul_day_19790101 = greg2jul(1979, 1 , 1 , -1)
    jul_day_20001206 = greg2jul(2000, 12, 6 , -1)
    
    i_jul_day = jul_day_19790101
    do while(i_jul_day .le. jul_day_20001206)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
      ; print("str_curr_cycle = " + str_curr_cycle)
        fn_exist_check = DIR_SODA + "/SODA_3.0_ocean_" + str_curr_cycle + ".nc"
        if (.not. isfilepresent(fn_exist_check)) then
            print("ERROR: str_curr_cycle = " + str_curr_cycle + ", file not existed!")
        end if

        i_jul_day = i_jul_day + 10
    end do  ; end of "do while(i_j_day .le. jul_day_20001206)"
end
