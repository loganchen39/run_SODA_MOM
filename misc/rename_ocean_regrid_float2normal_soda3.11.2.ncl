load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_MOM_SODA   = "/glade2/scratch2/lgchen/project/soda3.11.2/MOM_SODA/MOM2SODA_interp/ocean/float"


    jul_day_19830316 = greg2jul(1983, 3 , 16, -1)
    jul_day_20030301 = greg2jul(2003, 3 , 1 , -1)
    jul_day_20151225 = greg2jul(2015, 12, 25, -1)

    i_jul_day = jul_day_19830316

    do while (i_jul_day .le. jul_day_20030301)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)


      ; ; ice  
      ; greg  = jul2greg(i_jul_day + 2)
      ; i_yr  = greg(0)
      ; i_mon = greg(1)
      ; i_day = greg(2)
      ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_mom  = "soda3.11.2_5dy_ice_or_" + str_fn_cycle + "_reg.nc"
      ; fn_nc_soda = "soda3.11.2_5dy_ice_reg_" + str_fn_cycle + ".nc"

      ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


      ; greg  = jul2greg(i_jul_day + 7)
      ; i_yr  = greg(0)
      ; i_mon = greg(1)
      ; i_day = greg(2)
      ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_mom  = "soda3.11.2_5dy_ice_or_" + str_fn_cycle + "_reg.nc"
      ; fn_nc_soda = "soda3.11.2_5dy_ice_reg_" + str_fn_cycle + ".nc"

      ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;       ; transport
;       greg  = jul2greg(i_jul_day + 5)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_mom  = str_curr_cycle + ".soda3.7.2_10dy_transport_or_" + str_fn_cycle + ".nc"
;       fn_nc_soda = "soda3.7.2_10dy_transport_or_" + str_fn_cycle + ".nc"

;       system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


        ; ocean
        greg  = jul2greg(i_jul_day + 2)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_mom  = "soda3.11.2_5dy_ocean_reg_" + str_fn_cycle + "_f32.nc"
        fn_nc_soda = "soda3.11.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"

        system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


        greg  = jul2greg(i_jul_day + 7)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_mom  = "soda3.11.2_5dy_ocean_reg_" + str_fn_cycle + "_f32.nc"
        fn_nc_soda = "soda3.11.2_5dy_ocean_reg_" + str_fn_cycle + ".nc"

        system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;     ; ; ssh
;     ; greg  = jul2greg(i_jul_day + 2)
;     ; i_yr  = greg(0)
;     ; i_mon = greg(1)
;     ; i_day = greg(2)
;     ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;     ; fn_nc_mom  = str_curr_cycle + ".soda3.7.2_5dy_ssh_or_" + str_fn_cycle + ".nc"
;     ; fn_nc_soda = "soda3.7.2_5dy_ssh_or_" + str_fn_cycle + ".nc"

;     ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;     ; greg  = jul2greg(i_jul_day + 7)
;     ; i_yr  = greg(0)
;     ; i_mon = greg(1)
;     ; i_day = greg(2)
;     ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;     ; fn_nc_mom  = str_curr_cycle + ".soda3.7.2_5dy_ssh_or_" + str_fn_cycle + ".nc"
;     ; fn_nc_soda = "soda3.7.2_5dy_ssh_or_" + str_fn_cycle + ".nc"

;     ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;     ; ; scalar
;     ; greg  = jul2greg(i_jul_day + 2)
;     ; i_yr  = greg(0)
;     ; i_mon = greg(1)
;     ; i_day = greg(2)
;     ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;     ; fn_nc_mom  = str_curr_cycle + ".scalar_5dy_" + str_fn_cycle + ".nc"
;     ; fn_nc_soda = "scalar_5dy_" + str_fn_cycle + ".nc"

;     ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


;     ; greg  = jul2greg(i_jul_day + 7)
;     ; i_yr  = greg(0)
;     ; i_mon = greg(1)
;     ; i_day = greg(2)
;     ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;     ; fn_nc_mom  = str_curr_cycle + ".scalar_5dy_" + str_fn_cycle + ".nc"
;     ; fn_nc_soda = "scalar_5dy_" + str_fn_cycle + ".nc"

;     ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
