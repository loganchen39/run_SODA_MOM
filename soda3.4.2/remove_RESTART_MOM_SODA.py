#!/glade/u/apps/ch/opt/python/3.6.8/gnu/8.3.0/bin/python3

import os
import datetime
import glob


DIR_MOM = "/glade/scratch/lgchen/project/soda3.4.2/2019"

jday_20181227 = datetime.date(2018, 12, 27)
jday_20191222 = datetime.date(2019, 12, 22)
td = datetime.timedelta(days=10)

os.chdir(DIR_MOM)

jday = jday_20181227
while jday <= jday_20191222:
    str_curr_cycle = jday.strftime('%Y%m%d')
    print('str_curr_cycle = ' + str_curr_cycle)

    jday_next      = jday + td
    jday_next_next = jday + 2*td
    if (jday.month == 6 and jday_next.month == 6 and jday_next_next.month == 7)  \
        or (jday.month == 12 and jday_next.month == 12 and jday_next_next.month == 1):
        pass  # using "continue" here would be wrong, as it will skip the following jday+=td! 
    else:
        for fn in glob.glob('./MOM_SODA/' + str_curr_cycle + '/RESTART/*'):
            os.remove(fn) # here the os.remove won't exit even if the above glob list is empty.

    jday += td
