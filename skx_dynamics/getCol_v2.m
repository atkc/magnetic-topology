function [ col_list ] = getCol( im )
%GETCOL Summary of this function goes here
%   Detailed explanation goes here

%imsize=size(im);
im_rs = reshape(im, [], 3);
[col_list, ia, i_col] = unique(im_rs, 'rows');

i_col_bg=1;
max_count=sum(i_col==1);
for idx=2:max(i_col)
    count=sum(i_col==idx);
    if count>max_count
        i_col_bg=idx;
        max_count=count;
    end
end

col_bg=col_list(i_col_bg,:);
binIm=~((im(:,:,1)==col_bg(1)).*(im(:,:,2)==col_bg(2)).*(im(:,:,3)==col_bg(3)));
center = regionprops(binIm,'centroid');
center_sub = cat(1, center.Centroid);

full_col_list=zeros(length(center),3);
for i=1:length(center)
    full_col_list(i,:)=im(round(center_sub(i,2)),round(center_sub(i,1)),:);
end

col_list = unique(full_col_list, 'rows');
