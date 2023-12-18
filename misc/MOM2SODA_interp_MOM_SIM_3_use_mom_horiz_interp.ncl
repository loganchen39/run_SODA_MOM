load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

    DIR_CODE_MOM_REGRID = "/glade/u/home/lgchen/project/mom_Gena/src/postprocessing/regrid/workdir/MOM_SIM_3_ocean_avg"
    DIR_ROOT_MOM_SODA   = "/glade/scratch/lgchen/project/MOM_run/MOM_SIM_3/MOM_org"

    START_YEAR = 2014
    END_YEAR   = 2014

    i_yr = START_YEAR

    do while (i_yr .le. END_YEAR)
        print("i_yr = " + sprinti("%0.4i", i_yr))

        str_dir_mom_data = DIR_ROOT_MOM_SODA + "/" + sprinti("%0.4i", i_yr) + "/history"
        str_fn_prefix    = sprinti("%0.4i", i_yr) + "0101"

        jul_day = greg2jul(i_yr, 1 , 3 , -1)

        i_jul_day = jul_day
        do while (i_jul_day .le. i_jul_day + 364)
            greg  = jul2greg(i_jul_day)
            i_yr_curr = greg(0)
            i_mon     = greg(1)
            i_day     = greg(2)

            if (i_yr_curr .ne. i_yr) then
                print ("i_yr_curr .ne. i_yr")

                break
            end if

            str_fn_cycle = sprinti("%0.4i", i_yr_curr) + "_" + sprinti("%0.2i", i_mon) + "_" + sprinti("%0.2i", i_day)

            str_fn_ocean = str_fn_prefix + ".ocean_5dy_" + str_fn_cycle + ".nc"

            ; do horizontal interpolation with MOM postprocessing regrid tool
            ; ocean
            system("ln -sf " + str_dir_mom_data + "/" + str_fn_ocean + " ./MOM.ocean.nc")
            system("rm fms." + str_fn_cycle + ".out")
            system("mpirun.lsf regrid.exe >&! fms." + str_fn_cycle + ".out")

            str_fn_soda = "ocean_5dy_" + str_fn_cycle + ".nc"
            system("mv -f " + DIR_CODE_MOM_REGRID + "/regrid_MOM2SODA.nc " + DIR_ROOT_MOM_SODA   \   
                + "/MOM2SODA_interp/with_MOM_regrid_5days/" + str_fn_soda)

            i_jul_day = i_jul_day + 5
        end do

        i_yr = i_yr + 1
    end do  ; end of "do while (i_jul_day .le. jul_day_19811216)"

end
