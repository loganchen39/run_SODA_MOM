; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    DIR_ROOT_SODA    = "/aosc/greenland"
    DIR_EM_SODA      = "/aosc/greenland/cera20c_runs/soda3"
    DIR_EM_SODA_TEMP = "/aosc/greenland/cera20c_runs/soda3/temp_2010_2015"

    str_cdo         = "cdo selname,temp,salt,wt,ssh,mlt,mlp,mls,hflux_total,prho,u,v,taux,tauy "

    str_cdo_ensmean = "cdo ensmean " + DIR_EM_SODA_TEMP + "/temp332.nc " + DIR_EM_SODA_TEMP + "/temp342.nc "    \
                    + DIR_EM_SODA_TEMP + "/temp372.nc " + DIR_EM_SODA_TEMP  \ 
                    + "/temp3112.nc " + DIR_EM_SODA_TEMP + "/temp3122.nc " + DIR_EM_SODA_TEMP + "/temp_mean.nc"
    str_cdo_setpartabn = "cdo setpartabn," + DIR_EM_SODA_TEMP + "/mean-partabn.txt,convert " + DIR_EM_SODA_TEMP  \
                       + "/temp_mean.nc " + DIR_EM_SODA_TEMP + "/temp_mean_cor.nc"

    str_cdo_ensstd1 = "cdo ensstd  " + DIR_EM_SODA_TEMP + "/temp332.nc " + DIR_EM_SODA_TEMP + "/temp342.nc "    \
                    + DIR_EM_SODA_TEMP + "/temp372.nc " + DIR_EM_SODA_TEMP  \
                    + "/temp3112.nc " + DIR_EM_SODA_TEMP + "/temp3122.nc " + DIR_EM_SODA_TEMP + "/temp_std.nc"
    str_cdo_setpartabn2 = "cdo setpartabn," + DIR_EM_SODA_TEMP + "/std-partabn.txt,convert " + DIR_EM_SODA_TEMP  \
                        + "/temp_std.nc " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"

    str_cdo_del_stdnm_t_std    = "ncatted -a standard_name,t_std,d,c,''    " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"
    str_cdo_del_stdnm_s_std    = "ncatted -a standard_name,s_std,d,c,''    " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"
    str_cdo_del_stdnm_ssh_std  = "ncatted -a standard_name,ssh_std,d,c,''  " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"
    str_cdo_del_stdnm_prho_std = "ncatted -a standard_name,prho_std,d,c,'' " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"
    str_cdo_del_stdnm_u_std    = "ncatted -a standard_name,u_std,d,c,''    " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"
    str_cdo_del_stdnm_v_std    = "ncatted -a standard_name,v_std,d,c,''    " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"
    str_cdo_del_stdnm_taux_std = "ncatted -a standard_name,taux_std,d,c,'' " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"
    str_cdo_del_stdnm_tauy_std = "ncatted -a standard_name,tauy_std,d,c,'' " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"    

    str_cdo_merge_pref  = "cdo merge " + DIR_EM_SODA_TEMP + "/temp_mean_cor.nc " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc "  \
                        + DIR_EM_SODA + "/REGRIDED/ocean_2010_2015/"

    str_cdo_chn_global_title_pref = "ncatted -a title,global,m,c,'soda3 ensemble mean and standard deviation (N)' "  \
                                  + DIR_EM_SODA + "/REGRIDED/ocean_2010_2015/"
  ; str_cdo_chn_global_filename_pref = "ncatted -a filename,global,m,c,'' "
    str_cdo_chn_global_history_pref = "ncatted -O -h -a history,global,m,c,'combines up to six soda3 ensemble members obtained from http://www.soda.umd.edu using cdo routines: ensmean and ensstd by L. Chen 1-8-2019' "  \
                                    + DIR_EM_SODA + "/REGRIDED/ocean_2010_2015/"

    str_rm = "rm " + DIR_EM_SODA_TEMP + "/temp332.nc " + DIR_EM_SODA_TEMP + "/temp342.nc "    \
           + DIR_EM_SODA_TEMP + "/temp372.nc " + DIR_EM_SODA_TEMP   \ 
           + "/temp3112.nc " + DIR_EM_SODA_TEMP + "/temp3122.nc "  \
           + DIR_EM_SODA_TEMP + "/temp_mean.nc " + DIR_EM_SODA_TEMP + "/temp_mean_cor.nc " + DIR_EM_SODA_TEMP  \
           + "/temp_std.nc " + DIR_EM_SODA_TEMP + "/temp_std_cor.nc"

    fn_pre_332  = "soda3.3.2_5dy_ocean_reg_"
    fn_pre_342  = "soda3.4.2_5dy_ocean_reg_"
    fn_pre_372  = "soda3.7.2_5dy_ocean_reg_"
    fn_pre_3112 = "soda3.11.2_5dy_ocean_reg_"
    fn_pre_3122 = "soda3.12.2_5dy_ocean_reg_"

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


        ; ocean
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
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.3.2/REGRIDED/ocean/" + fn_332   + " " + DIR_EM_SODA_TEMP + "/temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.4.2/REGRIDED/ocean/" + fn_342   + " " + DIR_EM_SODA_TEMP + "/temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.7.2/REGRIDED/ocean/" + fn_372   + " " + DIR_EM_SODA_TEMP + "/temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.11.2/REGRIDED/ocean/" + fn_3112 + " " + DIR_EM_SODA_TEMP + "/temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.12.2/REGRIDED/ocean/" + fn_3122 + " " + DIR_EM_SODA_TEMP + "/temp3122.nc"
        system(str_cmd)

        ; compute the ensemble mean
        system(str_cdo_ensmean)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn)

        ; compute the ensemble standard deviation
        system(str_cdo_ensstd1)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn2)

        ; delete standard_name attributes with some std variables
        system(str_cdo_del_stdnm_t_std   )
        system(str_cdo_del_stdnm_s_std   )
        system(str_cdo_del_stdnm_ssh_std )
        system(str_cdo_del_stdnm_prho_std)
        system(str_cdo_del_stdnm_u_std   )
        system(str_cdo_del_stdnm_v_std   )
        system(str_cdo_del_stdnm_taux_std)
        system(str_cdo_del_stdnm_tauy_std)
        
        ; merge the files
        fn_soda3 = "soda3_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        str_cdo_merge = str_cdo_merge_pref + fn_soda3
        system(str_cdo_merge)

        ; change global attributes
        str_cdo_chn_global_attr = str_cdo_chn_global_title_pref + fn_soda3
        system(str_cdo_chn_global_attr)
        str_cdo_chn_global_attr = "ncatted -a filename,global,m,c," + fn_soda3 + " " + DIR_EM_SODA + "/REGRIDED/ocean_2010_2015/" + fn_soda3
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
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.3.2/REGRIDED/ocean/" + fn_332   + " " + DIR_EM_SODA_TEMP + "/temp332.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.4.2/REGRIDED/ocean/" + fn_342   + " " + DIR_EM_SODA_TEMP + "/temp342.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.7.2/REGRIDED/ocean/" + fn_372   + " " + DIR_EM_SODA_TEMP + "/temp372.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.11.2/REGRIDED/ocean/" + fn_3112 + " " + DIR_EM_SODA_TEMP + "/temp3112.nc"
        system(str_cmd)
        str_cmd = str_cdo + DIR_ROOT_SODA + "/soda3.12.2/REGRIDED/ocean/" + fn_3122 + " " + DIR_EM_SODA_TEMP + "/temp3122.nc"
        system(str_cmd)

        ; compute the ensemble mean
        system(str_cdo_ensmean)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn)

        ; compute the ensemble standard deviation
        system(str_cdo_ensstd1)

        ; fix the parameter table (including names)
        system(str_cdo_setpartabn2)

        ; delete standard_name attributes with some std variables
        system(str_cdo_del_stdnm_t_std   )
        system(str_cdo_del_stdnm_s_std   )
        system(str_cdo_del_stdnm_ssh_std )
        system(str_cdo_del_stdnm_prho_std)
        system(str_cdo_del_stdnm_u_std   )
        system(str_cdo_del_stdnm_v_std   )
        system(str_cdo_del_stdnm_taux_std)
        system(str_cdo_del_stdnm_tauy_std)
        
        ; merge the files
        fn_soda3 = "soda3_5dy_ocean_reg_" + str_fn_cycle + ".nc"
        str_cdo_merge = str_cdo_merge_pref + fn_soda3
        system(str_cdo_merge)
 
        ; change global attributes
        str_cdo_chn_global_attr = str_cdo_chn_global_title_pref + fn_soda3
        system(str_cdo_chn_global_attr)
        str_cdo_chn_global_attr = "ncatted -a filename,global,m,c," + fn_soda3 + " " + DIR_EM_SODA + "/REGRIDED/ocean_2010_2015/" + fn_soda3
        system(str_cdo_chn_global_attr)
        str_cdo_chn_global_attr = str_cdo_chn_global_history_pref + fn_soda3
        system(str_cdo_chn_global_attr)       

        ; cleanup the temporary files
        system(str_rm)


        i_jul_day = i_jul_day + 10
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
