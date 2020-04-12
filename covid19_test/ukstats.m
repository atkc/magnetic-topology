test_stats=[NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,50442,53595,61352, 66976,72818,78340,83945,90436];
cases_stats=[2,2,3,3,4,8,8,9,9,13,13,19,23,35,40,52,85,114,160,206,271,321,373,456,590,798,1140,1372,1950,2626,3269,3983,5018,5683,6650,8077,9529];
days=1:length(cases_stats);

ext_days=1:(1*length(cases_stats)+10);

p=polyfit(days(15:end),log(cases_stats(15:end)),1);
ext_stats=exp(polyval(p,ext_days));

figure;
plot(days,cases_stats,'o')
hold on;
plot(ext_days,ext_stats);
xlabel('# of Days');
ylabel('# of Cases');
title('# of Covid 19 cases in the UK')

figure;
plot(days,log(cases_stats),'o')
hold on;
plot(ext_days,log(ext_stats));
xlabel('# of Days');
ylabel('log(# of Cases)');
title('# of Covid 19 cases in the UK (Log)')

%%
startd=10;
logfun=@(x,xdata)x(1)./(1+exp((-x(2)*(xdata-x(3)))));

x0=[20000, 0.26,37];
xdata=days(startd:end);
ydata=cases_stats(startd:end);
[x,resnorm,resid,exitflag,output,lambda,J]=lsqcurvefit(logfun,x0,xdata,ydata);
ci = nlparci(x,resid,'jacobian',J);
ext_days_logfun=1:(1*length(cases_stats)+x(3));

figure;
plot(days,cases_stats,'o')
hold on;
plot(ext_days_logfun,logfun(x,ext_days_logfun));
plot(ext_days_logfun,logfun([ci(1,1),ci(2,1),ci(3,2)],ext_days_logfun));
plot(ext_days_logfun,logfun([ci(1,2),ci(2,2),ci(3,1)],ext_days_logfun));