
filename='170308_fp226_1b_2_d2_n4k-p1k_p';
imfinal=zeros(256,256,3);
mask=ones(256,256);
cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170308_fp226_wires\registered_MFM');
for p=1:22
    filename1=strcat(filename,int2str(p),'_MFM.tiff');
    filename2=strcat(filename,int2str(p+1),'_MFM.tiff');
    
    im1=imread(filename1);
    im2=imread(filename2);
    
    imdif=(double(im2)-double(im1)).^2;
    imfinal=imfinal+double(imdif);
    
end


cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170308_fp226_wires\registered_AFM');
for p=1:23
    filename1=strcat(filename,int2str(p),'_AFM.tiff');
    
    im1=double(imread(filename1));
    im1=im1*255/max(max(im1));
%     figure
%     imshow(im1>100);
    mask=mask.*(im1>100);
    
end

cd('C:\Users\Anthony\Documents\Matlab\magnetic_topology\motion_detection');
immotion=sqrt(imfinal(:,:,1).*mask);
immotion(immotion==0)=nan;
histogram(immotion);
%imshow(immotion,[0,100]);
h = fspecial('disk',1); %filter shape
         filIm=filter2(h, immotion); %filter
         
obs=double(filIm>65);
obs_m=zeros(size(im1));

    obs_m(:,:,1)=obs;
    obs_m(:,:,2)=obs;
    obs_m(:,:,3)=obs;
imshow(obs_m)
cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170308_fp226_wires\registered_MFM');
for p=1:23
    filename1=strcat(filename,int2str(p),'_MFM.tiff');
    
    im1=imread(filename1);
    im1_ad=im1.*uint8(obs_m);
    imwrite(im1_ad,strcat(filename,int2str(p),'_MFM_adj.tiff'));
end
