filename='C:\Users\Anthony\Dropbox\Shared_MFM\1706_MTXM-Data\Processed images\170615_20b-F_pHs\col_2x2_fil_170615_20b-F_0145.tiff';
X =imread(filename);

cmap_rb1=[linspace(0,255,50);linspace(0,255,50);ones([1,50])*255];
cmap_rb2=[ones([1,50])*255;linspace(255,0,50);linspace(255,0,50)];
cmap_rb=[cmap_rb1,cmap_rb2];
cmap=cmap_rb'/255
ind = rgb2ind(X, cmap);
image(ind)
colormap('gray')
axis equal
axis off
