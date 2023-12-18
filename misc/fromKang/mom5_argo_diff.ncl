load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin
    DIR_DATA_ARGO = "/glade/scratch/lgchen/data/argo_from_jim/argo2soda_interp_v50"
    DIR_DATA_MOM5 = "/glade/scratch/lgchen/project/MOM_run/sim_2001_2013_gena"

    COMPUTE_MONTH_AVG = True 
    COMPUTE_DELTA     = False

    N_DEPTH = 50
    N_LAT   = 330
    N_LON   = 720

;   VAR_3D_NAME = (/"TEMP", "SALT"/)
    N_VAR_3D    = 2

    MOD_NAME = (/"ARGO", "MOM5"/)
    N_MOD    = 2

    var_3d_avg_2yr   = new((/N_MOD, N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float", -9.99e33)
    var_3d_avg_jul   = new((/N_MOD, N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float", -9.99e33)
    var_3d_avg_dec   = new((/N_MOD, N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float", -9.99e33)
    var_3d_avg_2yr!3 = "lat"
    var_3d_avg_2yr!4 = "lon"
    var_3d_avg_2yr   = 0.0
    var_3d_avg_jul   = 0.0
    var_3d_avg_dec   = 0.0
    
    var_3d_argo = new((/N_DEPTH, N_LAT, N_LON/), "float", -999.)
    var_3d_mom5 = new((/N_DEPTH, N_LAT, N_LON/), "float", -9.99e33)

    var_2d_diff = new((/         N_LAT, N_LON/), "float", -9.99e33)
    var_2d_diff!0 = "lat"
    var_2d_diff!1 = "lon"
    
    fl_nc_argo         = addfile(DIR_DATA_ARGO + "/argo2soda_201201.nc", "r")
    var_2d_diff&lat    = fl_nc_argo->LAT
    var_2d_diff&lon    = fl_nc_argo->LON
    var_3d_avg_2yr&lat = fl_nc_argo->LAT
    var_3d_avg_2yr&lon = fl_nc_argo->LON

    depth = fl_nc_argo->DEPTH

    if (COMPUTE_MONTH_AVG) then
        do i_yr = 2012, 2013
            do i_mon = 1, 12
                str_date = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon)
                print("str_date = " + str_date)

                ; ARGO
                fn_nc_argo = "argo2soda_" + str_date + ".nc"
                fl_nc_argo = addfile(DIR_DATA_ARGO + "/" + fn_nc_argo, "r")

                ; temp
                var_3d_argo = fl_nc_argo->PTEMP
                var_3d_argo = where(ismissing(var_3d_argo), var_3d_avg_2yr@_FillValue, var_3d_argo)
                var_3d_avg_2yr(0, 0, :, :, :) = var_3d_avg_2yr(0, 0, :, :, :) + var_3d_argo
                if (i_mon .eq. 7) then
                    var_3d_avg_jul(0, 0, :, :, :) = var_3d_avg_jul(0, 0, :, :, :) + var_3d_argo
                end if
                if (i_mon .eq. 12) then
                    var_3d_avg_dec(0, 0, :, :, :) = var_3d_avg_dec(0, 0, :, :, :) + var_3d_argo
                end if

                ; salt
                var_3d_argo = fl_nc_argo->SALT 
                var_3d_argo = where(ismissing(var_3d_argo), var_3d_avg_2yr@_FillValue, var_3d_argo)
                var_3d_avg_2yr(0, 1, :, :, :) = var_3d_avg_2yr(0, 1, :, :, :) + var_3d_argo
                if (i_mon .eq. 7) then
                    var_3d_avg_jul(0, 1, :, :, :) = var_3d_avg_jul(0, 1, :, :, :) + var_3d_argo
                end if
                if (i_mon .eq. 12) then
                    var_3d_avg_dec(0, 1, :, :, :) = var_3d_avg_dec(0, 1, :, :, :) + var_3d_argo
                end if
            end do  ; end of "do i_mon = 1, 12"
        end do      ; end of "do i_yr  = 2011, 2012"

        ; MOM5
        do i_yr = 2011, 2012
            str_year   = sprinti("%0.4i", i_yr)
            print("str_year = " + str_year)
            fn_nc_mom5 = "mom5_era_i_sim_2soda_" + str_year + ".nc"
            fl_nc_mom5 = addfile(DIR_DATA_MOM5 + "/" + fn_nc_mom5, "r")

            ; temp
;           var_3d_mom5 = fl_nc_mom5->temp
;           var_3d_mom5 = where(ismissing(var_3d_mom5), var_3d_avg_2yr@_FillValue, var_3d_mom5)
            var_3d_avg_2yr(1, 0, :, :, :) = var_3d_avg_2yr(1, 0, :, :, :) + doubletofloat(dim_sum_n(fl_nc_mom5->temp, 0))
            var_3d_avg_jul(1, 0, :, :, :) = var_3d_avg_jul(1, 0, :, :, :) + doubletofloat(fl_nc_mom5->temp(6 , :, :, :))
            var_3d_avg_dec(1, 0, :, :, :) = var_3d_avg_dec(1, 0, :, :, :) + doubletofloat(fl_nc_mom5->temp(11, :, :, :))

            ; salt
;           var_3d_mom5 = fl_nc_mom5->salt 
;           var_3d_mom5 = where(ismissing(var_3d_mom5), var_3d_avg_2yr@_FillValue, var_3d_mom5)
            var_3d_avg_2yr(1, 1, :, :, :) = var_3d_avg_2yr(1, 1, :, :, :) + doubletofloat(dim_sum_n(fl_nc_mom5->salt, 0))
            var_3d_avg_jul(1, 1, :, :, :) = var_3d_avg_jul(1, 1, :, :, :) + doubletofloat(fl_nc_mom5->salt(6 , :, :, :)) 
            var_3d_avg_dec(1, 1, :, :, :) = var_3d_avg_dec(1, 1, :, :, :) + doubletofloat(fl_nc_mom5->salt(11, :, :, :))
        end do  ; end of "do i_yr = 2011, 2012"

        var_3d_avg_2yr = var_3d_avg_2yr / 24.0
        var_3d_avg_jul = var_3d_avg_jul / 2.0
        var_3d_avg_dec = var_3d_avg_dec / 2.0


        ; write out to binary file
        print("Writing out to binary files ...")

        system("rm -f ./tmp_data/mom5_argo_diff_v50/var_3d_avg_2yr.bin")
        system("rm -f ./tmp_data/mom5_argo_diff_v50/var_3d_avg_jul.bin")
        system("rm -f ./tmp_data/mom5_argo_diff_v50/var_3d_avg_dec.bin")

        fbindirwrite("./tmp_data/mom5_argo_diff_v50/var_3d_avg_2yr.bin", var_3d_avg_2yr)
        fbindirwrite("./tmp_data/mom5_argo_diff_v50/var_3d_avg_jul.bin", var_3d_avg_jul)
        fbindirwrite("./tmp_data/mom5_argo_diff_v50/var_3d_avg_dec.bin", var_3d_avg_dec)
    else  ; read from binary data
        print("Reading from binary files ...")

        var_3d_avg_2yr = fbindirread("./tmp_data/mom5_argo_diff_v50/var_3d_avg_2yr.bin", 0, (/N_MOD, N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float")
        var_3d_avg_jul = fbindirread("./tmp_data/mom5_argo_diff_v50/var_3d_avg_jul.bin", 0, (/N_MOD, N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float")
        var_3d_avg_dec = fbindirread("./tmp_data/mom5_argo_diff_v50/var_3d_avg_dec.bin", 0, (/N_MOD, N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float")
    end if


;   ; compute delta
;   var_3d_delta_2yr = new((/N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float", -9.99e33)
;   var_3d_delta_2yr = 0.0

;   if (COMPUTE_DELTA) then
;       print("Computing delta ...")

;       do i_yr = 2012, 2013
;           do i_mon = 1, 12
;               str_date = sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon)
;               print("str_date = " + str_date)

;               ; ARGO
;               fn_nc_argo = "argo2soda_" + str_date + ".nc"
;               fl_nc_argo = addfile(DIR_DATA_ARGO + "/" + fn_nc_argo, "r")

;               ; SODA
;               fn_nc_soda = "SODA_2.2.4_" + str_date + ".cdf"
;               fl_nc_soda = addfile(DIR_DATA_SODA + "/" + fn_nc_soda, "r")

;               ; temp
;               var_3d_argo = fl_nc_argo->PTEMP
;               var_3d_argo = where(ismissing(var_3d_argo), var_3d_delta_2yr@_FillValue, var_3d_argo)

;               var_3d_soda = fl_nc_soda->temp
;               var_3d_soda = where(ismissing(var_3d_soda), var_3d_delta_2yr@_FillValue, var_3d_soda)

;               anomaly_diff = (var_3d_argo - var_3d_avg_2yr(0, 0, :, :, :)) - (var_3d_soda - var_3d_avg_2yr(1, 0, :, :, :))

;               var_3d_delta_2yr(0, :, :, :) = var_3d_delta_2yr(0, :, :, :) + anomaly_diff * anomaly_diff


;               ; salt
;               var_3d_argo = fl_nc_argo->SALT 
;               var_3d_argo = where(ismissing(var_3d_argo), var_3d_delta_2yr@_FillValue, var_3d_argo)

;               var_3d_soda = fl_nc_soda->salt 
;               var_3d_soda = where(ismissing(var_3d_soda), var_3d_delta_2yr@_FillValue, var_3d_soda)

;               anomaly_diff = (var_3d_argo - var_3d_avg_2yr(0, 1, :, :, :)) - (var_3d_soda - var_3d_avg_2yr(1, 1, :, :, :))

;               var_3d_delta_2yr(1, :, :, :) = var_3d_delta_2yr(1, :, :, :) + anomaly_diff * anomaly_diff
;           end do  ; end of "do i_mon = 1, 12"
;       end do      ; end of "do i_yr  = 2011, 2012"

;       var_3d_delta_2yr = sqrt(var_3d_delta_2yr)

;       ; write out to binary file
;       print("Writing out delta to binary files ...")

;       system("rm -f ./tmp_data/delta.bin")
;       fbindirwrite("./tmp_data/delta.bin", var_3d_delta_2yr)
;   else  ; read
;;      print("Reading delta from binary files ...")

;;      var_3d_delta_2yr = fbindirread("./tmp_data/delta.bin", 0, (/N_VAR_3D, N_DEPTH, N_LAT, N_LON/), "float")
;   end if




    ; plot
    wks  = gsn_open_wks("pdf", "mom5_argo_24mon_avg_diff")
    plot = new(2, graphic)

    gsn_define_colormap(wks, "BlWhRe")
    
    resP = True

    res          = True
    res@gsnDraw  = False
    res@gsnFrame = False   
 
    res@cnFillOn        = True  ; turning on color
    res@gsnSpreadColors = True  ; forces the use of all the colors in a colormap by subsampling across it
    res@mpFillOn        = False

    ; i = NhlNewColor(wks, 0.7, 0.7, 0.7)  ; color the continents gray

    res@mpCenterLonF = 180       ; Centers the plot at 180
    res@gsnAddCyclic = True      ; must be set to False while the range of my longitude is not 360.
;   res@gsnMaximize  = True
    
    res@lbAutoManage      = False
    res@pmLabelBarWidthF  = 0.6  
    res@pmLabelBarHeightF = 0.050
    
    res@lbLabelAutoStride = True  ;automatically pick nice labelar label stride
;   res@lbLabelStrings    = (/"15", " ", "9", " ", "-3" , "-2", "-1", "1", "2", "3", " ", "9", " ", "15"/)
    
    res@cnLinesOn                  = False
    res@cnLineLabelsOn             = True 
    res@cnLineLabelPlacementMode   = "constant"
    res@cnLineLabelBackgroundColor = "transparent"  ; a line, just like the "constant" method
    res@cnLineLabelInterval        = 1

    res@gsnContourZeroLineThicknessF = 2.
    res@gsnContourNegLineDashPattern = 1 

    res@tmXTOn      = False
    res@tmYROn      = False
    res@tmXBMinorOn = False
    res@tmYLMinorOn = False

    res@pmLabelBarOrthogonalPosF = 0.06  ; -0.01  ; 0.01 ; move label bar closer

    res@tmXBMajorLengthF     = 0.005
    res@tmYLMajorLengthF     = 0.005
    res@tmXBLabelFontHeightF = 0.01
    res@tmYLLabelFontHeightF = 0.01

    res@lbLabelFontHeightF = 0.01  ; 0.015

    res@cnLevelSelectionMode = "ManualLevels"

    print("Plotting ...")

    ; 24-month avg diff
    do i_lev = 0, 34  ; N_DEPTH - 1
        print("i_lev = " + i_lev)

        res@cnMinLevelValF  = -3.
        res@cnMaxLevelValF  = 3.
        res@cnLevelSpacingF = 0.25

        res@gsnLeftString   = "24mon"
        res@gsnCenterString = "MOM5 - ARGO temp(degC, top) & salt(psu, bot)"
        res@gsnRightString  = "depth: " + sprintf("%7.2f", depth(i_lev)) + "m"

        var_2d_diff = var_3d_avg_2yr(1, 0, i_lev, :, :) - var_3d_avg_2yr(0, 0, i_lev, :, :)
        plot(0) = gsn_csm_contour_map(wks, var_2d_diff, res)


        res@cnMinLevelValF  = -2.
        res@cnMaxLevelValF  = 2.
        res@cnLevelSpacingF = 0.25

        res@gsnLeftString   = ""
        res@gsnCenterString = ""
        res@gsnRightString  = ""

        var_2d_diff = var_3d_avg_2yr(1, 1, i_lev, :, :) - var_3d_avg_2yr(0, 1, i_lev, :, :)
        plot(1) = gsn_csm_contour_map(wks, var_2d_diff, res)

        gsn_panel(wks, plot, (/2, 1/), resP)
    end do


;   ; 24-month avg
;   do i_lev = 0, 26  ; N_DEPTH - 1
;       print("i_lev = " + i_lev)

;       res@cnMinLevelValF  = 0.
;       res@cnMaxLevelValF  = 30.
;       res@cnLevelSpacingF = 1.0 

;       res@gsnLeftString   = "24mon temp avg"
;       res@gsnCenterString = "SODA (top), ARGO (bot) temp(degC)"
;       res@gsnRightString  = "depth: " + sprintf("%7.2f", depth(i_lev)) + "m"
;       plot(0) = gsn_csm_contour_map(wks, var_3d_avg_2yr(1, 0, i_lev, :, :), res)

;       res@gsnLeftString   = ""
;       res@gsnCenterString = ""
;       res@gsnRightString  = ""
;       plot(1) = gsn_csm_contour_map(wks, var_3d_avg_2yr(0, 0, i_lev, :, :), res)

;       gsn_panel(wks, plot, (/2, 1/), resP)


;       res@cnMinLevelValF  = 30.
;       res@cnMaxLevelValF  = 38.
;       res@cnLevelSpacingF = 0.25 

;       res@gsnLeftString   = "24mon salt avg"
;       res@gsnCenterString = "SODA (top), ARGO (bot) salt(psu)"
;       res@gsnRightString  = "depth: " + sprintf("%7.2f", depth(i_lev)) + "m"
;       plot(0) = gsn_csm_contour_map(wks, var_3d_avg_2yr(1, 1, i_lev, :, :), res)

;       res@gsnLeftString   = ""
;       res@gsnCenterString = ""
;       res@gsnRightString  = ""
;       plot(1) = gsn_csm_contour_map(wks, var_3d_avg_2yr(0, 1, i_lev, :, :), res)

;       gsn_panel(wks, plot, (/2, 1/), resP)
;   end do


;   ; jul avg diff
;   do i_lev = 0, 26  ; N_DEPTH - 1
;       print("i_lev = " + i_lev)

;       res@cnMinLevelValF  = -3.
;       res@cnMaxLevelValF  = 3.
;       res@cnLevelSpacingF = 0.25

;       res@gsnLeftString   = "Jul."
;       res@gsnCenterString = "SODA - ARGO temp(degC, top) & salt(psu, bot)"
;       res@gsnRightString  = "depth: " + sprintf("%7.2f", depth(i_lev)) + "m"

;       var_2d_diff = var_3d_avg_jul(1, 0, i_lev, :, :) - var_3d_avg_jul(0, 0, i_lev, :, :)
;       plot(0) = gsn_csm_contour_map(wks, var_2d_diff, res)


;       res@cnMinLevelValF  = -2.
;       res@cnMaxLevelValF  = 2.
;       res@cnLevelSpacingF = 0.25

;       res@gsnLeftString   = ""
;       res@gsnCenterString = ""
;       res@gsnRightString  = ""

;       var_2d_diff = var_3d_avg_jul(1, 1, i_lev, :, :) - var_3d_avg_jul(0, 1, i_lev, :, :)
;       plot(1) = gsn_csm_contour_map(wks, var_2d_diff, res)

;       gsn_panel(wks, plot, (/2, 1/), resP)
;   end do


;   ; dec avg diff
;   do i_lev = 0, 26  ; N_DEPTH - 1
;       print("i_lev = " + i_lev)

;       res@cnMinLevelValF  = -3.
;       res@cnMaxLevelValF  = 3.
;       res@cnLevelSpacingF = 0.25

;       res@gsnLeftString   = "Dec."
;       res@gsnCenterString = "SODA - ARGO temp(degC, top) & salt(psu, bot)"
;       res@gsnRightString  = "depth: " + sprintf("%7.2f", depth(i_lev)) + "m"

;       var_2d_diff = var_3d_avg_dec(1, 0, i_lev, :, :) - var_3d_avg_dec(0, 0, i_lev, :, :)
;       plot(0) = gsn_csm_contour_map(wks, var_2d_diff, res)


;       res@cnMinLevelValF  = -2.
;       res@cnMaxLevelValF  = 2.
;       res@cnLevelSpacingF = 0.25

;       res@gsnLeftString   = ""
;       res@gsnCenterString = ""
;       res@gsnRightString  = ""

;       var_2d_diff = var_3d_avg_dec(1, 1, i_lev, :, :) - var_3d_avg_dec(0, 1, i_lev, :, :)
;       plot(1) = gsn_csm_contour_map(wks, var_2d_diff, res)

;       gsn_panel(wks, plot, (/2, 1/), resP)
;   end do


;   ; delta
;   do i_lev = 0, 26  ; N_DEPTH - 1
;       print("i_lev = " + i_lev)

;       res@cnMinLevelValF  = 0.
;       res@cnMaxLevelValF  = 5.
;       res@cnLevelSpacingF = 0.25

;       res@gsnLeftString   = "24mon"
;       res@gsnCenterString = "Delta temp(degC, top) & salt(psu, bot)"
;       res@gsnRightString  = "depth: " + sprintf("%7.2f", depth(i_lev)) + "m"

;       var_2d_diff = (/var_3d_delta_2yr(0, i_lev, :, :)/)
;       plot(0) = gsn_csm_contour_map(wks, var_2d_diff, res)


;       res@cnMinLevelValF  = 0.
;       res@cnMaxLevelValF  = 5.
;       res@cnLevelSpacingF = 0.25

;       res@gsnLeftString   = ""
;       res@gsnCenterString = ""
;       res@gsnRightString  = ""

;       var_2d_diff = (/var_3d_delta_2yr(1, i_lev, :, :)/)
;       plot(1) = gsn_csm_contour_map(wks, var_2d_diff, res)

;       gsn_panel(wks, plot, (/2, 1/), resP)
;   end do
end
