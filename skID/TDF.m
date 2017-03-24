function [ TDFdata,ADFdata, histoTheta] = TDF( pointsRDF )
%RDF Summary of this function goes here2
%   Detailed explanation goes here
TDFdata=zeros(100000000,2);
histoTheta=((0:5:360)/360)*(2*pi);

R1=19;
dR=R1*(1.7407-1)/(1.7407+1);
threshL=R1+dR;
 %for threshL=linspace(R1,R1+2*dR,30);
TDFi=0;
for pointA=1:(length(pointsRDF))%round(length(points)/2):(round(length(points)/2)+10)
    for pointB=1:(length(pointsRDF))
        r1=99;
        if pointA~=pointB
            dr = pointsRDF(pointA,:) - pointsRDF(pointB,:);
            r1 = sqrt(sum(dot(dr,dr)));
            if (r1 < threshL)
                for pointC=1:(length(pointsRDF))
                    if (pointA~=pointB)&&(pointA~=pointC)&&(pointB~=pointC)
                        TDFi=TDFi+1;
                        v1=pointsRDF(pointB,:) - pointsRDF(pointA,:);
                        v2=pointsRDF(pointC,:) - pointsRDF(pointA,:);
                        r2 = sqrt(sum(dot(v2,v2)));
                        CosTheta = dot(v1,v2)/(norm(v1)*norm(v2));
                        ThetaInDegrees = acos(CosTheta);
                        TDFdata(TDFi,1)=ThetaInDegrees;
                        TDFdata(TDFi,2)=r2;
                        
                    end
                    
                end

            end
            
        end


    end
end

TDFdata=[TDFdata(1:TDFi,:);[-TDFdata(1:TDFi,1),(TDFdata(1:TDFi,2))]];
figure
polar(TDFdata(:,1),TDFdata(:,2),'.');
title('Triple Distribution Function');
for threshL=linspace(R1,R1+2*dR,50)
%for threshL=R1+23*2*dR/50
ADFdata=TDFdata(TDFdata(:,2)<1.5*threshL,:);
% figure
% polar(ADFdata(:,1),ADFdata(:,2),'.');
figure
rose(ADFdata(:,1),72)
title('Angular Distribution Function');
threshL
end





