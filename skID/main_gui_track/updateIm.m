function [  ] = updateIm( handles,im,im_pos_i )
%UPDATEIM Summary of this function goes here
%   Detailed explanation goes here
cla(handles.figBox,'reset');
axes(handles.figBox);
imshow(imtranslate(im,im_pos_i),[0,255]);
end

