#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os
import datetime


DIR_DATA = "/glade/scratch/lgchen/project/soda3.4.2/2019/MOM_SODA"

jday_20181227 = datetime.date(2018, 12, 27)
jday_20191212 = datetime.date(2019, 12, 12)

os.chdir(DIR_DATA)

jday = jday_20181227
while jday <= jday_20191212:
    str_curr_cycle = jday.strftime('%Y%m%d')
    print('str_curr_cycle = ' + str_curr_cycle)

    for fl in os.listdir(str_curr_cycle + '/history'):
        os.symlink(DIR_DATA + '/' + str_curr_cycle + '/history/' + fl, 'link_forRegrid/' + fl)
        os.symlink(DIR_DATA + '/' + str_curr_cycle + '/history/' + fl, 'link_forTransfer/' + fl)

    jday += datetime.timedelta(days=10) 
