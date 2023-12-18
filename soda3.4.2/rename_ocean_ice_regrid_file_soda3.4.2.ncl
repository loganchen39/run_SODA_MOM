load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_MOM_SODA   = "/glade/scratch/lgchen/project/soda3.4.2/2018/MOM_SODA/MOM2SODA_interp/ice"

  ; jul_day_19800101 = greg2jul(1980, 1 , 1 , -1)
  ; jul_day_19851220 = greg2jul(1985, 12, 20, -1)

    jul_day_20171222 = greg2jul(2017, 12, 22, -1)
    jul_day_20181217 = greg2jul(2018, 12, 17, -1)

    i_jul_day = jul_day_20171222

    do while (i_jul_day .le. jul_day_20181217)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)


        ; ice  
        greg  = jul2greg(i_jul_day + 2)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_mom  = str_curr_cycle + ".soda3.4.2shrt_5dy_ice_or_" + str_fn_cycle + "_reg.nc"
        fn_nc_mom  = "soda3.4.2_5dy_ice_or_" + str_fn_cycle + "_reg.nc"
        fn_nc_soda = "soda3.4.2_5dy_ice_reg_" + str_fn_cycle + ".nc"

        system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


        greg  = jul2greg(i_jul_day + 7)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_mom  = str_curr_cycle + ".soda3.4.2shrt_5dy_ice_or_" + str_fn_cycle + "_reg.nc"
        fn_nc_mom  = "soda3.4.2_5dy_ice_or_" + str_fn_cycle + "_reg.nc"
        fn_nc_soda = "soda3.4.2_5dy_ice_reg_" + str_fn_cycle + ".nc"

        system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;       ; transport
;       greg  = jul2greg(i_jul_day + 5)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_mom  = str_curr_cycle + ".soda3.4.2shrt_10dy_transport_or_" + str_fn_cycle + ".nc"
;       fn_nc_soda = "soda3.4.2_10dy_transport_or_" + str_fn_cycle + ".nc"

;       system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;       ; ocean
;       greg  = jul2greg(i_jul_day + 2)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_mom  = str_curr_cycle + ".soda3.4.2shrt_5dy_ocean_or_" + str_fn_cycle + ".nc"
;       fn_nc_soda = "soda3.4.2_5dy_ocean_or_" + str_fn_cycle + ".nc"

;       system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;       greg  = jul2greg(i_jul_day + 7)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_mom  = str_curr_cycle + ".soda3.4.2shrt_5dy_ocean_or_" + str_fn_cycle + ".nc"
;       fn_nc_soda = "soda3.4.2_5dy_ocean_or_" + str_fn_cycle + ".nc"

;       system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;       ; ssh
;       greg  = jul2greg(i_jul_day + 2)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_mom  = str_curr_cycle + ".soda3.4.2shrt_5dy_ssh_or_" + str_fn_cycle + ".nc"
;       fn_nc_soda = "soda3.4.2_5dy_ssh_or_" + str_fn_cycle + ".nc"

;       system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;       greg  = jul2greg(i_jul_day + 7)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_mom  = str_curr_cycle + ".soda3.4.2shrt_5dy_ssh_or_" + str_fn_cycle + ".nc"
;       fn_nc_soda = "soda3.4.2_5dy_ssh_or_" + str_fn_cycle + ".nc"

;       system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


      ; ; scalar
      ; greg  = jul2greg(i_jul_day + 2)
      ; i_yr  = greg(0)
      ; i_mon = greg(1)
      ; i_day = greg(2)
      ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_mom  = str_curr_cycle + ".scalar_5dy_" + str_fn_cycle + ".nc"
      ; fn_nc_soda = "scalar_5dy_" + str_fn_cycle + ".nc"

      ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


      ; greg  = jul2greg(i_jul_day + 7)
      ; i_yr  = greg(0)
      ; i_mon = greg(1)
      ; i_day = greg(2)
      ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_mom  = str_curr_cycle + ".scalar_5dy_" + str_fn_cycle + ".nc"
      ; fn_nc_soda = "scalar_5dy_" + str_fn_cycle + ".nc"

      ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
