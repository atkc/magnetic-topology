function [imx_sum,imy_sum,imz_sum,im_counts] = sum_profile(im_skel,profilex,profiley,profilez)
%SUM_PROFILE Summary of this function goes here
%   Detailed explanation goes here

[m,n]=size(im_skel);
[pm,pn]=size(profilex);

imx_sum=zeros(m,n);
imy_sum=zeros(m,n);
imz_sum=zeros(m,n);
im_counts=ones(m,n);
counts=ones(pm,pn);

r=(pm-1)/2;

for yi=1:m
    for xi=1:n
        if im_skel(yi,xi)
            try
            imx_sum(yi-r:yi+r,xi-r:xi+r)=imx_sum(yi-r:yi+r,xi-r:xi+r)+profilex;
            imy_sum(yi-r:yi+r,xi-r:xi+r)=imy_sum(yi-r:yi+r,xi-r:xi+r)+profiley;
            imz_sum(yi-r:yi+r,xi-r:xi+r)=imz_sum(yi-r:yi+r,xi-r:xi+r)+profilez+1;
            im_counts(yi-r:yi+r,xi-r:xi+r)=im_counts(yi-r:yi+r,xi-r:xi+r)+counts;
            end
        end
    end
end
imz_sum=imz_sum-1;
end

