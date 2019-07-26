bx=load('Bfield_20_Bx.txt');
by=load('Bfield_20_By.txt');
bz=load('Bfield_20_Bz.txt');
qim=load('results\nvtheta_54.7_nvphi_0.0\height_20\bnorm_0.0mT\quenchingmap_phi0.0deg_theta90deg_norm0.0mT.txt');
[~,name] = fileparts(pwd);
expression = '(\d*)+nm';
l_nm = regexp(name,expression,'match');
l=regexp(l_nm,'(\d*)','match');
l=str2double(cell2mat(l{1}));
stepsize=l/length(bx);
xvec=0:stepsize:l-stepsize;
%stray field vector imagpe
figure;
subplot(2,3,1)
plot_rgb_vec(bx,by,bz,stepsize);
axis equal
title('strayfield vector plot')
colorbar;
xlim([0,l])
ylim([0,l])
xlabel('nm')
ylabel('nm')

subplot(2,3,2)
bnom=(bx.^2+by.^2+bz.^2).^0.5;
surf(xvec,xvec,bnom)
view(2)
shading interp
colormap('gray');
colorbar;
axis equal
title('strayfield norm (mT)')
xlim([0,l])
ylim([0,l])
xlabel('nm')
ylabel('nm')

NVtheta=144.7*pi/180;
NVphi=0*pi/180;
[NVvec1,NVvec2,NVvec3] = sph2cart(NVphi,NVtheta,1);
bvec=cat(3,bx,by,bz);
NVvec=zeros(size(bvec));
NVvec(:,:,1)=NVvec1;
NVvec(:,:,2)=NVvec2;
NVvec(:,:,3)=NVvec3;
bnormal_vec=cross(NVvec,bvec,3);
bnormal=(bnormal_vec(:,:,1).^2+bnormal_vec(:,:,2).^2+bnormal_vec(:,:,3).^2).^0.5;
subplot(2,3,4)
surf(xvec,xvec,bnormal)
view(2)
shading interp
colormap('gray');
colorbar;
axis equal;
title('strayfield normal to nv axis (mT)')
xlim([0,l])
ylim([0,l])
xlabel('nm')
ylabel('nm')

bprallel=abs(dot(NVvec,bvec,3));
subplot(2,3,5)
surf(xvec,xvec,bprallel)
view(2)
shading interp
colormap('gray');
colorbar;
axis equal;
title('strayfield prallel to nv axis (mT)')
xlim([0,l])
ylim([0,l])
xlabel('nm')
ylabel('nm')

subplot(2,3,6)
surf(xvec,xvec,qim)
view(2)
shading interp
colormap('gray');
colorbar;
axis equal;
title('quench image (cts)')
xlim([0,l])
ylim([0,l])
xlabel('nm')
ylabel('nm')

set(gcf,'Position',[1 401 1280 603])
saveas(gcf,'summary.png')

imdiv=atan(bprallel./bnormal);
a=mean(imdiv(:));
aa=std(imdiv(:));
surf(fliplr(imdiv));view(2)
axis equal
shading interp
%caxis([-pi/2,pi/2])
colormap('gray')

figure;surf(fliplr(atan(qim)));view(2)
axis equal
shading interp
%caxis([-pi/2,pi/2])
colormap('gray')

angle_folder='C:\Users\Anthony\Desktop\mumax3.8\quench_something_sims\simpleSK_384x384nm_leftneel_252nm_30nm\simpleSK_384x384nm_leftneel_10rpts_0.9.out\results\nvtheta_54.7_nvphi_0.0\height_20\bnorm_20.0mT';
cd(angle_folder);
angle_files=dir;
im=load(angle_files(3).name);
angles=zeros(length(angle_files)-2,1);
expression = '(\d*..\d+deg)';
im_mat=zeros(length(angle_files)-2,length(im),length(im));
for i = 1:length(angle_files)-2
       
    a = regexp(angle_files(i+2).name ,expression,'match');
    len=regexp(a,'(\d*..\d)','match');
    angles(i)=str2double(cell2mat(len{1}));
    
end

[angles_sort,sort_i]=sort(angles);

figure;
ai = (2:2:length(angles)-2);
for i = 1:length(ai)
    im=load(angle_files(sort_i(ai(i))+2).name);
    subplot(2,4,i);
    surf(xvec,xvec,im)
    view(2)
    shading interp
    colormap('gray');
    colorbar;
    axis equal;
    title(strcat('bias field @ phi=',num2str(angles_sort(ai(i))),'deg'))
    xlim([0,l])
    ylim([0,l])
    xlabel('nm')
    ylabel('nm')
end
set(gcf,'Position',[1 41 1920 963])
saveas(gcf,'summary.png')