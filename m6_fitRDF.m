clGr2_pbcT=[];
clGr_T=[];
numStep=70;
for numi=1:numImage
    if numi==1
        [clGr,~,clGr2,clGr2_pbc,~,histox]=RDF2(point1,dgrayIm,numStep);
    elseif numi==2
        [clGr,~,clGr2,clGr2_pbc,~,histox]=RDF2(point2,dgrayIm,numStep);
    elseif numi==3
        [clGr,~,clGr2,clGr2_pbc,~,histox]=RDF2(point3,dgrayIm,numStep);
    else
        [clGr,~,clGr2,clGr2_pbc,~,histox]=RDF2(point4,dgrayIm,numStep);
    end
    if isempty (clGr2_pbcT)
        clGr2_pbcT=clGr2_pbc;
        clGr_T=clGr;
    else
        clGr2_pbcT=clGr2_pbcT+clGr2_pbc;
        clGr_T=clGr_T+clGr;
    end
%     figure 
%     bar(histox,clGr2_pbc);
end

clGr2_pbcT_avg=clGr2_pbcT/numImage;
clGr_T_avg=clGr_T/numImage;

datay=clGr2_pbcT;
figure
bar(histox,datay);

Npoint_avg=sum(Npoint);

x0=[10	1	1	1	Npoint_avg];
lb=[1    1  1   1  Npoint_avg];
ub=[24   20   1000    1000  Npoint_avg];
x=lsqcurvefit(@RDFfun,x0,histox,datay,lb,ub);

space=mean(diff(histox));
fitx = (histox(1):space:histox(end));
figure
bar(histox,datay,'FaceColor',[0 .9 .9])
hold on
plot(fitx,RDFfun(x,fitx),'k-')

xlabel('distance, r (px)');
ylabel('Counts');
% hold on
% fitx2 = (histox(1):space:3*histox(end));
% plot(fitx2,RDFfun(x,fitx2),'b-')

a0=x(1);
sigm=x(2);

cor_l=(sigm^2/a0)*((sqrt(0.5+sqrt(0.25+4*(pi^2)*(sigm/a0)^4)))-1)^-1;
result=[x,cor_l]
fract=cor_l/a0
