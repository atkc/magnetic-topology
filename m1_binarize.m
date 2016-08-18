%Description:
%This program produces a binarized image of a MFM image. There are 2 ways
%of threshold process - a global threshold value or a dynamic one. All input
%parameters are at the top. Please change the filename address accordingly.
%Also note that there are filters before (to smooth the iamge) and after
%(to get rid of non-skyrmions by circular metric and the size). The program
%lastly generates a mat (centroids) containing the approx mid points of each 
%potential skyrmion for fitting in m2*.m routine. 
%centroids = zeros(length(graindata),5); % [midx midy radius perimter roundness]

%**************************************************************************
%*****************************Inputs and parameters************************
%**************************************************************************

%%address to the image of interest
%filename='C:\Users\Anthony\Dropbox\Shared_MFM\DataAnalysis\Skyrmion Lattice\11d lattice\image 1\160517_x11d_n3k-p2k_sss.png'; %file directory
test_sample;
    %********Threshold options************
    threshmode=1; % 1: regular threhold, 2: Dynamic thresh
    
    %if option = 1:
    threshlevel =0.7; %this is for regular thresholding
    
    %if option = 2:
    adaptThreshArea =23; %this is for adaptivev threholding which requires an input area to thresh
    
    %********Pre-Filter Option(to smooth out image)*********
    
    filterArea =3; %area of filter (gaussian) (use odd number)
    filtermode='gaussian'; %shape of filer: 'disk' or 'gaussian'
    filterRepeat=9; % no of filter cycle
    
    %********Post-Filter Option 1(distinguish skyrmions lumped together)********* 
    erode=true; %for erosion of filtered binary image (essential to distinguish 2 multiple skyrmions lump together
    erodeSize=2;
    
    %********Post-Filter Option 2(remove strips)*********
    minD=5; %filter by parameter (not used)
    maxD=15;
    minPeri=2*pi*minD;
    maxPeri=2*pi*maxD;
    
    maxMetric=0.30; %circularity metric
    
    minSize=0.7; %filter by area
    maxSize=5;


%*************************************************************************
%*****************************Reading image file**************************
%*************************************************************************

    %im=imread(filename);
    %grayIm = rgb2gray(im);
    %grayIm = im(:,:,1); %BGR chanels, grayIm will be based on the red intensity of the original image
    %dgrayIm= double(grayIm); %matrix with double precision
    
    %resize image to 0-255 intensity, why? cos i like =D
    %dgrayIm=(dgrayIm-ones(size(dgrayIm))*min(min(dgrayIm)))*255/((max(max(dgrayIm)))-min(min(dgrayIm)));
    %dgrayIm=dgrayIm*255/max(max(dgrayIm));
    dgrayIm=test;

%*************************************************************************
%*****************************Pre-Filter process**************************
%*************************************************************************

    filIm=dgrayIm; %for filtering process
    


    for i=1:filterRepeat
         h = fspecial(filtermode,filterArea); %filter shape
         filIm=filter2(h, filIm); %filter
         %filIm=medfilt2(filIm,[filterArea filterArea]);%boxcar 
    end
    


%*************************************************************************
%************************Thresshold 1 (normal thresh)*********************
%*************************************************************************
    if threshmode==1
        if threshlevel==0
            threshlevel = multithresh(filIm/max(max(filIm))); %automatically detects the threshold value to use
        end
    
        binIm= im2bw(filIm/max(max(filIm)),threshlevel); %perform threhold with threshold value
        
        
    end

%*************************************************************************
%************************Threshold 2 (dynamic thresh)*********************
%*************************************************************************
    if threshmode==2
        binIm= adaptivethreshold(filIm,adaptThreshArea,1,0); %perform dynamic threhold with threshold area
    end
 
%*************************************************************************
%*****************************Post-Filter process 1***********************
%*************************************************************************
    if erode
        se = strel('disk',erodeSize);
        binIm=imerode(binIm,se);
    end
    %%*********fill the holes?*************
    binIm=imfill(binIm,'holes');

    
%*************************************************************************
%*****************************Segregate Area******************************
%*************************************************************************

    %%****segregate the patches*************
    cc=bwconncomp(binIm);
    graindata = regionprops(cc,'centroid','Area','Perimeter');
    
%     %%*****retrieve the area****************
    area=[graindata.Area];
    s=size(area);
    avgArea=sum(area)/s(2);
    
    %%*****retrieve the perimeter****************
    perimeter=[graindata.Perimeter]; 
    
    % compute the roundness metric
    roundness = 4*pi*area./perimeter.^2;

    
%*************************************************************************
%*****************************Post-filter 2*******************************
%option 1: removal by area
%option 2: removal by perimeter
%option 3: removal by circularity
%*************************************************************************

    %%******1: remove small/big areas *********
    index1=([graindata.Area]>minSize*avgArea);
    index2=([graindata.Area]<maxSize*avgArea);
    index= index1 & index2;
    graindata = graindata(index);
    roundness=roundness(index);
    cc.NumObjects=sum(index);%rearranging the indexes
    cc.PixelIdxList=cc.PixelIdxList(index);
    
%     %%******2: remove areas with min/max perimeter *********
%     index=((roundness>maxMetric).*([graindata.Perimeter]>minPeri).*([graindata.Perimeter]<maxPeri))>0; % retrival of index
%     sum(index)
%     graindata = graindata(index); %removal of graindata with peri < minPeri and >maxPeri
%     cc.NumObjects=sum(index);% Updating the number of objects left
%     cc.PixelIdxList=cc.PixelIdxList(index); % Updating the objects list
    
    %%******3: remove areas with high circularity metric *********
    index=(roundness>maxMetric);
    graindata = graindata(index);
    cc.NumObjects=sum(index);%rearranging the indexes
    cc.PixelIdxList=cc.PixelIdxList(index);

    labeled = labelmatrix(cc); %label the areas
    fbinIm=(labeled>0);%not necessary to see labels, just get final binary image =)
    
    centroids = zeros(length(graindata),5); % [midx midy radius perimter roundness]
    centroids(:,1:2)=cat(1,graindata.Centroid);
    centroids(:,3)=sqrt([graindata.Area]/pi());
    centroids(:,4)=[graindata.Perimeter];

        area=[graindata.Area];
        perimeter=[graindata.Perimeter]; 
        roundness = 4*pi*area./perimeter.^2;

    centroids(:,5)=roundness;

    
