; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"


begin
    setfileoption("bin","ReadByteOrder" ,"BigEndian")
    setfileoption("bin","WriteByteOrder","BigEndian")

    DIR_SODA = "/aosc/beaufort/arctic3/chepurin/SODA_2.2.4"
    DIR_SSH  = "/aosc/beaufort/lchen/extract_soda_ssh/tmp"

    FN_PREF_SODA = "SODA_2.2.4_"
    FN_PREF_SSH  = "SSH_SODA_2.2.4_"

    START_YEAR = 2009  ; 1871
    END_YEAR   = 2010

    do i_yr = START_YEAR, END_YEAR
        do i_mon = 1, 12
            fn_soda = FN_PREF_SODA + sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + ".cdf"
            fn_ssh  = FN_PREF_SSH  + sprinti("%0.4i", i_yr) + sprinti("%0.2i", i_mon) + ".nc"

            fl_nc_soda = addfile(DIR_SODA + "/" + fn_soda, "r")
            fl_nc_ssh  = addfile(DIR_SSH  + "/" + fn_ssh , "c")

            if (i_yr .le. 2008) then
                fl_nc_ssh->ssh = fl_nc_soda->ssh
            else
                fl_nc_ssh->ssh = fl_nc_soda->SSH
            end if
        end do
    end do

    system("exit 0")
end
