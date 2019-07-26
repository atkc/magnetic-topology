function [im_rgb] = plot_rgb_vec(imx,imy,imz,varargin)
if length(varargin)==1
    l_scale=varargin{1};
else
    l_scale=1;
end
matx=imx;
maty=imy;
matz=imz;
layer=1;
sizemat=size(matx);
%maxr=max([max(matx(:)),max(maty(:)),max(matz(:))]);
maxr=max([max(max(matx(:,:,layer))),max(max(maty(:,:,layer))),max(max(matz(:,:,layer)))]);
%minr=min(min(matx(:)),min(maty(:)),min(matz(:)));
[X,Y]=meshgrid(0:sizemat(2)-1,0:sizemat(1)-1);
X=X*l_scale;
Y=Y*l_scale;
angle=wrapTo360((atan2(maty(:,:,layer),matx(:,:,layer)))*180/pi);
nom=(maty(:,:,layer).^2+matx(:,:,layer).^2).^0.5;
% r=(matx(:,:,layer)/maxr)*0.4999+0.4999;
% g=(maty(:,:,layer)/maxr)*0.4999+0.4999;
% b=(matz(:,:,layer)/maxr)*0.4999+0.4999;
% c(:,:,1)=r;
% c(:,:,2)=g;
% c(:,:,3)=b;
% figure;
% surf(X,Y,matz(:,:,layer),c,'FaceColor','interp');
% 
% % quiver3d(X,Y,zeros(size(X)),maty(:,:,layer),matx(:,:,layer),matz(:,:,layer))
% view(2)
% axis equal

im(:,:,1)=angle;
im(:,:,2)=nom/max(max(abs(matz(:,:,layer))));
im(:,:,3)=(matz(:,:,layer)/max(max(abs(matz(:,:,layer)))))*0.5+0.5;
CData = colorspace('hsi->rgb',double(im));
im_rgb(:,:,1)=CData(:,:,1);
im_rgb(:,:,2)=CData(:,:,2);
im_rgb(:,:,3)=CData(:,:,3);
%figure;imshow(flipud(im_rgb));
%figure;
surf(X,Y,matz(:,:,layer),im_rgb,'FaceColor','interp');
shading interp
view(2)
axis equal
end