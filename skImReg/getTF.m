%%*****load image***********
%%***To be removed and amde into a function*****

fixed=imread('corr_p1.tiff');
fixedM=imread('170308_fp226_1b_2_d2_n4k-p1k_p1.tiff');

MFM=true;%true: activate transformation on mfm images
saveIm=true;
displayIm=false;

MFMfilename='170308_fp226_1b_2_d2_n4k-p1k_p';
AFMfilename='corr_p';
numIm=22; %Number of images to align
for i=2:(numIm+1)
    fprintf('Processing image %i...',i);
    moving=imread(strcat(AFMfilename,int2str(i),'.tiff'));
    movingM=imread(strcat(MFMfilename,int2str(i),'.tiff'));

    %******TO show misalignment************
    %non-grayscale colour shows distinct difference in intensities****
    if (displayIm)
        figure;
        imshowpair(fixed, moving,'Scaling','joint');
    end

    %******************************************
    %****Area based (intensity) registration***
    %******************************************

    %***Create optimizer and metric for
    [optimizer, metric] = imregconfig('monomodal');
    %%----Need to read up on optimizer and metric--
    %%Needs to be tuned

    optimizer.MaximumIterations = 500;


    %****Executing intensity based registration block**
    %movingReg = imregister(moving, fixed, 'affine', optimizer, metric);

    %% imregister uses imregtform to retrive the geometric transformation 
    %% Please use imregtform to retrieve the information
    tf=imregtform(moving, fixed, 'affine', optimizer, metric);

    movingReg=imwarp(moving,tf,'OutputView',imref2d(size(fixed)));
    
    if (displayIm)
        figure;
        imshowpair(fixed, movingReg,'Scaling','joint');
    end
    
    imwrite(movingReg,strcat(MFMfilename,int2str(i),'_AFM.tiff'))
    if (MFM)
        movingMReg=imwarp(movingM,tf,'OutputView',imref2d(size(fixedM)));
    
        if (displayIm)
        figure;
        imshowpair(fixedM, movingMReg,'Scaling','joint');
        end
        
        if (saveIm)
        imwrite(movingMReg,strcat(MFMfilename,int2str(i),'_MFM.tiff'))
        end
    end
    
    fprintf('completed!\n');
end
fprintf('\n');
if (saveIm)
    imwrite(fixed,strcat(MFMfilename,'1_AFM.tiff'))
    imwrite(fixedM,strcat(MFMfilename,'1_MFM.tiff'))
end