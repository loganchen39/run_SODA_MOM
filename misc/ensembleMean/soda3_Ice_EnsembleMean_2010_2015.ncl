; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    DIR_ROOT_SODA    = "/aosc/greenland"
    DIR_EM_SODA      = "/aosc/greenland/cera20c_runs/soda3"
    DIR_EM_SODA_TEMP = "/aosc/greenland/cera20c_runs/soda3/ice_temp_2010_2015"

    str_cdo         = "cdo selname,hi,hs "
    str_cdo_sum_cn  = "cdo -b F64 expr,'sic=cn1+cn2+cn3+cn4+cn5;' "
    str_cdo_merge   = "cdo merge "  ; ice_temp_merge332.nc

    str_cdo_ensmean = "cdo ensmean " + DIR_EM_SODA_TEMP + "/ice_merge_temp332.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp342.nc "    \
                    + DIR_EM_SODA_TEMP + "/ice_merge_temp372.nc " + DIR_EM_SODA_TEMP  \ 
                    + "/ice_merge_temp3112.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp3122.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp_mean_0.nc"

    str_nco_hi2sit  = "ncrename -v hi,sit " + DIR_EM_SODA_TEMP + "/ice_merge_temp_mean_0.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp_mean.nc"

    str_cdo_setpartabn = "cdo setpartabn," + DIR_EM_SODA_TEMP + "/mean-partabn.txt,convert " + DIR_EM_SODA_TEMP  \
                       + "/ice_merge_temp_mean.nc " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc"


    str_cdo_ensstd1 = "cdo ensstd  " + DIR_EM_SODA_TEMP + "/ice_merge_temp332.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp342.nc "    \
                    + DIR_EM_SODA_TEMP + "/ice_merge_temp372.nc " + DIR_EM_SODA_TEMP  \
                    + "/ice_merge_temp3112.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp3122.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp_std_0.nc"

    str_nco_hi2sit_std = "ncrename -v hi,sit " + DIR_EM_SODA_TEMP + "/ice_merge_temp_std_0.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp_std.nc"

    str_cdo_setpartabn_std = "cdo setpartabn," + DIR_EM_SODA_TEMP + "/std-partabn.txt,convert " + DIR_EM_SODA_TEMP  \
                        + "/ice_merge_temp_std.nc " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"

    str_nco_chn_FV_sit      = "ncatted -a _FillValue,sit,m,d,-1e+34     " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc"   
    str_nco_chn_FV_hs       = "ncatted -a _FillValue,hs,m,d,-1e+34      " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc"   
    str_nco_chn_FV_sic      = "ncatted -a _FillValue,sic,m,d,-1e+34     " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc"   
    str_nco_chn_FV_sit_std  = "ncatted -a _FillValue,sit_std,m,d,-1e+34 " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"   
    str_nco_chn_FV_hs_std   = "ncatted -a _FillValue,hs_std,m,d,-1e+34  " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"   
    str_nco_chn_FV_sic_std  = "ncatted -a _FillValue,sic_std,m,d,-1e+34 " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"   

    str_nco_chn_mv_sit      = "ncatted -a missing_value,sit,m,d,-1e+34     " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc"   
    str_nco_chn_mv_hs       = "ncatted -a missing_value,hs,m,d,-1e+34      " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc"   
    str_nco_chn_mv_sic      = "ncatted -a missing_value,sic,m,d,-1e+34     " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc"   
    str_nco_chn_mv_sit_std  = "ncatted -a missing_value,sit_std,m,d,-1e+34 " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"   
    str_nco_chn_mv_hs_std   = "ncatted -a missing_value,hs_std,m,d,-1e+34  " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"   
    str_nco_chn_mv_sic_std  = "ncatted -a missing_value,sic_std,m,d,-1e+34 " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"   

    str_cdo_merge_pref  = "cdo merge " + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc " + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc "  \
                        + DIR_EM_SODA + "/REGRIDED/ice_2010_2015/"

    str_cdo_chn_global_title_pref = "ncatted -a title,global,m,c,'soda3 ensemble mean and standard deviation (N)' "  \
                                  + DIR_EM_SODA + "/REGRIDED/ice_2010_2015/"
  ; str_cdo_chn_global_filename_pref = "ncatted -a filename,global,m,c,'' "
    str_cdo_chn_global_history_pref = "ncatted -O -h -a history,global,m,c,'combines up to six soda3 ensemble members obtained from http://www.soda.umd.edu using cdo routines: ensmean and ensstd by L. Chen 1-8-2019' "  \
                                    + DIR_EM_SODA + "/REGRIDED/ice_2010_2015/"


  ; str_rm = "rm "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_temp332.nc           " + DIR_EM_SODA_TEMP + "/ice_temp342.nc          "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_temp361.nc           " + DIR_EM_SODA_TEMP + "/ice_temp372.nc          "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_temp3112.nc          " + DIR_EM_SODA_TEMP + "/ice_temp3122.nc         "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp332.nc    " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp342.nc   "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp361.nc    " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp372.nc   "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3112.nc   " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3122.nc  "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_merge_temp332.nc     " + DIR_EM_SODA_TEMP + "/ice_merge_temp342.nc    "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_merge_temp361.nc     " + DIR_EM_SODA_TEMP + "/ice_merge_temp372.nc    "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_merge_temp3112.nc    " + DIR_EM_SODA_TEMP + "/ice_merge_temp3122.nc   "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_merge_temp_mean_0.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp_mean.nc  "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_temp_mean_cor.nc     "                                                   \
  ;        + DIR_EM_SODA_TEMP + "/ice_merge_temp_std.nc    " + DIR_EM_SODA_TEMP + "/ice_merge_temp_std_0.nc "  \
  ;        + DIR_EM_SODA_TEMP + "/ice_temp_std_cor.nc"

    str_rm = "rm " + DIR_EM_SODA_TEMP + "/*.nc"

    fn_pre_332  = "soda3.3.2_5dy_ice_reg_"
    fn_pre_342  = "soda3.4.2_5dy_ice_reg_"
  ; fn_pre_361  = "soda3.6.1_5dy_ice_reg_"
    fn_pre_372  = "soda3.7.2_5dy_ice_reg_"
    fn_pre_3112 = "soda3.11.2_5dy_ice_reg_"
    fn_pre_3122 = "soda3.12.2_5dy_ice_reg_"

    ; six reanalysis for 19800101-20091224
    jul_day_20100103 = greg2jul(2010, 1 , 3 , -1)
    jul_day_20151213 = greg2jul(2015, 12, 13, -1)

    i_jul_day = jul_day_20100103

    do while (i_jul_day .le. jul_day_20151213)
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

        fn_332  = fn_pre_332  + str_fn_cycle + ".nc"
        fn_342  = fn_pre_342  + str_fn_cycle + ".nc"
        fn_372  = fn_pre_372  + str_fn_cycle + ".nc"
        fn_3112 = fn_pre_3112 + str_fn_cycle + ".nc"
        fn_3122 = fn_pre_3122 + str_fn_cycle + ".nc"

        ; selname
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.3.2/REGRIDED/ice/"  + fn_332  + " " + DIR_EM_SODA_TEMP + "/ice_temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.4.2/REGRIDED/ice/"  + fn_342  + " " + DIR_EM_SODA_TEMP + "/ice_temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.7.2/REGRIDED/ice/"  + fn_372  + " " + DIR_EM_SODA_TEMP + "/ice_temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.11.2/REGRIDED/ice/" + fn_3112 + " " + DIR_EM_SODA_TEMP + "/ice_temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.12.2/REGRIDED/ice/" + fn_3122 + " " + DIR_EM_SODA_TEMP + "/ice_temp3122.nc"
        system(str_cmd)

        ; sum_cn
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.3.2/REGRIDED/ice/"  + fn_332  + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.4.2/REGRIDED/ice/"  + fn_342  + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.7.2/REGRIDED/ice/"  + fn_372  + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.11.2/REGRIDED/ice/" + fn_3112 + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.12.2/REGRIDED/ice/" + fn_3122 + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3122.nc"
        system(str_cmd)       

        ; merge selname and sum_cn
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp332.nc  " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp332.nc  " + DIR_EM_SODA_TEMP + "/ice_merge_temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp342.nc  " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp342.nc  " + DIR_EM_SODA_TEMP + "/ice_merge_temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp372.nc  " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp372.nc  " + DIR_EM_SODA_TEMP + "/ice_merge_temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp3112.nc " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3112.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp3122.nc " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3122.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp3122.nc"
        system(str_cmd)       


        ; compute the ensemble mean
        system(str_cdo_ensmean)

        ; rename hi2sit
        system(str_nco_hi2sit)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn)

        ; compute the ensemble standard deviation
        system(str_cdo_ensstd1)

        ; rename hi2sit
        system(str_nco_hi2sit_std)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn_std)

        ; change _FillValue and missing_value
        system(str_nco_chn_FV_sit    )
        system(str_nco_chn_FV_hs     )
        system(str_nco_chn_FV_sic    )
        system(str_nco_chn_FV_sit_std)
        system(str_nco_chn_FV_hs_std )
        system(str_nco_chn_FV_sic_std)

        system(str_nco_chn_mv_sit    )
        system(str_nco_chn_mv_hs     )
        system(str_nco_chn_mv_sic    )
        system(str_nco_chn_mv_sit_std)
        system(str_nco_chn_mv_hs_std )
        system(str_nco_chn_mv_sic_std)

        
        ; merge the files
        fn_soda3 = "soda3_5dy_ice_reg_" + str_fn_cycle + ".nc"
        str_cdo_merge_cor = str_cdo_merge_pref + fn_soda3
        system(str_cdo_merge_cor)

        ; change global attributes
        str_cdo_chn_global_attr = str_cdo_chn_global_title_pref + fn_soda3
        system(str_cdo_chn_global_attr)
        str_cdo_chn_global_attr = "ncatted -a filename,global,m,c," + fn_soda3 + " " + DIR_EM_SODA + "/REGRIDED/ice_2010_2015/" + fn_soda3
        system(str_cdo_chn_global_attr)
        str_cdo_chn_global_attr = str_cdo_chn_global_history_pref + fn_soda3
        system(str_cdo_chn_global_attr)

        ; cleanup the temporary files
        system(str_rm)




        greg  = jul2greg(i_jul_day + 7)
        i_yr  = greg(0)
        i_mon = greg(1)
        i_day = greg(2)
        str_fn_cycle = sprinti("%0.4i", i_yr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)

        fn_332  = fn_pre_332  + str_fn_cycle + ".nc"
        fn_342  = fn_pre_342  + str_fn_cycle + ".nc"
        fn_372  = fn_pre_372  + str_fn_cycle + ".nc"
        fn_3112 = fn_pre_3112 + str_fn_cycle + ".nc"
        fn_3122 = fn_pre_3122 + str_fn_cycle + ".nc"

        ; selname
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.3.2/REGRIDED/ice/"  + fn_332  + " " + DIR_EM_SODA_TEMP + "/ice_temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.4.2/REGRIDED/ice/"  + fn_342  + " " + DIR_EM_SODA_TEMP + "/ice_temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.7.2/REGRIDED/ice/"  + fn_372  + " " + DIR_EM_SODA_TEMP + "/ice_temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.11.2/REGRIDED/ice/" + fn_3112 + " " + DIR_EM_SODA_TEMP + "/ice_temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.12.2/REGRIDED/ice/" + fn_3122 + " " + DIR_EM_SODA_TEMP + "/ice_temp3122.nc"
        system(str_cmd)

        ; sum_cn
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.3.2/REGRIDED/ice/"  + fn_332  + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.4.2/REGRIDED/ice/"  + fn_342  + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.7.2/REGRIDED/ice/"  + fn_372  + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.11.2/REGRIDED/ice/" + fn_3112 + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo_sum_cn + DIR_ROOT_SODA + "/soda3.12.2/REGRIDED/ice/" + fn_3122 + " " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3122.nc"
        system(str_cmd)

        ; merge selname and sum_cn
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp332.nc  " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp332.nc  " + DIR_EM_SODA_TEMP + "/ice_merge_temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp342.nc  " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp342.nc  " + DIR_EM_SODA_TEMP + "/ice_merge_temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp372.nc  " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp372.nc  " + DIR_EM_SODA_TEMP + "/ice_merge_temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp3112.nc " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3112.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo_merge + DIR_EM_SODA_TEMP + "/ice_temp3122.nc " + DIR_EM_SODA_TEMP + "/ice_sum_cn_temp3122.nc " + DIR_EM_SODA_TEMP + "/ice_merge_temp3122.nc"
        system(str_cmd)

        ; compute the ensemble mean
        system(str_cdo_ensmean)

        ; rename hi2sit
        system(str_nco_hi2sit)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn)

        ; compute the ensemble standard deviation
        system(str_cdo_ensstd1)

        ; rename hi2sit
        system(str_nco_hi2sit_std)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn_std)
 
        ; change _FillValue and missing_value
        system(str_nco_chn_FV_sit    )
        system(str_nco_chn_FV_hs     )
        system(str_nco_chn_FV_sic    )
        system(str_nco_chn_FV_sit_std)
        system(str_nco_chn_FV_hs_std )
        system(str_nco_chn_FV_sic_std)

        system(str_nco_chn_mv_sit    )
        system(str_nco_chn_mv_hs     )
        system(str_nco_chn_mv_sic    )
        system(str_nco_chn_mv_sit_std)
        system(str_nco_chn_mv_hs_std )
        system(str_nco_chn_mv_sic_std)


        ; merge the files
        fn_soda3 = "soda3_5dy_ice_reg_" + str_fn_cycle + ".nc"
        str_cdo_merge_cor = str_cdo_merge_pref + fn_soda3
        system(str_cdo_merge_cor)

        ; change global attributes
        str_cdo_chn_global_attr = str_cdo_chn_global_title_pref + fn_soda3
        system(str_cdo_chn_global_attr)
        str_cdo_chn_global_attr = "ncatted -a filename,global,m,c," + fn_soda3 + " " + DIR_EM_SODA + "/REGRIDED/ice_2010_2015/" + fn_soda3
        system(str_cdo_chn_global_attr)
        str_cdo_chn_global_attr = str_cdo_chn_global_history_pref + fn_soda3
        system(str_cdo_chn_global_attr)

        ; cleanup the temporary files
        system(str_rm)


        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
