imfinal=zeros(256,256,1);
mask=double(ones(256,256,1));
cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170410_fp226_wires_hi-field\Registered MFM');
for p=[2 3 5 7]
    MFMfilename='reg_MFM_170410_fp226_1b_2um_d2_n4k-1350_';% no need 16 bit
    moving=imread(strcat(MFMfilename,int2str(p),'.tiff'));
    j=imadjust(double(moving(:,:,1)));
    imfinal=(imfinal)+double(moving(:,:,1));
    
end

cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170410_fp226_wires_hi-field\Registered AFM');
for j=[2 3 5 7]
    AFMfilename='reg_AFM_170410_fp226_1b_2um_d2_n4k-1350_';% no need 16 bit
    im1=double(imread(strcat(AFMfilename,int2str(j),'.tiff')));

    im1=im1*255/max(max(im1));
%     figure
%     imshow(im1>100);
%     figure
    mask=mask.*(im1>100);
%     imshow(mask)
end
figure
imshow(mask);
impin=imfinal.*double(mask);
imshow(impin,[300,480])
histogram(impin)