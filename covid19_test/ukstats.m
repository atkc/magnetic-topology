stats=[2,2,3,3,4,8,8,9,9,13,13,19,23,35,40,52,85,114,160,206,271,321,373,456,590,798,1140,1372];
days=1:length(stats);

ext_days=1:(1*length(stats)+7);

p=polyfit(days(10:end),log(stats(10:end)),1);
ext_stats=exp(polyval(p,ext_days));

figure;
plot(days,stats,'o')
hold on;
plot(ext_days,ext_stats);
xlabel('# of Days');
ylabel('# of Cases');
title('# of Covid 19 cases in the UK')

figure;
plot(days,log(stats),'o')
hold on;
plot(ext_days,log(ext_stats));
xlabel('# of Days');
ylabel('log(# of Cases)');
title('# of Covid 19 cases in the UK (Log)')