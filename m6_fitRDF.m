

datay=clGr2_pbc;

x0=[35.0983	8.4618	136.8309	10.4773	49];
lb=[30,0.5,1,1,49];
ub=[40,20,1000,1000,49];
x=lsqcurvefit(@RDFfun,x0,histox,datay,lb,ub)

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
fract=cor_l/a0;