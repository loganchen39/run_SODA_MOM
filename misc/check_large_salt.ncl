load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin
    DIR_ROOT_MOM_SODA = "/glade/scratch/lgchen/project/MOM_run/SODA_1979_2014/test2_Gena_restart/MOM_SODA"

    N_DEPTH = 50
    N_LAT   = 1070
    N_LON   = 1440

    n_abn_v_level = new((/N_DEPTH/), "float", -1e+20)
    n_abn_v_level = 0.0

    fl_nc = addfile(DIR_ROOT_MOM_SODA + "/20021206/RESTART/ocean_temp_salt.res.nc", "r")
    salt = fl_nc->salt

  ; do i_lev = 0, N_DEPTH - 1
  ;     n_abn_v_level(i_lev) = num(salt(0, i_lev, :, :) .gt. 40)
  ; end do
  ; print(n_abn_v_level)

    do i_lev = 0, 17  ; N_DEPTH - 1
        salt_1d     = ndtooned(salt(0, i_lev, :, :))
        ind_salt_40 = ind(salt_1d .gt. 40.0)
        ind_reg     = ind_resolve(ind_salt_40, (/N_LAT, N_LON/))
        dim_ind_reg = dimsizes(ind_reg)

        print("i_lev = " + i_lev + ", n_abn = " + dim_ind_reg(0))
      ; print(ind_reg)

        do i_abn = 0, dim_ind_reg(0) - 1
          ; print("y = " + ind_reg(i_abn, 0) + ", x = " + ind_reg(i_abn, 1) + ", lat = "  \
          ;     + fl_nc->yaxis_1(ind_reg(i_abn, 0)) + ", lon = " + fl_nc->xaxis_1(ind_reg(i_abn, 1)))
            print("y = " + ind_reg(i_abn, 0) + ", x = " + ind_reg(i_abn, 1))
        end do

        delete(ind_salt_40)
        delete(ind_reg)

      ; exit()
    end do
end
