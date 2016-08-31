function [ Gr ] = RDF( points,im,nSteps )
%RDF Summary of this function goes here
%   Detailed explanation goes here

totalCount=zeros(1,nSteps-1);
totalGr=zeros(1,nSteps-1);
[m,n]=size(im);

edges=linspace(0,(m/2),nSteps);
avgD=length(points)/(m*n);
for pointsI=1:length(points)%round(length(points)/2):(round(length(points)/2)+10)
    midptX=points(pointsI,1);
    midptY=points(pointsI,2);

    %%for verification
    % figure;
    % plot(points(:,1),points(:,2),'b.');
    % hold on
    % plot(midptX,midptY,'r.')
    maxR=min([midptX,midptY,m-midptX,n-midptY]);
    distXYr=sqrt((points(:,1)-midptX).^2+(points(:,2)-midptY).^2);
    distXYr(pointsI)=[];
    distXYr_fil=distXYr(distXYr<maxR);


    [localN,~]=histcounts(distXYr_fil,edges);
    localGr=zeros(1,length(localN));

    for i=1:length(localN)
        localV=pi*((edges(i+1))^2-(edges(i))^2);
        localD=localN(i)/localV;
        localGr(i)=localD/avgD;
    end
    localCount=localGr>0;
    totalCount=totalCount+localCount;
    totalGr=totalGr+localGr;
end

Gr=totalGr./totalCount;
bar(Gr(1:round(length(Gr)/12)));
end

