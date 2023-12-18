

cd /aosc/greenland/

# select 14 variables to save
cdo selname,temp,salt,wt,ssh,mlt,mlp,mls,hflux_total,prho,u,v,taux,tauy \
 ./soda3.3.2/REGRIDED/ocean/soda3.3.2_5dy_ocean_reg_1980_01_03.nc \
 /aosc/horse/carton/temp332
cdo selname,temp,salt,wt,ssh,mlt,mlp,mls,hflux_total,prho,u,v,taux,tauy \
 ./soda3.4.2/REGRIDED/ocean/soda3.4.2_5dy_ocean_reg_1980_01_03.nc \
 /aosc/horse/carton/temp342
cdo selname,temp,salt,wt,ssh,mlt,mlp,mls,hflux_total,prho,u,v,taux,tauy \
 ./soda3.6.1/REGRIDED/ocean/soda3.6.1_5dy_ocean_reg_1980_01_03.nc \
 /aosc/horse/carton/temp361
cdo selname,temp,salt,wt,ssh,mlt,mlp,mls,hflux_total,prho,u,v,taux,tauy \
 ./soda3.7.2/REGRIDED/ocean/soda3.7.2_5dy_ocean_reg_1980_01_03.nc \
 /aosc/horse/carton/temp372
cdo selname,temp,salt,wt,ssh,mlt,mlp,mls,hflux_total,prho,u,v,taux,tauy \
 ./soda3.11.2/REGRIDED/ocean/soda3.11.2_5dy_ocean_reg_1980_01_03.nc \
 /aosc/horse/carton/temp3112
cdo selname,temp,salt,wt,ssh,mlt,mlp,mls,hflux_total,prho,u,v,taux,tauy \
 ./soda3.12.2/REGRIDED/ocean/soda3.12.2_5dy_ocean_reg_1980_01_03.nc \
 /aosc/horse/carton/temp3122

cd /aosc/horse/carton/

# compute the ensemble mean
cdo ensmean temp332 temp342 temp361 temp372 temp3112 temp3122 \
temp_mean.nc

# fix the parameter table (including names)
cdo setpartabn,mean-partabn.txt,convert temp_mean.nc \
  temp_mean_cor.nc

# compute the ensemble standard deviation 
cdo ensstd1  temp332 temp342 temp361 temp372 temp3112 temp3122 \
temp_std.nc

# fix the parameter table (including names)
cdo setpartabn,std-partabn.txt,convert temp_std.nc \
temp_std_cor.nc

# merge the files
cdo merge temp_mean_cor.nc temp_std_cor.nc \
          soda3_5dy_ocean_reg_1980_01_03.nc

# cleanup the temporary files
rm temp332 temp342 temp361 temp372 temp3112 temp3122 temp.nc \
temp_mean.nc temp_mean_cor.nc temp_std.nc temp_std_cor.nc

