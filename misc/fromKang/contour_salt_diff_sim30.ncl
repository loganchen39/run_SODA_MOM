load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"


begin

  DIR_DATA = "/glade/p/umcp0006/SIM_30/ORIGINAL"
  fl_nc = addfile(DIR_DATA + "/ocean_5dy_1980_01_03.nc", "r")

  salt_diff = fl_nc->salt(0, 0, :, :) - fl_nc->salt(0, 1, :, :)
  salt_diff!0 = "lat"
  salt_diff!1 = "lon"
  salt_diff&lat = fl_nc->yt_ocean
  salt_diff&lon = fl_nc->xt_ocean


  wks=gsn_open_wks("pdf", "salt_diff")

  setvalues NhlGetWorkspaceObjectId() 
    "wsMaximumSize": 500000000 
  end setvalues 

; choose colormap
; gsn_define_colormap(wks, "nrl_sirkes")     ; for difference
; gsn_define_colormap(wks, "rainbow")        ; normal colormap
  gsn_define_colormap(wks, "BlWhRe")
; gsn_define_colormap(wks, "testcmap")       ; for difference
; gsn_define_colormap(wks, "sunshine_9lev")  ; for positive value, the first color is white 
; gsn_define_colormap(wks, "precip_11lev")   ; for negative value


  t=0

; resources begin
  res = True

; *********** color_related resources **********
  res@cnFillOn        = True  ;turning on color
  res@gsnSpreadColors = True  ;forces the use of all the colors in a colormap by subsampling across it
  ; res@cnFillColors  = (/2,3,4,5,6,7,8,9,10,11,13,14,15,16,17,18,19,20,21,22/) ; choose subset color of current color table
  ; res@lbBoxLinesOn = "False"

; *********** map related resorces *************
  ; res@mpFillColors    = (/-1, -1, 0, -1/)  ; color the continents white
  ; res@mpLandFillColor = "gray"             ; set land to be gray
  res@mpFillOn = False
  ; i = NhlNewColor(wks, 0.7, 0.7, 0.7)    ; color the continents gray
  ; res@mpMinLatF = -20.                    ; set the minimum latitude = -70.
  ; res@mpMaxLatF = 20.                     ; set the maximum latitude = 70.
  ; res@mpMinLonF = 120.                      ; set the minimum latitude = -70.  range(-180,180)
  ; res@mpMaxLonF = 260.                       ; set the maximum latitude = 70.  range(-180,180)
  res@mpCenterLonF = 180                   ; Centers the plot at 180
  ; res@gsnAddCyclic = False  ; must be set to False while the range of my longitude is not 360.
  ; res@gsnMaximize = True


; *******************************************************
; usually for tropical strip plot
; res@tmXBMajorLengthF = 0.014            ; resize tickmark lengths
; res@tmXBMinorLengthF = 0.007
; res@tmYLMajorLengthF = 0.014
; res@tmYLMinorLengthF = 0.007
;
; res@tmXBLabelFontHeightF = 0.014    ; resize tick labels
; res@tmYLLabelFontHeightF = 0.014
; res@tiMainFontHeightF    = 0.022        ; resize title

; res@tmXBMode            = "Explicit"
; res@tmXBValues          = (/14,30,44,59,74,89,105/)
; res@tmXBLabels          = (/"15Jan","01Feb","15Feb","01Mar","15Mar", \
;                             "01Apr","15Apr"/)
; res@tmXBLabelFontHeightF = 0.01

; res@tmYLMode   = "Explicit"                        ; explicit labels
; res@tmYLValues = ispan(0,11,1)
; res@tmYLLabels = (/"J","F","M","A","M","J","J","A","S","O","N","D"/)
; res@tmYLLabelFontHeightF = 0.01

; res@mpShapeMode  = "FreeAspect"  ;; change aspect ratio of strip plot
; res@vpWidthF      = 0.8
; res@vpHeightF     = 0.4


;*************** contour ********************
;setting contour levels
    ; manually setting contour levels
    ;    res@cnLevelSelectionMode="ManualLevels"
    ;    res@cnMaxLevelValF=0.9
    ;    res@cnMinLevelValF=0.1
    ;    res@cnLevelSpacingF=0.1
    ;explicitly setting contour levels
        ;res@cnLevelSelectionMode="ExplicitLevels"
        ;res@cnLevels=(/-1.0,3.0,6.5/)
        ;res@cnLineThicknessF = 1.
        ;res@cnLineThicknesses =(/1.0,2.0,2.0/)

