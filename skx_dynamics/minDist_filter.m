function [ fs2,r,theta ] = minDist_filter( fs2,r,theta,minDist )

%%old function ( i dont know why it was written like this...)
%function [ fs2,r,theta ] = minDist_filter( fs2,r,theta,fs_old,minDist )
%FIL Summary of this function goes here
%   Detailed explanation goes here

% if nargin<=3
%     fil_index=(fs2(:,3)>minDist);
% else
%     fil_index=(fs_old(:,3)>minDist);
% end
% fs2=fs2(fil_index,:);
% switch nargin
%     case 1
%         r=0;
%         theta=0;
%     case 2
%         r=r(fil_index);
%         theta =0;
%     case 3
%         r=r(fil_index);
%         theta=theta(fil_index);
% end

%%new function
fil_index=(fs2(:,3)>minDist);
r=r(fil_index);
theta=theta(fil_index);
fs2=fs2(fil_index,:);

end

