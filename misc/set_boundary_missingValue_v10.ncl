load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    fl_u10 = addfile("./cdo_remapbil_drowned_u10_DFS5.2_day_1980-2015.nc", "r")
    fl_v10 = addfile("./cdo_remapbil_drowned_v10_DFS5.2_day_1980-2015.nc", "w")

    i_time = 0

  ; do while(i_time .lt. 13149)
    do while(i_time .lt. 1)
        print("i_time = " + sprinti("%0.6i", i_time))
      ; fl_v10->v10(i_time, :, :) = where(ismissing(fl_u10->u10(i_time, :, :)), fl_v10->v10@missing_value, fl_v10->v10(i_time, :, :))

        do i_lat = 0, 181 - 1
            do i_lon = 0, 360 - 1
                if (ismissing(fl_v10->v10(i_time, i_lat, i_lon)))
                    print("ismissing: i_lat = " + sprinti("%0.5i", i_lat) + ", i_lon = " + sprinti("%0.5i", i_lon))
                end if
            end do
        end do

        i_time = i_time + 1
    end do

end