;************** label bar *************************
  res@lbAutoManage = False
  res@pmLabelBarOrthogonalPosF = 0.1  ; 0.0; -0.07  ; move the labelbar down a bit  
  res@pmLabelBarWidthF=0.6  ; label bar wide
  res@pmLabelBarHeightF=0.050  ; label bar height

;***********************************************************
  ; res@cnFillMode = "RasterFill"  ;usful when getting the error: Workspace reallocation would exceed maximum siz

; res@cnInfoLabelOn  = False              ; turn off cn info label
; res@lbLabelBarOn   = False              ; turn off individual cb's
  res@cnLinesOn      = False              ; turn off contour lines
  res@cnLineLabelsOn = False              ; turn off contour line labels

  res@lbLabelAutoStride = True  ;automatically pick nice labelar label stride
; res@lbLabelStrings    = (/"15"," ","9"," ","-3" ,"-2","-1","1","2","3"," ","9"," ","15"/)

  res@cnLineLabelsOn           = True          ; turn on line labels
  res@cnLineLabelPlacementMode = "constant"      ; can be set to randomized (default), constant, or computed. Note that only the constant method makes the label part of the line so that the line is not drawn through it
  ; res@cnLineLabelBackgroundColor = "white"       ; white bckgrnd around label
  ; res@cnLabelMasking             = True               ; these resources will enable labels to appear as if they are part of
  res@cnLineLabelBackgroundColor = "transparent"  ; a line, just like the "constant" method
  ; res@cnLineDashSegLenF        = 0.18          ; assist in controlling concentration
  res@cnLineLabelInterval        = 2             ; default = 2
  ; res@cnLineLabelDensityF      = 1.5               ; increase the number of line labels/line
  ; res@lbOrientation = "vertical" ; set orientation of labelbar
  ; res@pmLabelBarWidthF


; ************** axis *******************************
; xres@trXReverse = True      ;reverse the first axis
; res@trYReverse = True      ;reverse the second axis
; res@tmYLOn = False         ;no left tickmarks
; res@tmYROn = False         ;no right tickmarks
; res@tmXBOn = False         ; no bottom tickmarks
; res@tmXTOn = False         ; no top tickmarks
; res@tmYLBorderOn = False          ;no left border
; res@tmYRBorderOn = False          ;no right border
; res@tmXBLabelsOn = False          ; no bottom border
; res@tmXTLabelsOn = False          ; no top border

; res@tmYLMode              = "Explicit"
; res@tmYLValues            = (/300,500,700,1000/)
; res@tmYLLabels            = "" + res@tmYLValues

;res@gsnYAxisIrregular2Linear = True ;change the Y axis to a logarithmic axis, usually apply to X/Y-Z plot



; ************* title **********************************
  res@tiMainString         = "Salinity difference: level 1 - level 2 (psu)"   ; main title on the top of each plot
; res@gsnLeftString        = " "                ;default: long_name
; res@gsnCenterString      =  "Sea Surface Temperature"                  ;default: none
; res@gsnRightString       = ""         ;default:units
; res@tiYAxisString="obs"                       ;default: long_name of Y

  res@tiMainStringFontHeightF=0.014
  res@gsnLeftStringFontHeightF=0.014
  res@gsnCenterStringFontHeightF=0.014
  res@gsnRightStringFontHeightF=0.014

; res@tiYAxisOn=False
; res@tiYAxisString=
; gsnPanelFigureStrings = (/"a)","b)"/)

; ************* dash line and zero *********************************
  res@gsnContourZeroLineThicknessF = 2.    ; doubles thickness of zero contour
  res@gsnContourNegLineDashPattern = 1     ; sets negative contours to dash pattern 1


; ************* draw plot ******************************
; subcript (10:20,36:120) (:,:) (:,::-1,:) ({-20.25:30.25},:)
; plot=gsn_csm_contour_map(wks,var(0,0,:,:),res) ; horizontal plot with map
; delete(res@cnInfoLabelOn)  ;turn off resources cnInfoLabelOn for the following plot
; plot=gsn_csm_contour(wks,var(t,0,10:20,36:120),res)  ; X/Y-Z plot
; plot = gsn_csm_hov(wks, var(:,{5:300}), res)    ; time .VS. Longitude plot
; plot = gsn_csm_pres_hgt(wks,var(:,:),res)    ; height/pressure lon plot


