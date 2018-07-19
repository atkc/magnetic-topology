function [ newCentroids, oldCentroids] = positionxy( skim )
%POSITIONXY Summary of this function goes here
%   Detailed explanation goes here
[~,~,numCh]=size(skim);
grayIm=skim;
if numCh>1
    grayIm = rgb2gray(grayIm);
    grayIm = skim(:,:,1); %BGR chanels, grayIm will be based on the red intensity of the original image
end 

dgrayIm= double(grayIm); %matrix with double precision
%imshow(dgrayIm)
%resize image to 0-255 intensity, why? cos i like =D
%dgrayIm=(dgrayIm-ones(size(dgrayIm))*min(min(dgrayIm)))*255/((max(max(dgrayIm)))-min(min(dgrayIm)));
%dgrayIm=dgrayIm*255/max(max(dgrayIm));
oldxyIm=(dgrayIm==0);
newxyIm=(dgrayIm==255);
newCentroids=[];
if sum(sum(newxyIm))
    %%****segregate the patches*************
    newcc=bwconncomp(newxyIm);
    newGraindata = regionprops(newcc,'centroid');
    newCentroids=cat(1,newGraindata.Centroid);
end
%%****segregate the patches*************
oldcc=bwconncomp(oldxyIm);
oldGraindata = regionprops(oldcc,'centroid');

oldCentroids=cat(1,oldGraindata.Centroid);
% imshow(dgrayIm,[0,max(max(dgrayIm))])
%     for i = 1:length(oldCentroids)
%         hold on
%         plot(oldCentroids(i,1),oldCentroids(i,2),'r.','MarkerSize',5);
%     end

end

 