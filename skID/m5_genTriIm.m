%%******to draw triangulation on image ********
%%***input parameters***
filename='C:\Users\Anthony\Dropbox\Shared_MFM\DataAnalysis\Skyrmion Lattice\11d lattice\image 1\160517_x11d_n3k-p2k_sss_col.tif'; %file directory
load('isofit_11d.mat');
load('centroids_11d.mat');
r=3;%radius size
%%**********************
factor=4;
im=iir(filename,factor);
dgrayIm = rgb2gray(im);
%for grayscale output)
GrayIm = im2double(cat(3,dgrayIm,dgrayIm,dgrayIm));

% %for color output
ColIm= im2double(im); %matrix with double precision

%special series LOL (fail)
SpeIm = (GrayIm.*ColIm);

%ppick your picture
clear dgrayIm;

dgrayIm=GrayIm*0.65+0.35;
% figure 
% imshow(dgrayIm);
dgrayIm=im2uint8(dgrayIm);

% figure 
% imshow(dgrayIm);
[l,~]=size(isofit);

drawPara=zeros(l,3);
drawPara(:,1:2)=centroids(:,1:2);
drawPara(:,3)=drawPara(:,3)+r;

%drawIm=insertShape(dgrayIm,'filledCircle',drawPara,'linewidth',2,'color','green','opacity',0.5);
% 
% drawPara(:,1:2)=centroids(:,1:2);
% 
% drawIm2=insertShape(im,'Circle',drawPara,'linewidth',4,'color','red','opacity',0.7);
% figure
% imshow(drawIm2);
% figure;
% imshow(drawIm);

    %%*******************************************
    %%determine D-trianglation of set of vertices
    %%*******************************************
    dt=delaunayTriangulation(centroids(:,1),centroids(:,2));
    [vx,vy]=voronoi(dt);
    vx=vx*factor;
    vy=vy*factor;
    %%*******************************************
    %%Normalized Angle statistics
    %%*******************************************
    vertices=[dt.Points];
    trigID=[dt.ConnectivityList];
    anglestat=zeros(length(trigID),3);
    drawIm2=dgrayIm;
    f1=figure;
    drawIm2=insertShape(drawIm2,'FilledCircle',drawPara*factor,'color','r','opacity',1);
    imshow(drawIm2);
%     hold on
%     plot(drawPara(:,1)*factor,drawPara(:,2)*factor,'o','MarkerSize',5,'MarkerEdgeColor','r','MarkerFaceColor','r');
    axis([93 504 46 457]*factor);
    drawIm3=drawIm2((46:457)*factor,(93:504)*factor,:);
%     set(gca,'position',[0 0 1 1],'units','normalized')
    
[m,n,~]=size(drawIm2);
BinIm=im2uint8(ones(size(drawIm2)));
BinIm=insertShape(BinIm,'line',[vx(1,:)',vy(1,:)',vx(2,:)',vy(2,:)'],'linewidth',6,'color',[170 170 170],'opacity',1);

    for i=1:length(trigID)
      v1=vertices(trigID(i,1),:);
      v2=vertices(trigID(i,2),:);
      v3=vertices(trigID(i,3),:);
%       hold on
%       line([v1(1) v2(1)],[v1(2) v2(2)],'color','r','linewidth',2);
%       hold on
%       line([v3(1) v2(1)],[v3(2) v2(2)],'color','r','linewidth',2);
%       hold on
%       line([v1(1) v3(1)],[v1(2) v3(2)],'color','r','linewidth',2);
     BinIm=insertShape(BinIm,'line',[v1 v2;v2 v3;v1 v3]*factor,'linewidth',8,'color','black','opacity',1);

      i
    end
BinIm=insertShape(BinIm,'FilledCircle',drawPara*factor,'color','red','opacity',1);

% set(gca,'position',[0 0 1 1],'units','normalized')
% iptsetpref('ImshowBorder','tight');
% print(f1,'test1','-dpng','-r900') % save image as a .tiff file
%  print(f2,'test2','-dpng','-r450')
 


%  figure
%  imshow(drawIm2);


figure
imshow(drawIm3);
drawIm4=BinIm((46:457)*factor,(93:504)*factor,:);
% figure
imshow(drawIm4)
imwrite(drawIm3,'sfig_superimpose_cropped.png','png');
imwrite(drawIm4,'sfig_norm_cropped.png','png');
