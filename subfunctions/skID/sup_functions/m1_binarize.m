function [dgrayIm, filIm, binIm1, binIm2 ,binIm3, centroids,threshVal]= m1_binarize (im,threshmode,threshlevel,adaptThreshArea,erodeSize,filterRepeat,filterArea,minSize,maxSize,c_th,e_th,imageSize,conn)

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

%filename='C:\Users\Anthony\Documents\Matlab\magnetic_topology\skImReg\170308_fp226_1b_2_d2_n4k-p1k_p1.tiff';%'C:\Users\Anthony\Desktop\LTEM-11b-tilt\11 b+20deg.tiff'; %file directory

    %********Threshold options************
    %threshmode=2; % 1: regular threhold, 2: Dynamic thresh
    
    %if option = 1:
    %threshlevel =0; %this is for regular thresholding
    
    %if option = 2:
    %adaptThreshArea =7; %this is for adaptivev threholding which requires an input area to thresh
    
    %********Pre-Filter Option(to smooth out image)*********
    
    
    if erodeSize>0
        erode=true; %for erosion 
    else
        erode=false; %for erosion 
    end
    %erodeSize=1;
    
    %filterArea =10; %area of filter (gaussian) (use odd number)
    filtermode='gaussian'; %shape of filer: 'disk' or 'gaussian'
    %filterRepeat=0; % no of filter cycle
    %********Post Filter Option 1(smoothen binary image after thresh)*********
    
    %********Post-Filter Option 2(remove strips)*********
    minD=0;
    maxD=30;
    minPeri=2*pi*minD;
    maxPeri=2*pi*maxD;
    
    c_th_1=c_th; %circularity index 1
    c_th_2=0.38; %circularity index 2
    %minSize=0;
    %maxSize=30;


%*************************************************************************
%*****************************Reading image file**************************
%*************************************************************************

    %im=imread(filename);
    %grayIm = rgb2gray(im);
    grayIm = im(:,:,1); %BGR chanels, grayIm will be based on the red intensity of the original image
    dgrayIm= double(grayIm); %matrix with double precision
    
    %resize image to 0-255 intensity, why? cos i like =D
    %dgrayIm=(dgrayIm-ones(size(dgrayIm))*min(min(dgrayIm)))*255/((max(max(dgrayIm)))-min(min(dgrayIm)));
    dgrayIm=dgrayIm*255/max(max(dgrayIm));
    
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
        threshVal=threshlevel;
        binIm= im2bw(filIm/max(max(filIm)),threshlevel); %perform threhold with threshold value
%         figure
%         imshow(binIm)
    end

%*************************************************************************
%************************Threshold 2 (dynamic thresh)*********************
%*************************************************************************
    if threshmode==2
        binIm= adaptivethreshold(filIm,adaptThreshArea,1,0); %perform dynamic threhold with threshold area
    end
%imshow(binIm)
%*************************************************************************
%*****************************Post-Filter process 1***********************
%*************************************************************************
    if erode
        %erode
        se = strel('disk',erodeSize);
        binIm=imerode(binIm,se);
    end
    %%*********fill the holes?*************
    %binIm=imfill(binIm,'holes');
% figure
% imshow(binIm)
    
%*************************************************************************
%*****************************Segregate Area******************************
%*************************************************************************
    binIm = imfill(binIm,'holes');
    %%****segregate the patches*************
    %binIm=chopIT(binIm);
    cc=bwconncomp(binIm,conn);
    graindata = regionprops(cc,'centroid','Area','PerimeterOld','MajorAxisLength','MinorAxisLength');
    
%     %%*****retrieve the area****************
    area=[graindata.Area];
    s=size(area);
    avgArea=median(area);
    %%*****retrieve the perimeter****************
    perimeter=[graindata.PerimeterOld]; %not good for roundness (too much approx)
    %perimeter=Peri_noob(cc,size(binIm));
    % compute the roundness metric
    roundness = 4*pi*(area./(perimeter.^2));
    
    
    
%*************************************************************************
%*****************************Post-filter 2*******************************
%option 1: removal by area
%option 2: removal by perimeter
%option 3: removal by circularity
%*************************************************************************

    %%******1: remove small/big areas *********
    minArea=pi*(length(im)*minSize/(imageSize*1000))^2;
    maxArea=pi*(length(im)*maxSize/(imageSize*1000))^2;
    index1=([graindata.Area]>minArea);%minSize*avgArea);
    index2=([graindata.Area]<maxArea);%maxSize*avgArea);
    %index3=(roundness>c_th_1);
    index= (index1 & index2);
    graindata1 = graindata(index);
    
    index4=([graindata.Area]<(6*(minArea+maxArea)/2));
    graindata2 = graindata((~index2)&(index4));
    roundness=roundness(index);
