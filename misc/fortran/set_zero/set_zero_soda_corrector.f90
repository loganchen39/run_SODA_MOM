! Description: 
!       Input:
!      Output:
!      Author: Ligang Chen, lchen2@umd.edu
!    Modified: 09/29/2014


program main
  use netcdf
  implicit none

  character(len = *), parameter :: DIR_DATA   &
      = "/glade/p/work/lgchen/data/SODA_MOM/regrid_mom2soda_firstGuess/case1_20050101_10/20140917_ok"
  character(len = 128)          :: ifn

  integer :: ncid, tcor_varid, scor_varid

  real(kind=8) :: tcor_zero(1440, 1070, 50, 1) = 0.0
  real(kind=8) :: scor_zero(1440, 1070, 50, 1) = 0.0


  ifn = "correctors_soda2mom_per_sec_destGrid_mom5_to_soda1x1_setzero_Fortran.nc"

  call check(nf90_open(trim(DIR_DATA)//"/"//trim(ifn), nf90_write, ncid))
  
  call check(nf90_inq_varid(ncid, "tcor", tcor_varid))
  call check(nf90_inq_varid(ncid, "scor", scor_varid))
 
  call check(nf90_put_var(ncid, tcor_varid, tcor_zero))
  call check(nf90_put_var(ncid, scor_varid, scor_zero))
 
  call check(nf90_close(ncid))

  ! Print SUCCESS information
  write(*, *) "*** SUCCESS setting correctors to zero ***"

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
