function [ fs2,r,theta ] = minDist_filter( fs2,r,theta )
%FIL Summary of this function goes here
%   Detailed explanation goes here
minDist=1080/256;
fil_index=(fs2(:,3)>minDist);
fs2=fs2(fil_index,:);
r=r(fil_index);
theta=theta(fil_index);

end

