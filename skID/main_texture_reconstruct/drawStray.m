
cd('C:\Users\ant_t\Desktop\mumax3.9c\mfm_mag_26t2\200114_26t2_recon\200114_26t2_10x10um_updown.out');
[bx,by,bz]=fovf('B_demag000000.ovf');
[mx,my,mz]=fovf('m000000.ovf');
bnorm=(bx.^2+by.^2+bz.^2).^0.5;
imxrange=30:100;%126:386;
imyrange=20:90;%256:768;
%************Gradient retrieval************
blayer=1;
im_mat=mz;
im_mat_l=im_mat(:,:,blayer);
im_mat_l=im_mat_l(imxrange,imyrange);

imbin=imbinarize(im_mat_l);
% imskel=bwskel(imbin);
% figure;surf(imskel*1);view(2);axis equal;shading flat
% %figure;imshow(imskel);



upres_scale=4;
im_upres = imgaussfilt(imresize(im_mat_l,upres_scale,'bicubic'),6);
figure;imshow(im_upres);view(2);axis equal;shading flat
imbin_upres=imbinarize(im_upres);
figure;imshow(imbin_upres);view(2);axis equal;shading flat
% im_dist = bwdist( imgaussfilt(imbin*1,10),'Euclidean');
% figure;surf(im_dist);view(2);axis equal;shading flat

[Gmag,Gdir] = imgradient(flipud(im_upres));
Gmag=flipud(Gmag);Gdir=flipud(Gdir);
figure;surf(Gdir);view(2);axis equal;shading flat
figure;surf(Gmag);view(2);axis equal;shading flat

%************Skeleton retrieval************
blayer=17;
im_mat=bnorm;
im_mat_l=im_mat(:,:,blayer);
im_mat_l=im_mat_l(imxrange,imyrange);

imbin=imbinarize(im_mat_l);
imskel=bwskel(imbin);
figure;surf(imskel*1);view(2);axis equal;shading flat
%[Gmag,Gdir]=imgradient(double(~imskel));


stray_w=8;
stray_r=4;
rho=(-stray_w/2:0.1:stray_w/2);
strayz=(stray_r^2-(rho).^2).^0.5;
rho=rho+1
%figure;plot(strayz)

implot=ones(size(Gdir))*NaN;
implot(imskel)=Gdir(imskel);
figure;surf(isnan(implot)*1);view(2);axis equal;shading flat
figure;surf(implot);view(2);axis equal;shading flat

imskel(1,:)=false;
imskel(length(imskel),:)=false;
imskel(:,length(imskel))=false;
imskel(:,1)=false;

[yy_hold,xx_hold]=find(bwperim(imbin_upres));
search_r=8;

searchi=1;
while ~isempty(yy_hold)
    yy(searchi)=yy_hold(1);
    xx(searchi)=xx_hold(1);
    removei=(pdist2([xx_hold(1),yy_hold(1)],[xx_hold,yy_hold])<=search_r);
    yy_hold(removei)=[];
    xx_hold(removei)=[];
    searchi=searchi+1;
end

numPts=length(yy);
len=length(xx);
% while (len>numPts)
%     randi=rand(size(xx));
%     xx=xx(randi>0.5);
%     yy=yy(randi>0.5);
%     len=length(xx);
% end
figure;
surf(imskel*1);view(2);axis equal;shading flat
colormap('gray')

removetol=0.2;
removedist1=removetol*length(imbin_upres);
removedist2=(1-removetol)*length(imbin_upres);

removei=yy>removedist2;
removei=removei+(yy<removedist1);
removei=removei+(xx>removedist2);
removei=removei+(xx<removedist1);
removei=(removei~=0);
xx(removei)=[];
yy(removei)=[];
%%
h=figure;
mag_mag=0.5;
surf(imgaussfilt((imbin_upres*2)-1,1)*-mag_mag,'FaceLighting','gouraud','FaceColor','interp',...
      'AmbientStrength',1); axis equal;shading interp
material dull
%surf(imgaussfilt((imbin_upres*2)-1,1)*0.1);axis equal;shading interp
cmap=[ones([900,1]),zeros([900,1]),zeros([900,1])];
cmap(1:100,:)=redblue(100);
colormap(cmap)
xyoffset=6;
ai=1;
for ni=1:1:length(xx)
    hold on
    yrange=(yy(ni)-1)*1+1:(yy(ni))*1;
    xrange=(xx(ni)-1)*1+1:(xx(ni))*1;
    Gmag_range=Gmag(yrange,xrange);
    Gmag_range=Gmag_range(:);
    Gdir_range=Gdir(yrange,xrange);    
    Gdir_range=Gdir_range(:);
    Gdir_range(Gdir_range<-90)=Gdir_range(Gdir_range<-90)+180;
    Gdir_range(Gdir_range>90)=Gdir_range(Gdir_range>90)-180;
    Gdir_sel=Gdir((yy(ni)-1)*1+1,(xx(ni)-1)*1+1);%sum(Gdir_range.*Gmag_range)/sum(Gmag_range);
    xtemp=(rho*(cos(Gdir_sel*pi/180))+(xx(ni)-1)*1+1);
    ytemp=(rho*(sin(Gdir_sel*pi/180))+(yy(ni)-1)*1+1);
    p=plot3(xtemp,ytemp,strayz*1.5,'w','linewidth',2);
    p.Color(4)=1;
    
    
    xq(ai)=xtemp(round(length(rho)/2))-cos(Gdir_sel*pi/180)*xyoffset;
    yq(ai)=ytemp(round(length(rho)/2))-sin(Gdir_sel*pi/180)*xyoffset;
    zq(ai)=max(strayz)*1.39;
    vq(ai)=cos(Gdir_sel*pi/180);
    uq(ai)=sin(Gdir_sel*pi/180);
    wq(ai)=0;
    ai=ai+1;
    %q.Color(4)=0.5;
end
q=quiver3d(xq,yq,zq,vq,uq,wq,[1 1 1],0.4,10);
q.FaceAlpha = 1;
l=light('Position',[0 0 1],'Style','infinite')
l.Position=[0.7 0.3 1.2]
axis off