; create panel plots
; plot=new(2,graphic)
  plot=new(1,graphic)
; these resources are most commonly used while creating panel, but not used while not creating panel
  res@gsnDraw  = False                          ; don't draw
  res@gsnFrame = False                          ; don't advance frame


  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMaxLevelValF       = 0.001   ; 0.5   ; 1.0  ; 30.
  res@cnMinLevelValF       = -0.001  ; -0.5  ; -1.0
  res@cnLevelSpacingF      = 0.0001     ; 0.2   ; 1.

  plot(0)=gsn_csm_contour_map(wks, salt_diff(:,:), res)

; ;  draw(plot(0))
;        res@cnMaxLevelValF=1.
;        res@cnMinLevelValF=-1.
;        res@cnLevelSpacingF=0.2
; 
; plot(1)=gsn_csm_contour_map(wks,var1(:,:),res)

  
;***********************************************
; draw line on contour
;*******************************************************************

;***********************************************************************
; panel plots
;**************************************************************************

resP                     = True

;----string
;resP@txString="CRFSW"
;resP@gsnPanelFigureStrings= (/"a)","b)"/) ; add strings to panel
;resP@gsnPanelFigureStringsPerimOn     = False
;resP@gsnPanelFigureStringsFontHeightF = 0.01
;resP@amJust = "TopLeft" ;("TopRight", "TopLeft", or "BottomLeft" )
;resP@gsnFrame  = False   ; don't advance panel plot, works as a switch to the following space creating part
;resP@gsnPanelBottom   = 0.05                   ; add space at bottom
;res@txFontHeightF     = .24

; ------ label bar
; resP@gsnPanelLabelBar    = True    ; add common colorbar (both plots should be set to the same interval)
; resP@lbLabelAutoStride = True  ;automatically pick nice labelar label stride
; resP@pmLabelBarOrthogonalPosF = -0.07        ; move the labelbar down a bit so we have room for the overall x-axis
; resP@lbTitlePosition = "Bottom"       ; put it below the plot
; resP@lbTitleString = "Temperature Tendency at Vortex Center (K h~S~-1~N~)" ; give the labelbar a title
; resP@lbTitleFontHeightF = 0.018      ; tweak the size of the labelbar title
; resP@lbTitleOffsetF = 0.2            ; positive values are up when the labelbar is under the plot
; resP@lbLabelFontHeightF  = 0.007    ; make labels smaller

;----- mutiple label bar within one panel plots
;  pplots = gsn_panel_return(wks,plot(0:8),(/3,3/),resP) ; Retrieve bounding boxes of all objects created by gsn_panel call. max(bb(:,0)) is the topmost location of all combined objects, and min(bb(:,1)) is the bottommost.
;  bb     = NhlGetBB(pplots)
;  height = max(bb(0,0)) - min(bb(0,1))
;  height = 0.3 ;---Using height value, now we can panel all sets of plots.
; resP@gsnDraw                          = True
; resP@gsnPanelTop                      = 0.95   ; leave room for title
; resP@gsnPanelBottom                   = resP@gsnPanelTop - height
;  resP@gsnPanelRowSpec = True    ; tell panel what order to plt

; nplots = 9
; do n=0,nplots-1,3
 gsn_panel(wks,plot,(/1,1/),resP)
; following three resources was Set for the next panel call.
;    resP@txString = ""
;    resP@gsnPanelTop    = pres@gsnPanelBottom  
;    resP@gsnPanelBottom = pres@gsnPanelTop-height
;  end do

;*****************************************************
; Overlay and panel
;******************************************************
;overlay(plot1(0),plot(0))  ; plot1(0) is the base plot, the plot(0) is the object graphic to be overlaid on the base plot.
;overlay(plot1(1),plot(1))
;overlay(plot1(2),plot(2))
;gsn_panel(wks,plot1,(/3,1/),resP)    ; draw as one plot


;**************************************************************************************************
;Adds some space at the bottom of the plot for more text
;**************************************************************************************************
;txres               = True
;txres@txFontHeightF = 0.015
;gsn_text_ndc(wks,"Figure 1: A nifty panel plot",0.5,0.02,txres)
;frame(wks)
;end do

end
