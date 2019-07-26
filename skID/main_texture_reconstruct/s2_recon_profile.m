function [imx,imy,imz] = s2_recon_profile(im_dist,im_phi,profile_size,domainWall)
%CONSTRUCT_PROFILE Summary of this function goes here
%   Detailed explanation goes here
r=(domainWall)/2;
w= (profile_size-domainWall)/2;
im_dist2=zeros(size(im_dist));
im_dist2(im_dist>(r+w))=r;
im_dist2(im_dist<=(r+w))=im_dist(im_dist<=(r+w))-w;
im_dist2(im_dist<w)=0;

imz=cos(im_dist2*pi/(r));
imx=sin(im_dist2*pi/(r)).*cos(im_phi);
imy=sin(im_dist2*pi/(r)).*sin(im_phi);
end

