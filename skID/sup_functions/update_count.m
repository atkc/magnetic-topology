function [ ] = update_count( handles,centroids,imageSize )
%UPDATE_COUNT Summary of this function goes here
%   Detailed explanation goes here
if ~isempty(centroids)
    [no,~]=size(centroids);
else
    no=0;
end
set(handles.noSk_text,'String',no);
set(handles.skden_text,'String',no/imageSize^2);
end

