function [ Gr,Gr_pbc,stdGr,stdGr_pbc,histox] = RDF2( pointsRDF,im,nSteps )
%RDF Summary of this function goes here2
%   Detailed explanation goes here

totalN_pbc=zeros(1,nSteps-1);
totalN=zeros(1,nSteps-1);
[m,n]=size(im);

%L1=sqrt((m/2)^2+(n/2)^2);
L1=sqrt((m)^2+(n)^2);

%[~,minInd]=min((pointsRDF(:,1)-m/2).^2+(pointsRDF(:,2)-n/2).^2);

edges=linspace(0,L1,nSteps);%x axis
dx=mean(diff(edges)); %dx
avgD=length(pointsRDF)/(m*n);% density (# of vortices/Total Area)

%%Inosov's RDF (no double counting)
% for pointA=1:(length(pointsRDF)-1)%round(length(points)/2):(round(length(points)/2)+10)
%     for pointB=pointA+1:length(pointsRDF)
%         
%         %a) not with periodic boundary condition
%         dr2 = pointsRDF(pointA,:) - pointsRDF(pointB,:); %vector dist
%         r2 = sqrt(sum(dot(dr2,dr2)));%distance between 2 points
%         if (r2 < L1)% do need such a condition?
%             addI=sum(edges<=r2); %index to add count +1
%             totalN(addI)=totalN(addI)+1; %add count +1
%         end
%         
%         %b) with periodic boundary condition
%         dr1 = distPBC2D(dr2,m,n); %vector dist
%         r1 = sqrt(sum(dot(dr1,dr1)));%distance between 2 points
%         if (r1 < L1)
%             addI=sum(edges<=r1); %index to add count +1
%             totalN_pbc(addI)=totalN_pbc(addI)+1; %add count +1
%         end
% 
%     end
% end

histox=edges(2:end)-mean(diff(edges));%x-axis
%count=0;%debug

%%Can Li's RDF (Double count)
for pointA=1:(length(pointsRDF))%round(length(points)/2):(round(length(points)/2)+10)
    for pointB=1:length(pointsRDF)
%         if pointB~=pointA%debug
%             count=count+1;
%         end
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
            
            addI=sum(edges<=r2);
            totalN(addI)=totalN(addI)+1;
        end

    end
end
%sum(totalN)%debug
%     localGr=zeros(1,length(localN));

%%***Calculation of RDF variants

%%Calculation of area for density function (needs rework  to account
%%properly)
localV=zeros(1,length(totalN_pbc));
for i=1:length(totalN_pbc)
   localV(i)=2*pi*edges(i+1)*dx;
end

avg_local_pbc=(totalN_pbc./localV);
avg_local=(totalN./localV);

%% standard def for g(R)
stdGr_pbc=avg_local_pbc/((length(pointsRDF))*avgD);
stdGr=avg_local/((length(pointsRDF))*avgD);
%%note: use pbc to account for area using simple relationship
%else wo pbc, local V is much invloved

%% g(R) as depeicted in can li's/Inosov's paper
Gr_pbc= totalN_pbc;
Gr= totalN;

Gr(1)=0;
Gr_pbc(1)=0;

end