%     cc.NumObjects=sum(index);%rearranging the indexes
%     cc.PixelIdxList=cc.PixelIdxList(index);
    
    
%     %%******2: remove areas with min/max perimeter *********
%     index=((roundness>maxMetric).*([graindata.Perimeter]>minPeri).*([graindata.Perimeter]<maxPeri))>0; % retrival of index
%     sum(index)
%     graindata = graindata(index); %removal of graindata with peri < minPeri and >maxPeri
%     cc.NumObjects=sum(index);% Updating the number of objects left
%     cc.PixelIdxList=cc.PixelIdxList(index); % Updating the objects list
    
    %%******3: remove areas with high circularity metric *********
%     index1=(roundness>c_th_1);
%     index2=logical((roundness<c_th_1).*(roundness>c_th_2));
%     index3=(roundness<c_th_2);
%     
%     graindata3 = graindata(index3); %ee
%     graindata2 = graindata(index2); %dd
%     graindata = graindata(index1);

%     ee.Connectivity=cc.Connectivity;
%     ee.ImageSize=cc.ImageSize;
%     ee.NumObjects=sum(index3);%rearranging the indexes
%     ee.PixelIdxList=cc.PixelIdxList(index3);
    
    dd.Connectivity=cc.Connectivity;
    dd.ImageSize=cc.ImageSize;
    dd.NumObjects=sum((~index2)&index4);%rearranging the indexes
    dd.PixelIdxList=cc.PixelIdxList((~index2)&index4);
    
    ee.Connectivity=cc.Connectivity;
    ee.ImageSize=cc.ImageSize;
    ee.NumObjects=sum((~index4));%rearranging the indexes
    ee.PixelIdxList=cc.PixelIdxList((~index4));    
    
    cc.NumObjects=sum(index);%rearranging the indexes
    cc.PixelIdxList=cc.PixelIdxList(index);
    length(size(graindata));

%     labeled3 = labelmatrix(ee); %label the areas
%     binIm3=(labeled3>0);%not necessary to see labels, just get final binary image =)
    
    labeled2 = labelmatrix(dd); %label the areas
    labeled3 = labelmatrix(ee); %label the areas
    
    binIm2=(labeled2>0);%not necessary to see labels, just get final binary image =)
    binIm3=(labeled3>0);
    labeled1 = labelmatrix(cc); %label the areas
    binIm1=(labeled1>0);%not necessary to see labels, just get final binary image =)
    
    centroids = zeros(length(graindata1),5); % [midx midy radius perimter roundness]
    
    
    
    if (length(graindata)>1)
        
        centroids(:,1:2)=cat(1,graindata1.Centroid);
        centroids(:,3)=sqrt([graindata1.Area]/pi());
        centroids(:,4)=[graindata1.PerimeterOld];

        area=[graindata1.Area];
        perimeter=[graindata1.PerimeterOld]; 
        roundness = 4*pi*area./perimeter.^2;
        centroids(:,5)=roundness;
    end

    
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
% f=figure;
% subplot(2,2,1), imshow(dgrayIm,[0,max(max(dgrayIm))])
% subplot(2,2,2), imshow(filIm,[0,max(max(filIm))])
% subplot(2,2,3), imshow(binIm,[0,max(max(binIm))])
% subplot(2,2,4), imshow(fbinIm,[0,max(max(fbinIm))])

% gh=figure;
%     imshow(dgrayIm,[0,max(max(dgrayIm))])
%     for i = 1:length(centroids)
%         hold on
%         plot(centroids(i,1),centroids(i,2),'r.','MarkerSize',5);
%     end
% figure
% imshow(filIm,[0,max(max(filIm))]);
    
% gg=figure;
%     imshow(filIm,[0,max(max(filIm))]);
%     [noOfCentriods,~]=size(centroids);
%     for i = 1:noOfCentriods
%         hold on
%         plot(centroids(i,1),centroids(i,2),'r.','MarkerSize',5);
%     end
% figure;
%     imshow(filIm,[0,max(max(filIm))]);
clearvars -except threshlevel dgrayIm centroids binIm isofit xyfit filIm binIm1 binIm2 binIm3 threshVal
end