function [ fil_centers ] = checkEdge( centers, r,l )
%CHECKEDGE Summary of this function goes here
%   Detailed explanation goes here
l_x=l(1);
l_y=l(2);
x=centers(:,1);
y=centers(:,2);
x_i=(x>r).*(x<(l_x-r));
y_i=(y>r).*(y<(l_y-r));
ind=logical(x_i.*y_i);

fil_centers=centers(ind,:);

end