%*************************************************************************
%*****************************Get mask************************************
%not necessary: fitting will be done with centroids on the original image
%only
%*************************************************************************
% 
% fitIndex=binIm>0;%binary mask
% fitImage = dgrayIm*fitIndex; %image use for fit


%*************************************************************************
%*****************************Plot****************************************
%*************************************************************************
f=figure;
subplot(2,2,1), imshow(dgrayIm,[0,max(max(dgrayIm))])
subplot(2,2,2), imshow(filIm,[0,max(max(filIm))])
subplot(2,2,3), imshow(binIm,[0,max(max(binIm))])
subplot(2,2,4), imshow(fbinIm,[0,max(max(fbinIm))])

% gh=figure;
%     imshow(dgrayIm,[0,max(max(dgrayIm))])
%     for i = 1:length(centroids)
%         hold on
%         plot(centroids(i,1),centroids(i,2),'r.','MarkerSize',5);
%     end
% figure
% imshow(filIm,[0,max(max(filIm))]);
    
gg=figure;
    imshow(filIm,[0,max(max(filIm))]);
    [noOfCentriods,~]=size(centroids);
    for i = 1:noOfCentriods
        hold on
        plot(centroids(i,1),centroids(i,2),'r.','MarkerSize',5);
    end
figure;
    imshow(filIm,[0,max(max(filIm))]);
clearvars -except threshlevel dgrayIm centroids binIm isofit xyfit filIm test