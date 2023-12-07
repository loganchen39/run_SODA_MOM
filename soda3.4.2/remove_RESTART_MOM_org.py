#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os
import datetime


DIR_MOM = "/glade/scratch/lgchen/project/soda3.4.2/2019"

jday_20181227 = datetime.date(2018, 12, 27)
jday_20191222 = datetime.date(2019, 12, 22)
td = datetime.timedelta(days=10)

os.chdir(DIR_MOM)

jday = jday_20181227
while jday <= jday_20191222:
    str_curr_cycle = jday.strftime('%Y%m%d')
    print('str_curr_cycle = ' + str_curr_cycle)

    for fn in os.listdir('./MOM_org/' + str_curr_cycle + '/RESTART'):
        os.remove('./MOM_org/' + str_curr_cycle + '/RESTART/' + fn)

    jday += td
