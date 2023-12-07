load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    DIR_ROOT_MOM_SODA = "/glade/scratch/lgchen/project/soda3.4.2/2018/MOM_SODA"

    jul_day_20171222 = greg2jul(2017, 12, 22, -1)
    jul_day_20181217 = greg2jul(2018, 12, 17, -1) 


    i_jul_day = jul_day_20171222

    do while(i_jul_day .le. jul_day_20181217)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)

      ; str_cmd = "ln -sf " + DIR_ROOT_MOM_SODA + "/" + str_curr_cycle + "/history/" + str_curr_cycle + ".5days.nc " + DIR_ROOT_MOM_SODA + "/link_soda_org/"
        str_cmd = "ln -sf " + DIR_ROOT_MOM_SODA + "/" + str_curr_cycle + "/history/* " +  DIR_ROOT_MOM_SODA + "/link_forRegrid/"
        system(str_cmd)

        str_cmd = "ln -sf " + DIR_ROOT_MOM_SODA + "/" + str_curr_cycle + "/history/* " +  DIR_ROOT_MOM_SODA + "/link_forTransfer/"
        system(str_cmd)

        i_jul_day        = i_jul_day + 10
    end do  ; end of "do while(i_jul_day .le. jul_day_20050325)"
end
