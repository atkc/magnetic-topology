%%*****load image***********
%%***To be removed and amde into a function*****
%%Reference folder
%%cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\Reference images');
%fixed=imread('170308_fp226_1b_2_d2_n4k-p1k_p1_ref.tiff');
%fixedM=imread('170308_fp226_1b_2_d2_n4k-p1k_p1.tiff');
%%Data folder
cd('C:\Users\Anthony\Desktop\For hopin demo');
MFM=false;%true: activate transformation on mfm images
saveIm=true;
displayIm=false;
fixed=imread('170308_fp226_1b_2_d2_n4k-p1k_p1_AFM.tiff');
%fixedM=imread('170421_15k_1b_2um_d2_n4k-p1100_p0_MFM.tiff');
fixed=fixed(:,:,1);
% fixed=flipud(fixed);
% fixed=fliplr(fixed);
% fixed=double(im2bw(fixed));
%MFMfilename='170421_15k_1b_2um_d2_n4k-p1100_p';% no need 16 bit

AFMfilename='170415_fp226_1b_2um_d2_n3k-1200_p';%remember to save AFM in 16 bit!!!
%save as 170421_15k_1b_2um_d2_n4k-p1100_p1_MFM.tiff
tf=0;
for i= [17 18 19]%<-----insert pulse number here
    fprintf('Processing image %i...',i);
    moving=imread(strcat(AFMfilename,int2str(i),'_AFM.tiff'));
    moving=moving(:,:,1);
    %moving=double(im2bw(moving));

    %******TO show misalignment************
    %non-grayscale colour shows distinct difference in intensities****
    
    if (displayIm)
        figure;
        imshow(fixed);
        figure;
        imshow(moving);
        figure;
        imshowpair(fixed, moving,'Scaling','joint');
    end

    %******************************************
    %****Area based (intensity) registration***
    %******************************************

    %***Create optimizer and metric for
    [optimizer,metric] = imregconfig('monomodal');
    %metric = registration.metric.MattesMutualInformation; %slow but should
    %be more accurate
    %%----Need to read up on optimizer and metric--
    %%Needs to be tuned

    optimizer.MaximumIterations = 500;
    optimizer.MaximumStepLength = 0.005;

    %****Executing intensity based registration block**
    %movingReg = imregister(moving, fixed, 'affine', optimizer, metric);

    %% imregister uses imregtform to retrive the geometric transformation 
    %% Please use imregtform to retrieve the information
    tf=imregtform(moving, fixed, 'affine', optimizer, metric);

    movingReg=imwarp(moving,tf,'OutputView',imref2d(size(fixed)));
    
    if (displayIm)
 
        figure;
        imshowpair(fixed, movingReg,'Scaling','joint');
        figure;
        imshow(fixed);
        figure;
        imshow(movingReg);
    end
    
    imwrite(movingReg,strcat('Reg_',AFMfilename,int2str(i),'_MFM.tiff'))
    if (MFM)
        movingM=imread(strcat(MFMfilename,int2str(i),'_MFM.tiff'));
        movingMReg=imwarp(movingM,tf,'OutputView',imref2d(size(fixedM)));
    
        if (displayIm)
        figure;
        imshowpair(fixedM, movingMReg,'Scaling','joint');
        end
        
        if (saveIm)
        imwrite(movingMReg,strcat('Reg_',MFMfilename,int2str(i),'_MFM.tiff'))
        end
    end
    
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