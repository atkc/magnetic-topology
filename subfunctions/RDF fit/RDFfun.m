function [ fy ] = RDFfun( x_0, xdata)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
coorN=[ 6     6     6    12     6     6    12     6    12    12     6 ...
    6    12    12     6    12    12    12     6    18    12    12    12 ...
    12    12    12     6    12 12     6    12    18    12    12    12 ...
    6    12    12    12    12     6    12    12    12    12    12    18];

rN=[19.5697   34.0657   39.8641   52.9106   59.4338   68.8562   71.7554 ...
    79.7282   86.9763   91.3251   99.2979  103.6467  105.8211  110.8947 ...
    119.5924  121.0420  124.6660 130.4644  138.4372  139.8868  143.5108 ...
    150.7588  155.8325  158.7317  163.0805  170.3285  172.5029  173.9525 ...
    177.5765  179.7509  182.6501  190.6230  192.7974  196.4214 202.9446 ...
    203.6694  208.7430  210.1926  211.6422  215.9910  219.6151  222.5143 ...
    224.6887  226.8631  230.4871  235.5607  242.0839];



a=x_0(1);
stdev=x_0(2);
Rmax=x_0(3);
Wmax=x_0(4);
N=x_0(5);

a0=19.5697;
rN=rN*a/a0;
%rN=rN(rN<2*max(xdata));
%coorN=coorN(rN<2*max(xdata));
dr=mean(diff(xdata));


fy=zeros(size(xdata));
gy=zeros(size(xdata));
for i=1:length(coorN)
    gy=gy+(coorN(i)/(stdev*(2*pi*rN(i)/a)^0.5))*exp(-(xdata-rN(i)).^2/(rN(i)*2*stdev^2/a));
    fy=fy+(coorN(i)/(stdev*((2*pi*rN(i)/a)^0.5)))*exp(-((xdata-rN(i)).^2)/((2*rN(i)*stdev^2)/a));
end
sum(coorN);
display('mean is');
display(mean(diff(xdata)));

%%Function reproduced Inosov's fit
%fy=(1/2*fy*N*dr./(1+exp((xdata-Rmax)/Wmax)));%has /2

%%Function reproduced CL's fit
fy=(fy*N*dr./(1+exp((xdata-Rmax)/Wmax)));%CL's definition

end

