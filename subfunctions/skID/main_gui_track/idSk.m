function [ skN ] = idSk(centroids,x,y)
%IDSK Summary of this function goes here
%   Detailed explanation goes here
distxy=abs((centroids(:,1)-x).^2+(centroids(:,2)-y).^2);
[~,skN]=min(distxy);

end

