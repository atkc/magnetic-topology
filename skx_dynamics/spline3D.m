function [zq,xq_mat,yq_mat,countmat]=spline3D(z,x,y,z_bin_N,x_bin_N) 

[zbin_ind,zedge]=discretize(z,z_bin_N);
z_iter=z_bin_N;
zq=zedge(1:z_bin_N)+(mean(diff(zedge))/2);

x_iter=x_bin_N;

xq_mat=zeros([z_iter,x_iter]);
yq_mat=zeros([z_iter,x_iter]);
countmat=zeros([z_iter,x_iter]);
for i_z=1:z_iter
    x_part=x(zbin_ind==i_z);
    y_part=y(zbin_ind==i_z);
    
    [~,xedge]=discretize(x_part,x_bin_N);
    xbin=xedge(1:x_iter)+(mean(diff(xedge))/2);
    yq_part=spline(x_part,y_part,xbin);
    
    xq_mat(i_z,:)=xbin;
    yq_mat(i_z,:)=yq_part;
end

end
