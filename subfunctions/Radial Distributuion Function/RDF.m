function [ Gr ] = RDF( points,im,nSteps )
%RDF Summary of this function goes here
%   Detailed explanation goes here

totalCount=zeros(1,nSteps-1);
totalN=zeros(1,nSteps-1);
[m,n]=size(im);
L=sqrt(m^2+n^2);

edges=linspace(0,L,nSteps);
avgD=length(points)/(m*n);

for pointA=1:(length(points)-1)%round(length(points)/2):(round(length(points)/2)+10)
    for pointB=(pointA+1):length(points)
        dr = points(pointA,:) - points(pointB,:);
        dr = distPBC2D(dr,m,n);
        % Get the size of this distance vector
        r = sqrt(sum(dot(dr,dr)));
        
        % Add to g(r) if r is in the right range [0 L]

        if (r < L)
            addI=sum(edges<r);
            totalN(addI)=totalN(addI)+1;
        end

%     %%for verification
%     % figure;
%     % plot(points(:,1),points(:,2),'b.');
%     % hold on
%     % plot(midptX,midptY,'r.')
%     maxR=min([midptX,midptY,m-midptX,n-midptY]);
%     distXYr=sqrt((points(:,1)-midptX).^2+(points(:,2)-midptY).^2);
%     distXYr(pointA)=[];
%     distXYr_fil=distXYr(distXYr<maxR);
%     length(distXYr_fil)
%     [localN,~]=histcounts(distXYr_fil,edges);

%     
%     localGr=(localN./localV)/avgD;
%     
%     localCount=localGr>0;
%     totalCount=totalCount+localCount;
%     totalGr=totalGr+localGr;
    end
end

%     localGr=zeros(1,length(localN));
localV=zeros(1,length(totalN));
for i=1:length(totalN)
   localV(i)=pi*((edges(i+1))^2-(edges(i))^2);
end

Gr=2*(totalN./localV)/((length(points)-1)*avgD);
figure
bar(Gr(1:round(length(Gr)/1)));
end

