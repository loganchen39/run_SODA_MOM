! Description: Compute 10 daily mean precipitations for a designated period from the WRF
!              output NetCDF files, each of which has frequency of 3 hours and 8 steps, i.e.
!              a file record for a day.
!       Input: The same number of NetCDF files from the WRF output as that of the days in
!              the designated period.
!      Output: The same number of NetCDF files with result 10 daily mean precipitations as
!              that of the days in the designated period.
!      Author: Ligang Chen, lgchen@illinois.edu
!    Modified: 04/10/2009

program main
  use netcdf
  implicit none

  ! Define parameters for read-in and write-out: file, dimensions, variables, attributes
  character(len = *), parameter :: DATAIN_DIR  = "/mnt/lfs0/projects/ciaqex/xingyuan/HR/report/m8c3CTL", &
                                   DATAOUT_DIR = "/misc/whome/lchen/data/PrOpt/WrfoutNcAprDM_1993/nc2nc/m8c3"
  character(len = 30)           :: ifname_cur, ifname_next, ofname
  character(len = 6 )           :: postfix

  integer, parameter :: START_DATE = 1, END_DATE = 123               
  integer            :: day, ncid
  
  integer, parameter :: NDIM = 3, TIME = 8, SOUTH_NORTH = 138, WEST_EAST = 195
  integer            :: south_north_dimid, west_east_dimid
  integer            :: dimids(NDIM - 1)
  
  character(len = *), parameter :: RAINC_NAME  = "RAINC" ,       &
                                   RAINNC_NAME = "RAINNC",       &
                                   APR_GR_NAME = "APR_GR",       &
                                   APR_W_NAME  = "APR_W" ,       &
                                   APR_MC_NAME = "APR_MC",       &
                                   APR_ST_NAME = "APR_ST",       &
                                   APR_AS_NAME = "APR_AS",       &
                                   APR_CAPMA_NAME = "APR_CAPMA", &
                                   APR_CAPME_NAME = "APR_CAPME", &
                                   APR_CAPMI_NAME = "APR_CAPMI"
  integer :: rainc_varid, rainnc_varid, apr_gr_varid, apr_w_varid,      &
             apr_mc_varid, apr_st_varid, apr_as_varid, apr_capma_varid, &
             apr_capme_varid, apr_capmi_varid

  character(len = *), parameter :: FIELDTYPE         = "FieldType"
  integer           , parameter :: FIELDTYPE_VALUE   = 104
  character(len = *), parameter :: MEMORYORDER       = "MemoryOrder", &
                                   MEMORYORDER_VALUE = "XY"         , &
                                   UNITS             = "units"      , &
                                   UNITS_VALUE       = "mm/day"     , &
                                   STAGGER           = "stagger"    , &
                                   STAGGER_VALUE     = ""

  character(len = *), parameter :: DESCRIPTION        = "description"                   , &
                                   RAINC_DESCRIPTION  = "DAILY CUMULUS PRECIPITATION"   , &
                                   RAINNC_DESCRIPTION = "DAILY GRID-SCALE PRECIPITATION", &
                                   APR_GR_DESCRIPTION = "PRECIP FROM CLOSURE OLD_GRELL" , &
                                   APR_W_DESCRIPTION  = "PRECIP FROM CLOSURE W"         , &
                                   APR_MC_DESCRIPTION = "PRECIP FROM CLOSURE KRISH MV"  , &
                                   APR_ST_DESCRIPTION = "PRECIP FROM CLOSURE STABILITY" , &
                                   APR_AS_DESCRIPTION = "PRECIP FROM CLOSURE AS-TYPE"   , &
                                   APR_CAPMA_DESCRIPTION = "PRECIP FROM MAX CAP"        , &
                                   APR_CAPME_DESCRIPTION = "PRECIP FROM MEAN CAP"       , &
                                   APR_CAPMI_DESCRIPTION = "PRECIP FROM MIN CAP"
			 
  ! Define arrays to receive variables' data, note that Fortran is column-majored
  real :: rainc_in (WEST_EAST, SOUTH_NORTH, TIME),    &
          rainnc_in(WEST_EAST, SOUTH_NORTH, TIME),    &
          apr_gr_in(WEST_EAST, SOUTH_NORTH, TIME),    &
          apr_w_in (WEST_EAST, SOUTH_NORTH, TIME),    &
          apr_mc_in(WEST_EAST, SOUTH_NORTH, TIME),    &
          apr_st_in(WEST_EAST, SOUTH_NORTH, TIME),    &
          apr_as_in(WEST_EAST, SOUTH_NORTH, TIME),    &
          apr_capma_in(WEST_EAST, SOUTH_NORTH, TIME), &
          apr_capme_in(WEST_EAST, SOUTH_NORTH, TIME), &
          apr_capmi_in(WEST_EAST, SOUTH_NORTH, TIME)
			 
  ! Define arrays to store result daily mean precipitations
  real :: rainc_out (WEST_EAST, SOUTH_NORTH),    &
          rainnc_out(WEST_EAST, SOUTH_NORTH),    &
          apr_gr_out(WEST_EAST, SOUTH_NORTH),    &
          apr_w_out (WEST_EAST, SOUTH_NORTH),    &
    	  apr_mc_out(WEST_EAST, SOUTH_NORTH),    &
          apr_st_out(WEST_EAST, SOUTH_NORTH),    &
          apr_as_out(WEST_EAST, SOUTH_NORTH),    &
          apr_capma_out(WEST_EAST, SOUTH_NORTH), &
          apr_capme_out(WEST_EAST, SOUTH_NORTH), &
          apr_capmi_out(WEST_EAST, SOUTH_NORTH)
			 
  ! Loop indices, temporary variables
  integer :: i, j, k

  ifname_cur  = "wrfout_d01_"
  ifname_next = "wrfout_d01_"
  ofname      = "pr_wrfout_d01_"

  ! Compute accumulated and daily mean precipitations for the variables, 
  ! each of which has one data record for one day. These data need to be
  ! extracted from 2 continuous NetCDF files, i.e. 2 continuous days.
  do day = START_DATE, END_DATE

    write(unit=postfix, fmt="(I6.6)")  720 * (day - 1)
    ifname_cur(12:17)  = postfix
    ofname(15:20)      = postfix
    write(unit=postfix, fmt="(I6.6)")  720 * day
    ifname_next(12:17) = postfix

    ! Zero output arrays
    apr_gr_out = 0.0
    apr_w_out  = 0.0
    apr_mc_out = 0.0
    apr_st_out = 0.0
    apr_as_out = 0.0
    apr_capma_out = 0.0
    apr_capme_out = 0.0
    apr_capmi_out = 0.0
    
    ! Open the file for the current day and read in the corresponding variables' data
    call check( nf90_open(DATAIN_DIR//"/"//ifname_cur, nf90_nowrite, ncid) )
  
    call check( nf90_inq_varid(ncid, RAINC_NAME , rainc_varid ) )
    call check( nf90_inq_varid(ncid, RAINNC_NAME, rainnc_varid) )
    call check( nf90_inq_varid(ncid, APR_GR_NAME, apr_gr_varid) )
    call check( nf90_inq_varid(ncid, APR_W_NAME , apr_w_varid ) )
    call check( nf90_inq_varid(ncid, APR_MC_NAME, apr_mc_varid) )
    call check( nf90_inq_varid(ncid, APR_ST_NAME, apr_st_varid) )
    call check( nf90_inq_varid(ncid, APR_AS_NAME, apr_as_varid) )
    call check( nf90_inq_varid(ncid, APR_CAPMA_NAME, apr_capma_varid) )
    call check( nf90_inq_varid(ncid, APR_CAPME_NAME, apr_capme_varid) )
    call check( nf90_inq_varid(ncid, APR_CAPMI_NAME, apr_capmi_varid) )
  
    call check( nf90_get_var(ncid, rainc_varid , rainc_in ) )
    call check( nf90_get_var(ncid, rainnc_varid, rainnc_in) )
    call check( nf90_get_var(ncid, apr_gr_varid, apr_gr_in) )
    call check( nf90_get_var(ncid, apr_w_varid , apr_w_in ) )
    call check( nf90_get_var(ncid, apr_mc_varid, apr_mc_in) )
    call check( nf90_get_var(ncid, apr_st_varid, apr_st_in) )
    call check( nf90_get_var(ncid, apr_as_varid, apr_as_in) )
    call check( nf90_get_var(ncid, apr_capma_varid, apr_capma_in) )
    call check( nf90_get_var(ncid, apr_capme_varid, apr_capme_in) )
    call check( nf90_get_var(ncid, apr_capmi_varid, apr_capmi_in) )

    call check( nf90_close(ncid) )

    ! Get the data from the current day file
    rainc_out  = rainc_in (:, :, 1)
    rainnc_out = rainnc_in(:, :, 1)

    do k = 2, TIME
      apr_gr_out = apr_gr_out + apr_gr_in(:, :, k)
      apr_w_out  = apr_w_out  + apr_w_in (:, :, k)
      apr_mc_out = apr_mc_out + apr_mc_in(:, :, k)
      apr_st_out = apr_st_out + apr_st_in(:, :, k)
      apr_as_out = apr_as_out + apr_as_in(:, :, k)
      apr_capma_out = apr_capma_out + apr_capma_in(:, :, k)
      apr_capme_out = apr_capme_out + apr_capme_in(:, :, k)
      apr_capmi_out = apr_capmi_out + apr_capmi_in(:, :, k)  
    end do
    
    ! Open the file for the next day and read in the corresponding variables' data
    call check( nf90_open(DATAIN_DIR//"/"//ifname_next, nf90_nowrite, ncid) )
  
    call check( nf90_inq_varid(ncid, RAINC_NAME , rainc_varid ) )
    call check( nf90_inq_varid(ncid, RAINNC_NAME, rainnc_varid) )
    call check( nf90_inq_varid(ncid, APR_GR_NAME, apr_gr_varid) )
    call check( nf90_inq_varid(ncid, APR_W_NAME , apr_w_varid ) )
    call check( nf90_inq_varid(ncid, APR_MC_NAME, apr_mc_varid) )
    call check( nf90_inq_varid(ncid, APR_ST_NAME, apr_st_varid) )
    call check( nf90_inq_varid(ncid, APR_AS_NAME, apr_as_varid) )
    call check( nf90_inq_varid(ncid, APR_CAPMA_NAME, apr_capma_varid) )
    call check( nf90_inq_varid(ncid, APR_CAPME_NAME, apr_capme_varid) )
    call check( nf90_inq_varid(ncid, APR_CAPMI_NAME, apr_capmi_varid) )
  
    call check( nf90_get_var(ncid, rainc_varid , rainc_in ) )
    call check( nf90_get_var(ncid, rainnc_varid, rainnc_in) )
    call check( nf90_get_var(ncid, apr_gr_varid, apr_gr_in) )
    call check( nf90_get_var(ncid, apr_w_varid , apr_w_in ) )
    call check( nf90_get_var(ncid, apr_mc_varid, apr_mc_in) )
    call check( nf90_get_var(ncid, apr_st_varid, apr_st_in) )
    call check( nf90_get_var(ncid, apr_as_varid, apr_as_in) )
    call check( nf90_get_var(ncid, apr_capma_varid, apr_capma_in) )
    call check( nf90_get_var(ncid, apr_capme_varid, apr_capme_in) )
    call check( nf90_get_var(ncid, apr_capmi_varid, apr_capmi_in) )

    call check( nf90_close(ncid) )

    ! Get the final data
    rainc_out  = rainc_in (:, :, 1) - rainc_out
    rainnc_out = rainnc_in(:, :, 1) - rainnc_out

    apr_gr_out = apr_gr_out + apr_gr_in(:, :, 1)
    apr_w_out  = apr_w_out  + apr_w_in (:, :, 1)
    apr_mc_out = apr_mc_out + apr_mc_in(:, :, 1)
    apr_st_out = apr_st_out + apr_st_in(:, :, 1)
    apr_as_out = apr_as_out + apr_as_in(:, :, 1)
    apr_capma_out = apr_capma_out + apr_capma_in(:, :, 1)
    apr_capme_out = apr_capme_out + apr_capme_in(:, :, 1)
    apr_capmi_out = apr_capmi_out + apr_capmi_in(:, :, 1)  

    apr_gr_out = 3.0 * apr_gr_out  ! mm/hour -> mm/day
    apr_w_out  = 3.0 * apr_w_out
    apr_mc_out = 3.0 * apr_mc_out
    apr_st_out = 3.0 * apr_st_out
    apr_as_out = 3.0 * apr_as_out
    apr_capma_out = 3.0 * apr_capma_out
    apr_capme_out = 3.0 * apr_capme_out
    apr_capmi_out = 3.0 * apr_capmi_out

    !\Write out the result daily mean pricipitation to a NetCDF file
    !\First define related dimensions, variables and their associated attributes
    call check( nf90_create(DATAOUT_DIR//"/"//ofname, NF90_CLOBBER, ncid) )

    call check( nf90_def_dim(ncid, "south_north", SOUTH_NORTH, south_north_dimid) )
    call check( nf90_def_dim(ncid, "west_east", WEST_EAST, west_east_dimid) )

    dimids = (/ west_east_dimid, south_north_dimid /)

    call check( nf90_def_var(ncid, RAINC_NAME , NF90_REAL, dimids, rainc_varid ) )
    call check( nf90_def_var(ncid, RAINNC_NAME, NF90_REAL, dimids, rainnc_varid) )
    call check( nf90_def_var(ncid, APR_GR_NAME, NF90_REAL, dimids, apr_gr_varid) )
    call check( nf90_def_var(ncid, APR_W_NAME , NF90_REAL, dimids, apr_w_varid ) )
    call check( nf90_def_var(ncid, APR_MC_NAME, NF90_REAL, dimids, apr_mc_varid) )
    call check( nf90_def_var(ncid, APR_ST_NAME, NF90_REAL, dimids, apr_st_varid) )
    call check( nf90_def_var(ncid, APR_AS_NAME, NF90_REAL, dimids, apr_as_varid) )
    call check( nf90_def_var(ncid, APR_CAPMA_NAME, NF90_REAL, dimids, apr_capma_varid) )
    call check( nf90_def_var(ncid, APR_CAPME_NAME, NF90_REAL, dimids, apr_capme_varid) )
    call check( nf90_def_var(ncid, APR_CAPMI_NAME, NF90_REAL, dimids, apr_capmi_varid) )

    call check( nf90_put_att(ncid, rainc_varid , FIELDTYPE  , FIELDTYPE_VALUE   ) )
    call check( nf90_put_att(ncid, rainc_varid , MEMORYORDER, MEMORYORDER_VALUE ) )
    call check( nf90_put_att(ncid, rainc_varid , DESCRIPTION, RAINC_DESCRIPTION ) )
    call check( nf90_put_att(ncid, rainc_varid , UNITS      , UNITS_VALUE       ) )
    call check( nf90_put_att(ncid, rainc_varid , STAGGER    , STAGGER_VALUE     ) )

    call check( nf90_put_att(ncid, rainnc_varid, FIELDTYPE  , FIELDTYPE_VALUE   ) )
    call check( nf90_put_att(ncid, rainnc_varid, MEMORYORDER, MEMORYORDER_VALUE ) )
    call check( nf90_put_att(ncid, rainnc_varid, DESCRIPTION, RAINNC_DESCRIPTION) )
    call check( nf90_put_att(ncid, rainnc_varid, UNITS      , UNITS_VALUE       ) )
    call check( nf90_put_att(ncid, rainnc_varid, STAGGER    , STAGGER_VALUE     ) )

    call check( nf90_put_att(ncid, apr_gr_varid, FIELDTYPE  , FIELDTYPE_VALUE   ) )
    call check( nf90_put_att(ncid, apr_gr_varid, MEMORYORDER, MEMORYORDER_VALUE ) )
    call check( nf90_put_att(ncid, apr_gr_varid, DESCRIPTION, APR_GR_DESCRIPTION) )
    call check( nf90_put_att(ncid, apr_gr_varid, UNITS      , UNITS_VALUE       ) )
    call check( nf90_put_att(ncid, apr_gr_varid, STAGGER    , STAGGER_VALUE     ) )

    call check( nf90_put_att(ncid, apr_w_varid , FIELDTYPE  , FIELDTYPE_VALUE   ) )
    call check( nf90_put_att(ncid, apr_w_varid , MEMORYORDER, MEMORYORDER_VALUE ) )
    call check( nf90_put_att(ncid, apr_w_varid , DESCRIPTION, APR_W_DESCRIPTION ) )
    call check( nf90_put_att(ncid, apr_w_varid , UNITS      , UNITS_VALUE       ) )
    call check( nf90_put_att(ncid, apr_w_varid , STAGGER    , STAGGER_VALUE     ) )

    call check( nf90_put_att(ncid, apr_mc_varid, FIELDTYPE  , FIELDTYPE_VALUE   ) )
    call check( nf90_put_att(ncid, apr_mc_varid, MEMORYORDER, MEMORYORDER_VALUE ) )
    call check( nf90_put_att(ncid, apr_mc_varid, DESCRIPTION, APR_MC_DESCRIPTION) )
    call check( nf90_put_att(ncid, apr_mc_varid, UNITS      , UNITS_VALUE       ) )
    call check( nf90_put_att(ncid, apr_mc_varid, STAGGER    , STAGGER_VALUE     ) )

    call check( nf90_put_att(ncid, apr_st_varid, FIELDTYPE  , FIELDTYPE_VALUE   ) )
    call check( nf90_put_att(ncid, apr_st_varid, MEMORYORDER, MEMORYORDER_VALUE ) )
    call check( nf90_put_att(ncid, apr_st_varid, DESCRIPTION, APR_ST_DESCRIPTION) )
    call check( nf90_put_att(ncid, apr_st_varid, UNITS      , UNITS_VALUE       ) )
    call check( nf90_put_att(ncid, apr_st_varid, STAGGER    , STAGGER_VALUE     ) )

    call check( nf90_put_att(ncid, apr_as_varid, FIELDTYPE  , FIELDTYPE_VALUE   ) )
    call check( nf90_put_att(ncid, apr_as_varid, MEMORYORDER, MEMORYORDER_VALUE ) )
    call check( nf90_put_att(ncid, apr_as_varid, DESCRIPTION, APR_AS_DESCRIPTION) )
    call check( nf90_put_att(ncid, apr_as_varid, UNITS      , UNITS_VALUE       ) )
    call check( nf90_put_att(ncid, apr_as_varid, STAGGER    , STAGGER_VALUE     ) )

    call check( nf90_put_att(ncid, apr_capma_varid, FIELDTYPE  , FIELDTYPE_VALUE      ) )
    call check( nf90_put_att(ncid, apr_capma_varid, MEMORYORDER, MEMORYORDER_VALUE    ) )
    call check( nf90_put_att(ncid, apr_capma_varid, DESCRIPTION, APR_CAPMA_DESCRIPTION) )
    call check( nf90_put_att(ncid, apr_capma_varid, UNITS      , UNITS_VALUE          ) )
    call check( nf90_put_att(ncid, apr_capma_varid, STAGGER    , STAGGER_VALUE        ) )

    call check( nf90_put_att(ncid, apr_capme_varid, FIELDTYPE  , FIELDTYPE_VALUE      ) )
    call check( nf90_put_att(ncid, apr_capme_varid, MEMORYORDER, MEMORYORDER_VALUE    ) )
    call check( nf90_put_att(ncid, apr_capme_varid, DESCRIPTION, APR_CAPME_DESCRIPTION) )
    call check( nf90_put_att(ncid, apr_capme_varid, UNITS      , UNITS_VALUE          ) )
    call check( nf90_put_att(ncid, apr_capme_varid, STAGGER    , STAGGER_VALUE        ) )

    call check( nf90_put_att(ncid, apr_capmi_varid, FIELDTYPE  , FIELDTYPE_VALUE      ) )
    call check( nf90_put_att(ncid, apr_capmi_varid, MEMORYORDER, MEMORYORDER_VALUE    ) )
    call check( nf90_put_att(ncid, apr_capmi_varid, DESCRIPTION, APR_CAPMI_DESCRIPTION) )
    call check( nf90_put_att(ncid, apr_capmi_varid, UNITS      , UNITS_VALUE          ) )
    call check( nf90_put_att(ncid, apr_capmi_varid, STAGGER    , STAGGER_VALUE        ) )
  
    call check( nf90_enddef(ncid) )

    ! Write all variables' data
    call check( nf90_put_var(ncid, rainc_varid , rainc_out ) )
    call check( nf90_put_var(ncid, rainnc_varid, rainnc_out) )
    call check( nf90_put_var(ncid, apr_gr_varid, apr_gr_out) )
    call check( nf90_put_var(ncid, apr_w_varid , apr_w_out ) )
    call check( nf90_put_var(ncid, apr_mc_varid, apr_mc_out) )
    call check( nf90_put_var(ncid, apr_st_varid, apr_st_out) )
    call check( nf90_put_var(ncid, apr_as_varid, apr_as_out) )
    call check( nf90_put_var(ncid, apr_capma_varid, apr_capma_out) )
    call check( nf90_put_var(ncid, apr_capme_varid, apr_capme_out) )
    call check( nf90_put_var(ncid, apr_capmi_varid, apr_capmi_out) )

    call check( nf90_close(ncid) )

    ! Print SUCCESS information
    write(*, *) "*** SUCCESS getting accumulated and daily mean precipitations ***"

  end do

  stop
end program main

subroutine check(status)
  use netcdf
  integer, intent(in) :: status
  
  if (status /= nf90_noerr) then
    print *, trim(nf90_strerror(status))
    stop 2
  end if
end subroutine check
