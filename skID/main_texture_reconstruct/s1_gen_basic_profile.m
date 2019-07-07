function [imx,imy,imz,im_weight] = s1_gen_basic_profile(vorticity_m,helicity_y,domainWidth,imSize)
%GEN_PROFILE Summary of this function goes here
%   Detailed explanation goes here
%helicity_y: 0 (neel outward),pi (neel inward), pi/2 (bloch CW),-pi/2 (bloch (CCW)
%vorticity_m: +-1 

imx=zeros(imSize);
imy=zeros(imSize);
w= (domainWidth-1)/2;
r= (imSize-1)/2;
dw=w-r;

[X,Y]=meshgrid(-r:r);

d=sqrt(X.^2+Y.^2);
phi=atan2(Y,X)+helicity_y;



imz=-1.*ones(imSize).*(abs(d)>r);
imz=imz+1.*ones(imSize).*(abs(d)<w);

imz=imz+cos((d-w)*pi/(dw)).*(((abs(d))<=r).*((abs(d)-w)>=0));
imx=imx+abs(sin((d-w)*pi/(dw))).*cos(phi).*(((abs(d))<=r).*((abs(d)-w)>=0));
imy=imy+abs(sin((d-w)*pi/(dw))).*sin(phi).*(((abs(d))<=r).*((abs(d)-w)>=0));
im_weight=max(d(:))-(d);


%im_mag=sqrt(imz.^2+imy.^2+imx.^2)
end

