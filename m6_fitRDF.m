Gr_pbc_T=[];
Gr_T=[];
numStep=100;
maxi=zeros(1,4);
for numi=1:numImage
    if numi==1
        [Gr,Gr_pbc,stdGr,stdGr_pbc,histox]=RDF2(point1,dgrayIm,numStep);
        maxi(1)=max(histox);
    elseif numi==2
        [Gr,Gr_pbc,stdGr,stdGr_pbc,histox]=RDF2(point2,dgrayIm,numStep);
        maxi(2)=max(histox);
    elseif numi==3
        [Gr,Gr_pbc,stdGr,stdGr_pbc,histox]=RDF2(point3,dgrayIm,numStep);
        maxi(3)=max(histox);
    else
        [Gr,Gr_pbc,stdGr,stdGr_pbc,histox]=RDF2(point4,dgrayIm,numStep);
        maxi(4)=max(histox);
    end
    if isempty (Gr_pbc_T)
        Gr_pbc_T=Gr_pbc;
        Gr_T=Gr;
    else
        Gr_pbc_T=Gr_pbc_T+Gr_pbc;
        Gr_T=Gr_T+Gr;
    end
%     figure 
%     bar(histox,clGr2_pbc);
end


datay=Gr_T;
figure
bar(histox,datay);

Npoint_avg=sum(Npoint);

x0=[13	2.1	50	34	Npoint_avg];
lb=[8  0  1   0 Npoint_avg];
ub=[17   16  100   100  Npoint_avg];
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

