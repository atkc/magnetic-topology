J=10*10^-12;
B=1.6;

D=3*10^-3;

rd=(3:11);
r=rd*J/D

Ha=B*D.^2/(2*J)

ee=sqrt(2/B);
fy=besselk(1,rd./ee);
figure
plot(rd,log(fy));