function [ output_args ] = RDF( points,im,stepR )
%RDF Summary of this function goes here
%   Detailed explanation goes here

[m,n]=size(im);

midptX=m/2;
midptY=n/2;

distXY=((points(1,:)-midptX).^2+(points(2,:)-midptY).^2);
[minInd,~]=min(distXY);



end

