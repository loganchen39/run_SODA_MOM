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
    character(len = *), parameter :: ifn  &
        = "correctors_soda2mom_per10days_destGrid_mom5_to_soda1x1_tcor_zero_scor_masked.nc"
    character(len = *), parameter :: FN_MASK     = "/glade/p/work/lgchen/data/MOM5/INPUT/topog.nc"
    character(len = *), parameter :: FN_SALT_RES = "/glade/p/work/lgchen/data/MOM5/RESTART_20050101000000_Gena/ocean_temp_salt.res.nc"

    integer :: ncid_corr, vid_tcor, vid_scor, ncid_mask, vid_num_levels, ncid_salt_res, vid_salt_res, i_v_lev


!   real(kind=8) :: tcor_zero(1440, 1070, 50, 1) = 0.0
    real(kind=8) :: num_levels(1440, 1070) = 0.0
    real(kind=8) :: tcor      (1440, 1070, 50, 1) = 0.0
    real(kind=8) :: scor      (1440, 1070, 50, 1) = 0.0
    real(kind=8) :: salt_res  (1440, 1070, 50, 1) = 0.0


    call check(nf90_open(trim(FN_MASK), nf90_nowrite, ncid_mask))
    call check(nf90_inq_varid(ncid_mask, "num_levels", vid_num_levels))
    call check(nf90_get_var(ncid_mask, vid_num_levels, num_levels))
    call check(nf90_close(ncid_mask))

    call check(nf90_open(trim(FN_SALT_RES), nf90_nowrite, ncid_salt_res))
    call check(nf90_inq_varid(ncid_salt_res, "salt", vid_salt_res))
    call check(nf90_get_var(ncid_salt_res, vid_salt_res, salt_res))
    call check(nf90_close(ncid_mask))


    call check(nf90_open(trim(DIR_DATA)//"/"//trim(ifn), nf90_write, ncid_corr))
    
    call check(nf90_inq_varid(ncid_corr, "tcor", vid_tcor))
    call check(nf90_inq_varid(ncid_corr, "scor", vid_scor))

!   call check(nf90_get_var(ncid_corr, vid_tcor, tcor))
    call check(nf90_get_var(ncid_corr, vid_scor, scor))
    do i_v_lev = 1, 50
        where(i_v_lev .le. num_levels) 
!           tcor(:, :, i_v_lev, 1) = tcor(:, :, i_v_lev, 1)
            scor(:, :, i_v_lev, 1) = scor(:, :, i_v_lev, 1)
        elsewhere
!           tcor(:, :, i_v_lev, 1) = 0.0
            scor(:, :, i_v_lev, 1) = 0.0
        end where
    end do

    where(salt_res .lt. 1.0e-6)
        scor = 0.0
    endwhere
 
    call check(nf90_put_var(ncid_corr, vid_tcor, tcor))
    call check(nf90_put_var(ncid_corr, vid_scor, scor))
 
    call check(nf90_close(ncid_corr))

    ! Print SUCCESS information
    write(*, *) "*** SUCCESS masked correctors ***"

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
