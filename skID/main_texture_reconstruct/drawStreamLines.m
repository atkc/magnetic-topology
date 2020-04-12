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

bx_mat=bx(imxrange,imyrange,:);
by_mat=by(imxrange,imyrange,:);
bz_mat=bz(imxrange,imyrange,:);

imbin=imbinarize(im_mat_l);
% imskel=bwskel(imbin);
% figure;surf(imskel*1);view(2);axis equal;shading flat
% %figure;imshow(imskel);

upres_scale=4;
im_upres1 = imresize(im_mat_l,upres_scale,'bicubic');
im_upres = imgaussfilt(imresize(im_mat_l,upres_scale,'bicubic'),6);
figure;imshow(im_upres);view(2);axis equal;shading flat
imbin_upres=imbinarize(im_upres);
figure;imshow(imbin_upres);view(2);axis equal;shading flat

bx_mat=imgaussfilt3(imresize3(bx_mat,upres_scale,'cubic'),6);
by_mat=imgaussfilt3(imresize3(by_mat,upres_scale,'cubic'),6);
bz_mat=imgaussfilt3(imresize3(bz_mat,upres_scale,'cubic'),6);

%%
% er_element = strel('disk',2,0);
% imbin_upres_er=imdilate(imbin_upres,er_element);
figure;imshow(imbin_upres);view(2);axis equal;shading flat

dil_element = strel('disk',9,0);
imbin_upres_dil=imdilate(imbin_upres,dil_element);
figure;imshow(imbin_upres_dil);view(2);axis equal;shading flat

imperim_dil=bwperim((imbin_upres_dil));
figure;imshow(imperim_dil);view(2);axis equal;shading flat
[yy_hold,xx_hold]=find(imperim_dil);

search_r=2;

searchi=1;
while ~isempty(yy_hold)
    yy(searchi)=yy_hold(1);
    xx(searchi)=xx_hold(1);
    removei=(pdist2([xx_hold(1),yy_hold(1)],[xx_hold,yy_hold])<=search_r);
    yy_hold(removei)=[];
    xx_hold(removei)=[];
    searchi=searchi+1;
end

[lx,ly,lz]=size(bx_mat);
[px,py,pz]=meshgrid(1:lx,1:ly,1:lz);
figure;
imshow(imbin_upres)
hold on;
hlines=streamline(px,py,pz,bx_mat,by_mat,bz_mat,xx,yy,1*ones(size(xx)));
set(hlines,'LineWidth',2,'Color','r')
view(2)

%%
blinesx=get(hlines,'XData');
blinesy=get(hlines,'YData');
blinesz=get(hlines,'ZData');

%%
len_blines=zeros([length(blinesx),1]);
for bi=1:length(blinesx)
    len_blines(bi)=length(blinesx{bi});
end
figure;
histogram(len_blines,1000)
lmin=median(len_blines)*0.3;
lmax=median(len_blines)*1.7;
len_blines(len_blines>lmax)=NaN;
len_blines(len_blines<lmin)=NaN;
figure;
histogram(len_blines,100)
figure;
hold on;

linei=0;
for bi=1:length(blinesx)
    if~isnan(len_blines(bi))
        plot(blinesx{bi},blinesy{bi},'r-')
        bdata=[blinesx{bi}',blinesy{bi}',blinesz{bi}'];
        bfile=strcat('bline',num2str(linei),'.txt');
        dlmwrite(bfile,bdata,'delimiter',' ');
        linei=linei+1;
    end
end