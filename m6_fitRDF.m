

datay=p12_pbc;
sum(clGr);
x0=[15,1,100,100,47];
lb=[13,1,1,1,45];
ub=[17,10,300,300,60];
x=lsqcurvefit(@RDFfun,x0,histox,datay,lb,ub,'interior-point')

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