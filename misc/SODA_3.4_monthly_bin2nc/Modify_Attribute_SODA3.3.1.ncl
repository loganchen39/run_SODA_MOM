load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT     = "/glade/p/umcp0006/SODA_338"
    DIR_DATA_REGRIDED = DIR_DATA_ROOT + "/REGRIDED"
    DIR_DATA_REGRIDED = "/glade/scratch/lgchen/project/SODA_3.3.9/test"


    jul_day_19800101 = greg2jul(1980, 1 , 1 , -1)
    jul_day_19800111 = greg2jul(1980, 1 , 11, -1)
    jul_day_20151225 = greg2jul(2015, 12, 25, -1)

    i_jul_day = jul_day_19800101

    do while (i_jul_day .le. jul_day_19800111)
        greg  = jul2greg(i_jul_day)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)

        str_curr_cycle = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + sprinti("%0.2i", i_day)
        print("str_curr_cycle = " + str_curr_cycle)


;       ; ice  
;       greg  = jul2greg(i_jul_day + 2)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_soda = "soda3.3.1_5dy_ice_reg_" + str_fn_cycle + ".nc"

;       str_cmd = "ncatted -a Title,global,a,c,'SODA3.3.1 ice state' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Institution,global,a,c,'University of Maryland' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Website,global,a,c,'http://www.soda.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Acknowledgement,global,a,c,'The SODA3 project is funded by the US National Science Foundation. Please cite: Carton, Chepurin, and Chen (2017)' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Created_by,global,a,c,'Gennady Chepurin and Ligang Chen' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Creation_date,global,a,c,'October, 2016' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator,global,a,c,'James A. Carton' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator_email,global,a,c,'carton@atmos.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a filename,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a title,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a grid_type,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a grid_tile,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a NCO,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a history,global,d,c,'' -h " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)



;       greg  = jul2greg(i_jul_day + 7)
;       i_yr  = greg(0)
;       i_mon = greg(1)
;       i_day = greg(2)
;       str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
;       fn_nc_soda = "soda3.3.1_5dy_ice_reg_" + str_fn_cycle + ".nc"

;       str_cmd = "ncatted -a Title,global,a,c,'SODA3.3.1 ice state' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Institution,global,a,c,'University of Maryland' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Website,global,a,c,'http://www.soda.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Acknowledgement,global,a,c,'The SODA3 project is funded by the US National Science Foundation. Please cite: Carton, Chepurin, and Chen (2017)' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Created_by,global,a,c,'Gennady Chepurin and Ligang Chen' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Creation_date,global,a,c,'October, 2016' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator,global,a,c,'James A. Carton' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator_email,global,a,c,'carton@atmos.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a filename,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a title,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a grid_type,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a grid_tile,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a NCO,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)

;       str_cmd = "ncatted -a history,global,d,c,'' -h " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
;       system(str_cmd)


      ; ; transport
      ; greg  = jul2greg(i_jul_day + 5)
      ; i_yr  = greg(0)
      ; i_mon = greg(1)
      ; i_day = greg(2)
      ; str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
      ; fn_nc_soda = "soda3.3.1_10dy_transport_or_" + str_fn_cycle + ".nc"

      ; system("mv -f " + DIR_DATA_MOM_SODA + "/" + fn_nc_mom + " " + DIR_DATA_MOM_SODA + "/" + fn_nc_soda)


        ; ocean
        greg  = jul2greg(i_jul_day + 2)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_soda = "soda3.3.1_5dy_ocean_reg_" + str_fn_cycle + ".nc"

        str_cmd = "ncatted -a Title,global,a,c,'SODA3.3.1 ocean state' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Institution,global,a,c,'University of Maryland' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Website,global,a,c,'http://www.soda.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Acknowledgement,global,a,c,'The SODA3 project is funded by the US National Science Foundation. Please cite: Carton, Chepurin, and Chen (2017)' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Created_by,global,a,c,'Gennady Chepurin and Ligang Chen' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Creation_date,global,a,c,'October, 2016' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Principle_investigator,global,a,c,'James A. Carton' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Principle_investigator_email,global,a,c,'carton@atmos.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a filename,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a title,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a grid_type,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a grid_tile,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

      ; str_cmd = "ncatted -a NCO,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
      ; system(str_cmd)

        str_cmd = "ncatted -a history,global,d,c,'' -h " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)


        greg  = jul2greg(i_jul_day + 7)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)
        fn_nc_mom  = "soda3.3.1_5dy_ocean_" + str_fn_cycle + "_reg.nc"
        fn_nc_soda = "soda3.3.1_5dy_ocean_reg_" + str_fn_cycle + ".nc"

        str_cmd = "ncatted -a Title,global,a,c,'SODA3.3.1 ocean state' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Institution,global,a,c,'University of Maryland' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Website,global,a,c,'http://www.soda.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Acknowledgement,global,a,c,'The SODA3 project is funded by the US National Science Foundation. Please cite: Carton, Chepurin, and Chen (2017)' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Created_by,global,a,c,'Gennady Chepurin and Ligang Chen' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Creation_date,global,a,c,'October, 2016' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Principle_investigator,global,a,c,'James A. Carton' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a Principle_investigator_email,global,a,c,'carton@atmos.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a filename,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a title,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a grid_type,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

        str_cmd = "ncatted -a grid_tile,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)

      ; str_cmd = "ncatted -a NCO,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
      ; system(str_cmd)

        str_cmd = "ncatted -a history,global,d,c,'' -h " + DIR_DATA_REGRIDED + "/" + fn_nc_soda
        system(str_cmd)





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
