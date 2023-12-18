load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_DATA_ROOT     = "/aosc/desert/chepurin/SODA3.3.1"
    DIR_DATA_REGRIDED = DIR_DATA_ROOT + "/REGRIDED"
  ; DIR_DATA_REGRIDED = "/homes/metofac/lchen/tmp/SODA3.3.1_test"

    START_YEAR = 1980
    END_YEAR   = 2015

    i_yr = START_YEAR
    do while (i_yr .le. END_YEAR)
        str_yr = sprinti("%0.4i", i_yr)
        print("str_yr = " + str_yr)
        
;       ; ice
;       fn_mn_ice_reg = "soda3.3.1_mn_ice_reg_" + str_yr + ".nc"
;
;       str_cmd = "ncatted -a Title,global,a,c,'SODA3.3.1 ice state' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Institution,global,a,c,'University of Maryland' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Website,global,a,c,'http://www.soda.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Acknowledgement,global,a,c,'The SODA3 project is funded by the US National Science Foundation. Please cite: Carton, Chepurin, and Chen (2017)' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Created_by,global,a,c,'Gennady Chepurin and Ligang Chen' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Creation_date,global,a,c,'October, 2016' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator,global,a,c,'James A. Carton' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator_email,global,a,c,'carton@atmos.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a description,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a NCO,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a history,global,d,c,'' -h " + DIR_DATA_REGRIDED + "/" + fn_mn_ice_reg
;       system(str_cmd)       


;       ; ocean
;       fn_mn_ocean_reg = "soda3.3.1_mn_ocean_reg_" + str_yr + ".nc"
;
;       str_cmd = "ncatted -a Title,global,a,c,'SODA3.3.1 ocean state' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Institution,global,a,c,'University of Maryland' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Website,global,a,c,'http://www.soda.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Acknowledgement,global,a,c,'The SODA3 project is funded by the US National Science Foundation. Please cite: Carton, Chepurin, and Chen (2017)' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Created_by,global,a,c,'Gennady Chepurin and Ligang Chen' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Creation_date,global,a,c,'October, 2016' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator,global,a,c,'James A. Carton' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a Principle_investigator_email,global,a,c,'carton@atmos.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;       str_cmd = "ncatted -a description,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)

;     ; str_cmd = "ncatted -a NCO,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;     ; system(str_cmd)

;       str_cmd = "ncatted -a history,global,d,c,'' -h " + DIR_DATA_REGRIDED + "/" + fn_mn_ocean_reg
;       system(str_cmd)       


        ; isopycn
        fn_mn_isopycn_reg = "soda3.3.1_mn_isopycn_reg_" + str_yr + ".nc"
 
        str_cmd = "ncatted -a Title,global,a,c,'SODA3.3.1 isopycn state' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a Institution,global,a,c,'University of Maryland' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a Website,global,a,c,'http://www.soda.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a Acknowledgement,global,a,c,'The SODA3 project is funded by the US National Science Foundation. Please cite: Carton, Chepurin, and Chen (2017)' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a Created_by,global,a,c,'Gennady Chepurin and Ligang Chen' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a Creation_date,global,a,c,'October, 2016' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a Principle_investigator,global,a,c,'James A. Carton' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a Principle_investigator_email,global,a,c,'carton@atmos.umd.edu' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a description,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a NCO,global,d,c,'' " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

        str_cmd = "ncatted -a history,global,d,c,'' -h " + DIR_DATA_REGRIDED + "/" + fn_mn_isopycn_reg
        system(str_cmd)

 
        i_yr = i_yr + 1
    end do

end
