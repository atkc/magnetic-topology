f1=fit1_noweight;
f2=fit2_inverseR;
f3=fit3_iso;
f4=fit4_aniso;


d1=abs(f3(:,5)-f1(:,5));
d2=abs(f3(:,5)-f2(:,5));
d3=abs(f3(:,5)-f4(:,5));

figure;% to show that the fit angle converges with better weights
subplot(2,2,1);
histogram(d1,180);
xlim=[0,180];
subplot(2,2,2);
histogram(d2,180);
xlim=[0,180];
subplot(2,2,3);
histogram(d3,180);
xlim=[0,180];

maxis1=sort(f1(:,3:4),2);
maxis2=sort(f2(:,3:4),2);
maxis3=sort(f3(:,3:4),2);
maxis4=sort(f4(:,3:4),2);

r1=maxis1(:,1)./maxis1(:,2);
r2=maxis2(:,1)./maxis2(:,2);
r3=maxis3(:,1)./maxis3(:,2);
r4=maxis4(:,1)./maxis4(:,2);


figure;% to show that the fit angle converges with better weights
lim=[0,inf];
s=20;
subplot(2,2,1);
histogram(abs(r3-r1),s);
xlim=lim;
subplot(2,2,2);
histogram(abs(r3-r2),s);
xlim=lim;
subplot(2,2,3);
histogram(abs(r3-r4),s);
xlim=lim;

figure;% to show that the fit angle converges with better weights
lim=[0,inf];
s=20;
subplot(2,2,1);
histogram(abs(maxis3(:,1)-maxis1(:,1)),s);
xlim=lim;
subplot(2,2,2);
histogram(abs(maxis3(:,1)-maxis2(:,1)),s);
xlim=lim;
subplot(2,2,3);
histogram(abs(maxis3(:,1)-maxis4(:,1)),s);
xlim=lim;

figure;% to show that the fit angle converges with better weights
lim=[0,inf];
s=20;
subplot(2,2,1);
histogram(abs(maxis3(:,2)-maxis1(:,2)),s);
xlim=lim;
subplot(2,2,2);
histogram(abs(maxis3(:,2)-maxis2(:,2)),s);
xlim=lim;
subplot(2,2,3);
histogram(abs(maxis3(:,2)-maxis4(:,2)),s);
xlim=lim;