load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

; load "/glade/u/home/lgchen/lib/NCL/self_defined.ncl"


begin
    FN_GRADS_CTL = "grads.ctl"

    newline = inttochar(10)

    jul_day_19790101 = greg2jul(1979, 1 , 1 , -1)
    jul_day_20121024 = greg2jul(2012, 10, 24, -1)
    
    i_jul_day = jul_day_19790101
    i_time    = 1
    do while(i_jul_day .le. jul_day_20121024)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)

        str_line = "CHSUB " + sprinti("%0.4i", i_time) + " " + sprinti("%0.4i", i_time + 1) + " " + str_curr_cycle
      ; asciiwrite(FN_GRADS_CTL, str_line)
        system("echo " + str_line + " >> " + FN_GRADS_CTL)

        i_time    = i_time + 2
        i_jul_day = i_jul_day + 10
    end do  ; end of "do while(i_j_day .le. jul_day_20121024)"
end
