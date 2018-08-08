
cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp553_nanostructures\180411-1a_fp553_1b_d2_2um_n4k-p1050\analysis_1050');
AFMfilename='180411_fp553_1b_d2_2um_p';
pulseID=fliplr([31:32]);
tf1=0;%local tf
tf2=affine2d();%compounding tf
for i= 2:length(pulseID)
    fprintf('Processing image %i...',i);
    fixed=imread(strcat(AFMfilename,int2str(pulseID(i-1)),'_MFM.tiff'));
    fixed=fixed(:,:,1);
    fixed = imresize(fixed,[256 256]);
    moving=imread(strcat(AFMfilename,int2str(pulseID(i)),'_MFM.tiff'));
    moving=moving(:,:,1);
    moving = imresize(moving,[256 256]);
    se = strel('square',10);
    
    %get silhouette of moving and fixed image
    fbinary = imbinarize(fixed,graythresh(fixed));
    fbinary = imfill(fbinary,'holes');%remove black pixels in BG
    fbinary = imerode(fbinary,se);%remove stripes
    fbinary =imdilate(fbinary,se);%patch erosion's damage
    fbinary=uint8(fbinary)*256;%prep for imreg
    
    mbinary = imbinarize(moving,graythresh(moving));
    mbinary = imfill(mbinary,'holes');
    mbinary = imerode(mbinary,se);
    mbinary =imdilate(mbinary,se);
    mbinary=uint8(mbinary)*256;

    %******************************************
    %****Area based (intensity) registration***
    %******************************************

    %***Create optimizer and metric for
    [optimizer,metric] = imregconfig('monomodal');
    %metric = registration.metric.MattesMutualInformation; %slow but should
    %be more accurate
    %%----Need to read up on optimizer and metric--
    %%Needs to be tuned

    optimizer.MaximumIterations = 5000;
    optimizer.MaximumStepLength = 0.001;

    %****Executing intensity based registration block**
    %movingReg = imregister(moving, fixed, 'affine', optimizer, metric);

    %% imregister uses imregtform to retrive the geometric transformation 
    %% Please use imregtform to retrieve the information
    %tformEstimate = imregcorr(mbinary, fbinary);
    tf1=imregtform(mbinary, fbinary, 'affine', optimizer, metric)%,'InitialTransformation',tformEstimate);
    %tf=imregtform(moving, fixed, 'affine', optimizer, metric);
    tf2.T=tf1.T*tf2.T;
    movingReg=imwarp(moving,tf2,'OutputView',imref2d(size(fixed)));
    

    imwrite(movingReg,strcat('Reg_',AFMfilename,int2str(pulseID(i)),'_MFM.tiff'))
    
    fprintf('completed!\n');
end
fprintf('\n');
% if (saveIm)
%     imwrite(fixed,strcat(MFMfilename,'1_AFM.tiff'))
%     if MFM
%         imwrite(fixedM,strcat(MFMfilename,'1_MFM.tiff'))
%     end
% end
%cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170418_fp226_wires\Registered MFM');

% %*****************2nd reg***************************************
% %*****************2nd reg***************************************
% %*****************2nd reg***************************************
% for i=(21:40)
%     fprintf('Processing image %i...',i);
%     moving=imread(strcat('reg_',AFMfilename,int2str(i),'_MFM.tiff'));
%     moving=moving(:,:,1);
%     %moving=double(im2bw(moving));
% 
%     %******TO show misalignment************
%     %non-grayscale colour shows distinct difference in intensities****
%       
%         movingMReg=imwarp(moving,tf,'OutputView',imref2d(size(fixed)));
%         
%         if (saveIm)
%         imwrite(movingMReg,strcat('Reg_Reg_',MFMfilename,int2str(i),'_MFM.tiff'))
%         end
%     
%     fprintf('completed!\n');
% end
% fprintf('\n');
% %*****************2nd reg***************************************
% %*****************2nd reg***************************************
% %*****************2nd reg***************************************