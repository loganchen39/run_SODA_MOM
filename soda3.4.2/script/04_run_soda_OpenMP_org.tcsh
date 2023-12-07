#!/bin/tcsh


set STR_CURR_CYCLE    = $1
set DIR_CODE_SODA     = $2
set DIR_ROOT_RUN_SODA = $3
set START_YEAR        = $4
set START_MONTH       = $5
set START_DAY         = $6

echo STR_CURR_CYCLE    = $STR_CURR_CYCLE
echo DIR_CODE_SODA     = $DIR_CODE_SODA
echo DIR_ROOT_RUN_SODA = $DIR_ROOT_RUN_SODA
echo START_YEAR        = $START_YEAR
echo START_MONTH       = $START_MONTH
echo START_DAY         = $START_DAY


cd $DIR_CODE_SODA
set str_time = $STR_CURR_CYCLE

ln -sf $DIR_ROOT_RUN_SODA/$str_time.first_guess.dat ./first_guess.dat
sed '/year/s/2011/'$START_YEAR'/; /month/s/1/'$START_MONTH'/; /day/s/1/'$START_DAY'/' soda_in_template >&! soda_in

./soda.exe >&! $str_time.soda.out

mv -f correctors.dat $DIR_ROOT_RUN_SODA/$str_time.correctors.dat
mv -f temp_var.wrk   $DIR_ROOT_RUN_SODA/$str_time.temp_var.wrk
mv -f salt_var.wrk   $DIR_ROOT_RUN_SODA/$str_time.salt_var.wrk
mv -f sst_var.wrk    $DIR_ROOT_RUN_SODA/$str_time.sst_var.wrk


exit 0
