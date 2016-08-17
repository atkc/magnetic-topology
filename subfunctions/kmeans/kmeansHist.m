function [ idx,C ] = kmeansHist( im )
%KMEANSHIST Summary of this function goes here
%   Detailed explanation goes here
[m,n]=size(im);
data=zeros(m*n,2);
data(:,1)=reshape(im,[m*n,1]);
[idx,C]=kmeans(data,2);


end

