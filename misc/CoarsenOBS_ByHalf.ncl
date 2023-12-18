load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
  ; setfileoption("bin", "ReadByteOrder" , "LittleEndian")
  ; setfileoption("bin", "WriteByteOrder", "LittleEndian")

  ; setfileoption("nc", "format", "netcdf4")

    DIR_OBS_ORG = "/glade2/h2/umcp0009/OBS4SODA/BIN"
    DIR_OBS_CUT = "/glade2/h2/umcp0009/OBS4SODA/BIN_CutByHalf"

    START_YEAR = 1970
    END_YEAR   = 2016

    ; first salinity
    print("Coarsening salinity ...")
    do i_yr = START_YEAR, END_YEAR
        str_yr = sprinti("%0.4i", i_yr)
        print("i_yr = " + str_yr)

        fn_obs_salt = "s_" + str_yr + ".bin"

        str_obs_salt = asciiread(DIR_OBS_ORG + "/" + fn_obs_salt, -1, "string")
        n_line = dimsizes(str_obs_salt)
        str_obs_salt_cut = str_obs_salt(0:n_line-1:2)
        n_line_cut = dimsizes(str_obs_salt_cut)

      ; print("n_line = " + n_line)
      ; print("n_line_cut = " + n_line_cut)

        fn_obs_salt_cut = "s_" + str_yr + "_cut.bin"
        asciiwrite(DIR_OBS_CUT + "/" + fn_obs_salt_cut, str_obs_salt_cut)

        delete(str_obs_salt)
        delete(str_obs_salt_cut)
    end do


    ; second temperature
    print("Coarsening temprature ...")
    do i_yr = START_YEAR, END_YEAR
        str_yr = sprinti("%0.4i", i_yr)
        print("i_yr = " + str_yr)

        fn_obs_temp = "tpot_" + str_yr + ".bin"

        str_obs_temp = asciiread(DIR_OBS_ORG + "/" + fn_obs_temp, -1, "string")
        n_line = dimsizes(str_obs_temp)
        str_obs_temp_cut = str_obs_temp(0:n_line-1:2)
        n_line_cut = dimsizes(str_obs_temp_cut)

        fn_obs_temp_cut = "tpot_" + str_yr + "_cut.bin"
        asciiwrite(DIR_OBS_CUT + "/" + fn_obs_temp_cut, str_obs_temp_cut)

        delete(str_obs_temp)
        delete(str_obs_temp_cut)
    end do
end
