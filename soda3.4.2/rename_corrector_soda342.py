#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os
import datetime


DIR_DATA = "/glade/scratch/lgchen/project/soda3.4.2/2019/SODA/correctors.nc"

jday_20190804 = datetime.date(2019,  8,  4)
jday_20191222 = datetime.date(2019, 12, 22)

os.chdir(DIR_DATA)

jday = jday_20190804
while jday <= jday_20191222:
    str_curr_cycle = jday.strftime('%Y%m%d')
    print('str_curr_cycle = ' + str_curr_cycle)
    # soda corrector
    str_fn_cycle = (jday + datetime.timedelta(days=5)).strftime('%Y_%m_%d')
    
    fn_mon  = str_curr_cycle + '.correctors.nc'
    fn_soda = 'soda3.4.2_10dy_incr_1x1_' + str_fn_cycle + '.nc'
    os.rename(fn_mon, fn_soda)

    jday += datetime.timedelta(days=10) 
