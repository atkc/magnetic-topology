function [ binIm1 ] = filIT( binIm,minSize,maxSize,c_th,e_th,imageSize,conn,pro)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    cc=bwconncomp(binIm,conn);
    graindata = regionprops(cc,'centroid','Area','PerimeterOld','MajorAxisLength','MinorAxisLength');
    
%     %%*****retrieve the area****************
    area=[graindata.Area];
    s=size(area);
    avgArea=sum(area)/s(2);
    size(graindata);
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
    c_th_1=c_th;
    %%******1: remove small/big areas *********
    minArea=pi*(length(binIm)*minSize/(imageSize*1000))^2;
    maxArea=pi*(length(binIm)*maxSize/(imageSize*1000))^2;
    index1=([graindata.Area]>minArea);%minSize*avgArea);
    index2=([graindata.Area]<maxArea);%maxSize*avgArea);
    index3=(roundness>c_th_1);
    index4=([graindata.MajorAxisLength]./[graindata.MinorAxisLength])<e_th;
    index= ((index1 & index2) & index3)& index4;
    graindata = graindata(index);
    roundness=roundness(index);
    cc.NumObjects=sum(index);%rearranging the indexes
    cc.PixelIdxList=cc.PixelIdxList(index);
   

    length(size(graindata));
    
    labeled1 = labelmatrix(cc); %label the areas
    binIm1=(labeled1>0);%not necessary to see labels, just get final binary image =)
    cell_rd=num2cell(roundness);
    [graindata.Roundness] = cell_rd{:};
    assignin('base',strcat('sk_data',num2str(pro)),graindata);
end

