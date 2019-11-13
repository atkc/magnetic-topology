function [ fs2,r,theta ] = minDist_filter( fs2,r,theta,fs_old )
%FIL Summary of this function goes here
%   Detailed explanation goes here
minDist=1080/256;

if nargin<=3
    fil_index=(fs2(:,3)>minDist);
else
    fil_index=(fs_old(:,3)>minDist);
end
fs2=fs2(fil_index,:);
switch nargin
    case 1
        r=0;
        theta=0;
    case 2
        r=r(fil_index);
        theta =0;
    case 3
        r=r(fil_index);
        theta=theta(fil_index);
end

end

