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

[sub_lx,sub_ly]=size(im);
if zmode_sub>1
    dlx=sub_lx/4;
    dly=sub_ly/4;
    
    xlim([dly,3*dly]);
    ylim([dlx*(zmode_sub-2),dlx*(zmode_sub)]);
else
    ylim([0,sub_lx]);
    xlim([0,sub_ly]);
end

