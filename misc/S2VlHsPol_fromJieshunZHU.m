 clear all;
addpath /homes/jianlu/MATLAB/mexcdf/mexnc
addpath /homes/jianlu/MATLAB/mexcdf/netcdf_toolbox/netcdf
addpath /homes/jianlu/MATLAB/mexcdf/netcdf_toolbox/netcdf/nctype
addpath /homes/jianlu/MATLAB/mexcdf/netcdf_toolbox/netcdf/ncutility
addpath /homes/jianlu/MATLAB/mexcdf/netcdf_toolbox/netcdf/ncsource

depmod=[5, 15, 25, 35, 45, 55, 65, 75, 85, 95, 105, 115, 125, 135, 145, 155, ...
    165, 175, 185, 195, 205, 215, 225, 238.4779, 262.2945, 303.0287, ...
    366.7978, 459.091, 584.6193, 747.187, 949.5881, 1193.53, 1479.588, ...
    1807.187, 2174.619, 2579.091, 3016.798, 3483.029, 3972.294, 4478.478];
kmmod=size(depmod,2);

filnam='/homes/jieshun/ECNEMO2CFSv2/grid_spec_05.nc';
nc=netcdf(filnam,'nowrite');
%min(lon)=-280;max(lon)=80;
x_T1=nc{'x_T'}(:,:);y_T1=nc{'y_T'}(:,:);
x_C1=nc{'x_C'}(:,:);y_C1=nc{'y_C'}(:,:);
x_T=x_T1(12:360,:);y_T=y_T1(12:360,:);
x_C=x_C1(12:360,:);y_C=y_C1(12:360,:); %[349,720]

%lon_ts=[-0.5:1:360.5];lon_uv=[0:1:360];
lon4MOMts=[-280.5:1:80.5];lon4MOMuv=[-280:1:81];
load lat_ts;load lat_uv;
[Xts,Yts] = meshgrid(lon4MOMts,lat_ts);
[Xuv,Yuv] = meshgrid(lon4MOMuv,lat_uv);

for iy=1997:1:1998
    iy
   fnin=['../1Extrp/CFSv1_1May' int2str(iy) '.Extrp'];
   ifnin=fopen(fnin,'r','b');
   fnout=['../2VlHsPol/CFSv1_1May' int2str(iy) '.HpolS']; 
   ifdout=fopen(fnout,'w','b');   
   for ik=1:40
       wk=fread(ifnin,[362,202],'float');
       aa_mod=interp2(Xts,Yts,wk',x_T,y_T,'spline');
       fwrite(ifdout,aa_mod','single'); 
   end
   for ik=1:40
       wk=fread(ifnin,[362,202],'float');
       aa_mod=interp2(Xts,Yts,wk'+35,x_T,y_T,'spline');
       fwrite(ifdout,aa_mod','single'); 
   end   
   for ik=1:40*2
       wk=fread(ifnin,[362,202],'float');
       aa_mod=interp2(Xuv,Yuv,wk',x_C,y_C,'spline');
       fwrite(ifdout,aa_mod','single');
   end
   fclose(ifdout);
end
