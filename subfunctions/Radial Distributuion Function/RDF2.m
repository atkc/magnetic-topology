function [ totalN,totalN_pbc,clGr, clGr_pbc,Gr, histox] = RDF2( pointsRDF,im,nSteps )
%RDF Summary of this function goes here2
%   Detailed explanation goes here

totalN_pbc=zeros(1,nSteps-1);
totalN=zeros(1,nSteps-1);
[m,n]=size(im);

L=sqrt((m/2)^2+(n/2)^2);
L1=L;

%[~,minInd]=min((pointsRDF(:,1)-m/2).^2+(pointsRDF(:,2)-n/2).^2);

edges=linspace(0,L1,nSteps);
dx=mean(diff(edges));
avgD=length(pointsRDF)/(m*n);

for pointA=1:(length(pointsRDF)-1)%round(length(points)/2):(round(length(points)/2)+10)
    for pointB=pointA+1:length(pointsRDF)
        dr = pointsRDF(pointA,:) - pointsRDF(pointB,:);
        r2 = sqrt(sum(dot(dr,dr)));
        
        dr = distPBC2D(dr,m,n);
        % Get the size of this distance vector
        r1 = sqrt(sum(dot(dr,dr)));
        
        % Add to g(r) if r is in the right range [0 L]

        if (r1 < L1)
            addI=sum(edges<=r1);
            totalN_pbc(addI)=totalN_pbc(addI)+1;
        end
        
        
        if (r2 < L1)
            addI=sum(edges<=r1);
            totalN(addI)=totalN(addI)+1;
        end

    end
end

%     localGr=zeros(1,length(localN));
localV=zeros(1,length(totalN_pbc));
for i=1:length(totalN_pbc)
   localV(i)=2*pi*edges(i)*dx;
end

avg_localp_pbc=(totalN_pbc./localV)/length(pointsRDF);
avg_localp=(totalN./localV)/length(pointsRDF);

clGr_pbc= 2*pi.*edges(1:end-1).*avg_localp_pbc;% g(R) as depeicted in can li's paper
clGr= 2*pi.*edges(1:end-1).*avg_localp;
Gr=2*(totalN_pbc./localV)/((length(pointsRDF)-1)*avgD);% standard def for g(R)

histox=edges(2:end)-mean(diff(edges));%x-axis

% figure
% bar(histox,reduce_Gr(1:round(length(Gr)/1)));
% axis([0 300 -500 500])
% figure
% plot(histox,reduce_Gr(1:round(length(Gr)/1)));
% axis([0 300 -500 500])
% figure
% bar(histox,Gr(1:round(length(Gr)/1)));

%axis([0 120 0 1.6]);
end



