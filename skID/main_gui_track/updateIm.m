function [  ] = updateIm( handles,im,im_pos_i,zmode_sub)
%UPDATEIM Summary of this function goes here
%   Detailed explanation goes here
cla(handles.figBox,'reset');
axes(handles.figBox);
if any(im_pos_i)
    imshow(imtranslate(im,im_pos_i),[0,255]);
else
    imshow(im,[0,255]);
end

if zmode_sub>1
    dl=256;
    xlim([256,768]);
    ylim([dl*(zmode_sub-2),dl*(zmode_sub-2)+512]);
else
    ylim([0,1024]);
    xlim([0,1024]);
end

