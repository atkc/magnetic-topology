function [ newCentroids, oldCentroids] = positionxy_v2( skim, col )
%POSITIONXY Summary of this function goes here
%   Detailed explanation goes here

skim_d= double(skim); %matrix with double precision

oldxyIm=((skim_d(:,:,1)==col(1)).*(skim_d(:,:,2)==col(2)).*(skim_d(:,:,3)==col(3)));

newxyIm=[0];%nothing for now =D
newCentroids=[];
if sum(sum(newxyIm))position
    %%****segregate the patches*************
    newcc=bwconncomp(newxyIm);
    newGraindata = regionprops(newcc,'centroid');
    newCentroids=cat(1,newGraindata.Centroid);
end
%%****segregate the patches*************
oldcc=bwconncomp(oldxyIm);
oldGraindata = regionprops(oldcc,'centroid');

oldCentroids=cat(1,oldGraindata.Centroid);
% imshow(skim)
% %imshow(oldxyIm,[min(min(oldxyIm)),max(max(oldxyIm))])
%     for i = 1:length(oldCentroids)
%         hold on
%         plot(oldCentroids(i,1),oldCentroids(i,2),'ro','MarkerSize',10);
%     end

end

 