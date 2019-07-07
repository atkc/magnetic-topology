function [imx,imy,imz] = construct_profile(im_dist,im_phi,profile_size)
%CONSTRUCT_PROFILE Summary of this function goes here
%   Detailed explanation goes here
r=(profile_size-1)/2;
im_dist(im_dist>r)=r;
imz=cos(im_dist*pi/(r));
imx=sin(im_dist*pi/(r)).*cos(im_phi);
imy=sin(im_dist*pi/(r)).*sin(im_phi);
end

