load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin", "ReadByteOrder" , "BigEndian")
    setfileoption("bin", "WriteByteOrder", "BigEndian")

  ; DIR_MOM2SODA = getenv("DIR_ROOT_RUN_SODA")
    DIR_MOM2SODA = "/glade/scratch/lgchen/project/MOM_run/SODA_3.2/TEST_Gena/SODA"
    print("DIR_MOM2SODA = " + DIR_MOM2SODA)

  ; str_time = getenv("STR_CURR_CYCLE")
    print(str_time)

    fn_nc = str_time + ".soda2mom.correctors.nc"
    fl_nc = addfile(DIR_MOM2SODA + "/" + fn_nc, "w")

    fl_nc->tcor(0, 0:49, 595:613, 1311:1329) = 0.0
    fl_nc->scor(0, 0:49, 595:613, 1311:1329) = 0.0  


  ; ; experiment to set all zero except for the surface
  ; fl_nc->tcor(0, 1:49, :, :) = 0.0
  ; fl_nc->scor(0, 1:49, :, :) = 0.0 

  ; fl_nc->tcor = 0.0
  ; fl_nc->scor = 0.0 


  ; fl_nc->tcor(0, 5:49, 582:588, 809:814) = 0.0
  ; fl_nc->scor(0, 5:49, 582:588, 809:814) = 0.0

    fl_nc->tcor(0, 0:49, 579:591, 806:817) = 0.0
    fl_nc->scor(0, 0:49, 579:591, 806:817) = 0.0

  ; fl_nc->tcor(0, 0:49, 445:451, 278:284) = 0.0
  ; fl_nc->scor(0, 0:49, 445:451, 278:284) = 0.0   

  ; fl_nc->tcor(0, 0:49, 582:588, 152:158) = 0.0
  ; fl_nc->scor(0, 0:49, 582:588, 152:158) = 0.0

  ; fl_nc->tcor(0, 0:49, 596:602, 164:170) = 0.0
  ; fl_nc->scor(0, 0:49, 596:602, 164:170) = 0.0

  ; fl_nc->tcor(0, 0:49, 575:581, 788:794) = 0.0
  ; fl_nc->scor(0, 0:49, 575:581, 788:794) = 0.0


  ; ; Following 3 areas have salinity over 40 only for vertical levels 0-3, (5.03m - 35.36m)
  ; fl_nc->tcor(0, 0:49, 472:478, 958:964) = 0.0
  ; fl_nc->scor(0, 0:49, 472:478, 958:964) = 0.0

  ; fl_nc->tcor(0, 0:49, 607:613, 782:788) = 0.0
  ; fl_nc->scor(0, 0:49, 607:613, 782:788) = 0.0

  ; fl_nc->tcor(0, 0:49, 569:575, 807:813) = 0.0
  ; fl_nc->scor(0, 0:49, 569:575, 807:813) = 0.0


  ; ; new area
  ; fl_nc->tcor(0, 0:49, 577:585, 1392:1402) = 0.0
  ; fl_nc->scor(0, 0:49, 577:585, 1392:1402) = 0.0   

  ; fl_nc->tcor(0, 0:49, 582:588, 1390:1397) = 0.0
  ; fl_nc->scor(0, 0:49, 582:588, 1390:1397) = 0.0   

  ; fl_nc->tcor(0, 0:49, 515:522, 1063:1070) = 0.0
  ; fl_nc->scor(0, 0:49, 515:522, 1063:1070) = 0.0   


  ; ; happened around 19891005
  ; fl_nc->tcor(0, 0:49, 794:799, 511:517) = 0.0
  ; fl_nc->scor(0, 0:49, 794:799, 511:517) = 0.0


    system("exit 0")
end
