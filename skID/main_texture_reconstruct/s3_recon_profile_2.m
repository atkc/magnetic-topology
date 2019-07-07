function [imx,imy,imz,im_weight] = s3_recon_profile_2(vorticity_m,helicity_y,domainWidth,domainWallWidth,im_dist,im_phi)
%GEN_PROFILE Summary of this function goes here
%   Detailed explanation goes here
%helicity_y: 0 (neel outward),pi (neel inward), pi/2 (bloch CW),-pi/2 (bloch (CCW)
%vorticity_m: +-1 
%DW length is define as the transition length from one state to the same
%state (ie, up to up or down to down magnetization)
imx=zeros(size(im_dist));
imy=zeros(size(im_dist));
d= (domainWidth)/2;
dw=domainWallWidth/2;
r=dw+d;%(domain wal + domain) /2

dist_trans=im_dist;
phi=-im_phi*pi/180+helicity_y;



imz=-1.*ones(size(im_dist)).*(abs(dist_trans)>r);
imz=imz+1.*ones(size(im_dist)).*(abs(dist_trans)<d);

imz=imz+cos((dist_trans-d)*pi/(dw)).*(((abs(dist_trans))<=r).*((abs(dist_trans)-d)>=0));
imx=imx+abs(sin((dist_trans-d)*pi/(dw))).*cos(phi).*(((abs(dist_trans))<=r).*((abs(dist_trans)-d)>=0));
imy=imy+abs(sin((dist_trans-d)*pi/(dw))).*sin(phi).*(((abs(dist_trans))<=r).*((abs(dist_trans)-d)>=0));
im_weight=max(dist_trans(:))-(dist_trans);

