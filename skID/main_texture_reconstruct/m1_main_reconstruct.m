helicity=pi;%helicity_y: 0 (right neel),pi (left neel), pi/2 (bloch CW),-pi/2 (bloch (CCW)
filename='Image0011_10x10_btm_right';
ext='.png';
filepath='C:\Users\ant_t\OneDrive\scanning_magnetometry\SG_skyrmion_collab\26t2\200129_26t2\';
rawIm=imread([filepath filename ext]);

domainWallSize=55;%px (use odd please)
domainSize=4;%px (use even please)
profile_size=domainWallSize+domainSize;%px
grid_xy_size=256;
grd_z_size=128;
eff_z=14;

InvertInd = 0;
if InvertInd
    rawIm = imcomplement(rawIm);
end
figure
imshow(rawIm)
im_length=grid_xy_size;
rawIm = imresize(rawIm,im_length/length(rawIm),'bicubic');
figure
imshow(rawIm);
threshOpt=1; %1:global 2: adaptive
threshVal=0.57; %0 if otsu method
adaptArea=0; % only for adaptive threshold mode
erodeSize=0; %erosion size (px)
filRpt=0; %filter repetition
filSize=0; %filter size (px)
minSize=0; %filter centroids based on size (nm)
maxSize=100000; %filter centroids based on size (nm)
c_th=0; %filter centroids based on circularity 
e_th=0; %filter centroids based on eccentricity
imageSize=10; %for gauging size filter (um)
connect=8; %connectivity for bwconncomp (4 or 8 for 2d)
chop=0; %1: watershed method to dislocate misIDed blobs
%rawIm = imgaussfilt(rawIm,4);

[dgrayIm, filIm, binIm1, binIm2, binIm3, centroids,threshVal]=m1_binarize(rawIm,threshOpt,threshVal,adaptArea,erodeSize,filRpt,filSize,minSize,maxSize,c_th,e_th,imageSize,connect,chop);
se = strel('square',1);
binIm_hole =imdilate(binIm1,se);
binIm_hole =imerode(binIm_hole,se);
binIm_hole=imcomplement(binIm_hole);
%binIm_hole=imfill(binIm_hole,'holes');
%binIm_hole=imcomplement(binIm_hole);


figure;
imshow(flipud(binIm1));
figure; 
imshow(flipud(binIm_hole));

binIm1=binIm_hole;

im_skel=bwskel(binIm1);


%******Skeleton pruning *********************
prun_length=25;
brPts =  bwmorph(im_skel,'branchpoints');
[enPti,enPtj] = find(bwmorph(im_skel,'endpoints'));
distgeo = bwdistgeodesic(im_skel,find(brPts),'quasi');
imshow(flipud(im_skel));
for n = 1:numel(enPti)
    text(enPtj(n),enPti(n),[num2str(distgeo(enPti(n),enPtj(n)))],'color','g');
end

im_skel2=im_skel;
br=bwconncomp(im_skel-brPts,8);
for br_i=1:length(br.PixelIdxList)
    temp_pts=br.PixelIdxList{br_i};
    if length(temp_pts)<prun_length
        im_skel2(temp_pts)=0;
    end
end

figure;
subplot(2,1,1)
imshow(flipud(im_skel));
title('before pruning')
subplot(2,1,2)
imshow(flipud(im_skel2));
title('after pruning')
im_skel=im_skel2;
%******Skeleton pruning *********************


im_weight=zeros(size(dgrayIm));
[p_x,p_y,p_z,p_weight]=s1_gen_basic_profile(0,helicity,domainSize,profile_size);
plot_rgb_vec(p_x,p_y,p_z);

figure;
subplot(1,2,1);
imshow(flipud(p_x),[-1,1]);
title('B_x component')
colorbar;
subplot(1,2,2);
imshow(flipud(p_y),[-1,1]);
title('B_y component')
colorbar;
[imx,imy,imc]=sum_profile(im_skel,p_x,p_y);
%imx=imx./imc;

% [imy,imc]=sum_profile(im_skel,p_y);
%imy=imy./imc;

im_phi = atan2(imy,imx);%can try to average the gradient

im_dist = bwdist(im_skel,'Euclidean');
[Gmag,Gdir] = imgradient(im_dist);
[imx2,imy2,imz2,im_weight]=s3_recon_profile_2(0,pi,domainSize,domainWallSize,im_dist,Gdir);
plot_rgb_vec(imx2,imy2,imz2);

% imx3=imgaussfilt(imx2,1);
% imy3=imgaussfilt(imy2,1);
% imz3=imgaussfilt(imz2,1);

[tempx,tempy] = pol2cart(Gdir*pi/180,1);
tempx=imgaussfilt(tempx,2);
tempy=imgaussfilt(tempy,2);
[Gdir2,~] = cart2pol(tempx,tempy);
im_dist2=imgaussfilt(double(im_dist),2);
[imx3,imy3,imz3,im_weight]=s3_recon_profile_2(0,pi,domainSize,domainWallSize,im_dist2,Gdir2*180/pi);

plot_rgb_vec(imx3,imy3,imz3);
[Gmag,Gdir] = imgradient(imx,imy);

[imx,imy,imz]=s2_recon_profile(im_dist,im_phi,profile_size,domainWallSize);

imzBi=double(binIm_hole)*2-1;
imxBi=zeros(size(imzBi));
imyBi=zeros(size(imzBi));

figure;imshow(imz,[min(imz(:)),max(imz(:))]);
title('mz');
colormap(redblue);
colorbar;
figure;imshow(imx,[min(imx(:)),max(imx(:))]);
title('mx');
colormap(redblue);
colorbar;
figure;imshow(imy,[min(imy(:)),max(imy(:))]);
title('my');
colormap(redblue);
colorbar;

plot_rgb_vec(imx,imy,imz);
plot_rgb_vec(imxBi,imyBi,imzBi);

ovf_filename=strcat(filename,'.ovf');
m2_convet2mumax(ovf_filename,grid_xy_size,grd_z_size,eff_z,imxBi,imyBi,imzBi,0,0,0)
% imy_avg=imgaussfilt(imy,5);
% imx_avg=imgaussfilt(imx,5);
% imz_avg=imgaussfilt(imx,5);
% 
% figure;imshow(imz_avg,[min(imz_avg(:)),max(imz_avg(:))]);
% title('mz');
% colormap(redblue);
% colorbar;
% figure;imshow(imx_avg,[min(imx_avg(:)),max(imx_avg(:))]);
% title('mx');
% colormap(redblue);
% colorbar;
% figure;imshow(imy_avg,[min(imy_avg(:)),max(imy_avg(:))]);
% title('my');
% colormap(redblue);
% colorbar;