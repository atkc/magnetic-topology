%%histogram of size vs theta/vsk
%180417-1_fp553_1b_d3_2um_n4k-p750 flow pulse id
folder='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180417-1_fp553_1b_d3_2um_n4k-p750\analysis\registered_ctf\';
datafolder='skel (p4-34)\';

imfile='Reg_180417_fp553_1b_d3_2um_p';

% %%180412-1_fp553_1b_d2_2um_n4k-p750 flow pulse id
% folder='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180412-1_fp553_1b_d2_2um_n4k-p750\analysis_750\CTF\';
% datafolder='';
% imfile='Reg_180412_fp553_1b_d2_2um_p';
cd(strcat(folder));
saveit=0;
% datasets
load(strcat(folder,datafolder,'fullstat2-combine.mat'));
load(strcat(folder,datafolder,'fullstat2-size-combine.mat'));
load(strcat(folder,datafolder,'i1-combine.mat'));
load(strcat(folder,datafolder,'r_cor-combine.mat'));
load(strcat(folder,datafolder,'theta_cor-combine.mat'));
%[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x(before),coor_y(before),skID_min,radius];

%180417-1_fp553_1b_d3_2um_n4k-p750 flow pulse id
p_range=[5 7 9 27 29 31 33];%+j
%p_range=[6 8 10 28 30 32 34];%-j
p_range_flow=[5 6 7 8 9 10 27 28 29 30 31 32 33 34];


% %180412-1_fp553_1b_d2_2um_n4k-p750 flow pulse id
% %p_range=[6 8 40];%+j
% p_range=[7 9 39];%-j
% p_range_flow=[6,7,8,9,39,40];

im_com=zeros([256,256]);
for p_i=1:length(p_range)
    imbefore=imread(strcat(imfile,num2str(p_range(p_i)-1),'_MFM.tiff'));
    imafter=imread(strcat(imfile,num2str(p_range(p_i)),'_MFM.tiff'));
    im_com=im_com+double(imbefore)+double(imafter);
end
im_com=rescale(im_com,0.5,1);
% %180412-1_fp553_1b_d2_2um_n4k-p750 flow pulse id
% %p_range=[7,9,39];%+j
% p_range=[6,8,40];%-j
% p_range_flow=[6,7,8,9,39,40];

dsk1=60;
dsk2=200;
no_edge=6;

size_s_bin_i=3;
size_l_bin_i=(no_edge-1)-1;
newfullstat2(:,3:5)=fullstat2(:,3:5);
size_s_xy=zeros([1000,4]);%small skszie
size_l_xy=zeros([1000,4]);%large sk size
size_edge=linspace(dsk1,dsk2,no_edge);
size_bins=mean(diff(size_edge))/2+size_edge(1:(length(size_edge)-1));

conv=13000/1080;
p_width=20;
minDist=1080/256;%min pixel size
c1=conv*10^-9/(p_width*10^-9);%m/s
v1=minDist*c1;%m/s
vpct1=0;%lower percentile
vpct2=100;%upper percentile
i_use=1;

%**Select sk size range parameters**
dsk1=60;
dsk2=200;

%**Select HA filtering parameters**
HA1=-90;
HA2=90;
HApct1=0;%lower percentile (only in use if HA1 & HA2 is NAN)
HApct2=100;%upper percentile
HAoffset=0;
proj=0;%0: no proj, 1: proj to -90 to 90 2: proj to 0 to 90

%**Counts filter parameters**
count_min=1;

fil_para.sel_p=p_range_flow;
fil_para.vcutoff=v1;
fil_para.vpct1=vpct1;
fil_para.vpct2=vpct2;
fil_para.dsk1=dsk1;
fil_para.dsk2=dsk2;
fil_para.HAoffset=HAoffset;
fil_para.HA1=HA1;
fil_para.HA2=HA2;
fil_para.proj=proj;
fil_para.HApct1=HApct1;
fil_para.HApct2=HApct2;

%%
%small sizes (manual filter + minDist filter)

[fullstat2_fil,r_cor_fil,theta_cor_fil]=minDist_filter(newfullstat2,r_cor,theta_cor,minDist);
sksize_fil=fullstat2_fil(:,9)*conv;

size_i=(sksize_fil>dsk1).*(sksize_fil<dsk2);
angle_i=((theta_cor_fil*180/pi)>-90).*((theta_cor_fil*180/pi)<90);
fil_i=(ismember(fullstat2_fil(:,2),p_range).*angle_i'.*size_i)==1;
sum(fil_i)
fullstat2_fil=fullstat2_fil(fil_i,:);
r_cor_fil=r_cor_fil(fil_i);
theta_cor_fil=theta_cor_fil(fil_i);
sksize_fil=sksize_fil(fil_i);
%%
%by top and lowest N sk sizes
[~,sort_i]=sort(sksize_fil);

fullstat2_fil_sort=fullstat2_fil(sort_i,:);
r_cor_fil_sort=r_cor_fil(sort_i);
theta_cor_sort=theta_cor_fil(sort_i);
sksize_fil_sort=sksize_fil(sort_i);
ee=length(theta_cor_sort);
top_per=25;% in percentage
topn=floor(ee*top_per/100);
%topn=70;%top and bottom topn  sizes;
% xoffset=0;
xoffset=415;%180417-1_fp553_1b_d3_2um_n4k-p750
xybefore_s=[fullstat2_fil_sort(1:topn,6)-xoffset,fullstat2_fil_sort(1:topn,7)]*256/1080;
xyafter_s=[fullstat2_fil_sort(1:topn,4),fullstat2_fil_sort(1:topn,5)]*256/1080+xybefore_s;
p_id_s=fullstat2_fil_sort(1:topn,2);



xybefore_l=[fullstat2_fil_sort((ee+1-topn):ee,6)-xoffset,fullstat2_fil_sort((ee+1-topn):ee,7)]*256/1080;
xyafter_l=[fullstat2_fil_sort((ee+1-topn):ee,4),fullstat2_fil_sort((ee+1-topn):ee,5)]*256/1080+xybefore_l;
p_id_l=fullstat2_fil_sort((ee+1-topn):ee,2);

% %180412-1_fp553_1b_d2_2um_n4k-p750
% for p_spec=[39 40]
%     spec_i_l=p_id_l==p_spec;
%     xybefore_l(spec_i_l,2)=xybefore_l(spec_i_l,2)+2;
%     xyafter_l(spec_i_l,2)=xyafter_l(spec_i_l,2)+2;
%     xybefore_l(spec_i_l,1)=xybefore_l(spec_i_l,1)+0.5;
%     xyafter_l(spec_i_l,1)=xyafter_l(spec_i_l,1)+0.5;
%     
%     spec_i_s=p_id_s==p_spec;
%     xybefore_s(spec_i_s,2)=xybefore_s(spec_i_s,2)+2;
%     xyafter_s(spec_i_s,2)=xyafter_s(spec_i_s,2)+2;
%     xybefore_s(spec_i_s,1)=xybefore_s(spec_i_s,1)+0.5;
%     xyafter_s(spec_i_s,1)=xyafter_s(spec_i_s,1)+0.5;
% end

xplot_s=[xybefore_s(:,1)';xyafter_s(:,1)'];
yplot_s=[xybefore_s(:,2)';xyafter_s(:,2)'];

xplot_l=[xybefore_l(:,1)';xyafter_l(:,1)'];
yplot_l=[xybefore_l(:,2)';xyafter_l(:,2)'];
figure
imshow(im_com);
hold on
plot(xplot_s,yplot_s,'-k');
hold on
plot(xybefore_s(:,1),xybefore_s(:,2),'.k','MarkerSize',10);
axis equal
title(strcat('Bottom ',num2str(top_per),'% skyrmion size and their corresponding velocity'));

%180417-1_fp553_1b_d3_2um_n4k-p750 flow pulse id
xlimits=[104,104+80];
ylimits=[228-220,228];
% %180412-1_fp553_1b_d2_2um_n4k-p750 flow pulse id
% xlimits=[84,84+80];
% ylimits=[227-160,227];

xlim(xlimits);
ylim(ylimits);
set(gcf,'position',1.0e+03 * [0.0010    0.0410    1.5360    0.7488])
if saveit
    export_fig edge_effect_neg_j_smallest_150_illustration.png
end


% figure(com_fig);
% plot(xplot,-yplot);
% hold on
% plot(xybefore_s(:,1),-xybefore_s(:,2),'.k');hold on
figure
imshow(im_com);
hold on
plot(xplot_l,yplot_l,'-k');
hold on
plot(xybefore_l(:,1),xybefore_l(:,2),'.k','MarkerSize',10);
axis equal
title(strcat('Top ',num2str(top_per),'% skyrmion size and their corresponding velocity'));

xlim(xlimits);
ylim(ylimits);
set(gcf,'position',1.0e+03 * [0.0010    0.0410    1.5360    0.7488])

%%combined plot
xlimits=[118 169];
ylimits=[86 137];
figure
imshow(im_com);
hold on
scatter(xybefore_l(:,1),xybefore_l(:,2),80,'MarkerFaceColor','b',...
    'MarkerEdgeColor','b','MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.5);
axis equal
hold on
scatter(xybefore_s(:,1),xybefore_s(:,2),80,'MarkerFaceColor','r',...
    'MarkerEdgeColor','r','MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.5);
axis equal
plot(xplot_l,yplot_l,'-b','linewidth',2);
hold on
plot(xplot_s,yplot_s,'-r','linewidth',2);
xlim(xlimits); ylim(ylimits);
set(gcf,'position',[-1919 85 1920 964.8000])

sset=[19 84 107];
scol=[180 0 0;230 50 50; 255 130 130]/255;
lset=[822 946 955];
lcol=[0 5 180;44 44 255;78 145 253]/255;
for sli=1:3
    xybefore_s=[fullstat2_fil_sort(sset(sli),6)-xoffset,fullstat2_fil_sort(sset(sli),7)]*256/1080;
    scatter(xybefore_s(:,1),xybefore_s(:,2),420,'p','MarkerFaceColor',scol(sli,:),...
        'MarkerEdgeColor','k');
    hold on
    xybefore_l=[fullstat2_fil_sort(lset(sli),6)-xoffset,fullstat2_fil_sort(lset(sli),7)]*256/1080;
    scatter(xybefore_l(:,1),xybefore_l(:,2),420,'p','MarkerFaceColor',lcol(sli,:),...
        'MarkerEdgeColor','k');
    hold on
end

%export_fig sk_size_effect_illustration.png
%%
%%plot individual skyrmions from small set
%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
xoffset=415;%180417-1_fp553_1b_d3_2um_n4k-p750
xybefore_s=[fullstat2_fil_sort(1:topn,6)-xoffset,fullstat2_fil_sort(1:topn,7)]*256/1080;
xyafter_s=[fullstat2_fil_sort(1:topn,4),fullstat2_fil_sort(1:topn,5)]*256/1080+xybefore_s;
p_id_s=fullstat2_fil_sort(1:topn,2);

xplot_s=[xybefore_s(:,1)';xyafter_s(:,1)'];
yplot_s=[xybefore_s(:,2)';xyafter_s(:,2)'];


win_size=300;%nm
win_px=round((win_size/13000)*256);
win_r=round(win_px/2);
xlimits=[118 169];
ylimits=[86 137];
for p_i=[19 84 107]%1:length(p_id_s)

    plotx=xybefore_s(p_i,1)-1;ploty=xybefore_s(p_i,2)+1;
    if (plotx>xlimits(1))&&(plotx<xlimits(2))&&(ploty>ylimits(1))&&(ploty<ylimits(2))
    imbefore=imread(strcat(imfile,num2str(p_id_s(p_i)-1),'_MFM.tiff'));
%     figure;
%     imshow(imbefore); axis equal;
%     hold on
%     plot(plotx,ploty,'g*')
     plotx_rd=round(plotx);ploty_rd=round(ploty);
     dx=(xyafter_s(p_i,1)-xybefore_s(p_i,1))/2;
     dy=(xyafter_s(p_i,2)-xybefore_s(p_i,2))/2;
     rescalex=(xybefore_s(p_i,1)-plotx_rd+win_r)*20;
     rescaley=length(im_crop)-(xybefore_s(p_i,2)-ploty_rd+win_r+1)*20;
%     xlim([plotx-win_r plotx+win_r])
%     ylim([ploty-win_r ploty+win_r])
    
    im_crop=imbefore(ploty_rd-win_r:ploty_rd+win_r,plotx_rd-win_r:plotx_rd+win_r);
    im_crop=imresize(im_crop,20,'nearest');
    
    figure;
    imshow(im_crop)
    hold on
    scatter(rescalex,rescaley,80,'MarkerFaceColor','r',...rescaley
        'MarkerEdgeColor','r','MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
    axis equal
    hold on
    plot([rescalex,rescalex+dx*20],[rescaley,rescaley+dy*20],'-r','linewidth',2)
    export_fig([strcat('sk_small_arrow_',num2str(p_i)),'.png'],'-png')
    %imwrite(im_crop,strcat('sk_small_',num2str(p_i),'.png'))
    end
end

%%
%%plot individual skyrmions from large set
%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
xybefore_l=[fullstat2_fil_sort((ee+1-topn):ee,6)-xoffset,fullstat2_fil_sort((ee+1-topn):ee,7)]*256/1080;
p_id_l=fullstat2_fil_sort((ee+1-topn):ee,2);

win_size=300;%nm
win_px=round((win_size/13000)*256);
win_r=round(win_px/2);
xlimits=[118 169];
ylimits=[86 137];
for p_i=[979]-ee+topn%1:length(p_id_l)

    plotx=xybefore_l(p_i,1);ploty=xybefore_l(p_i,2);
    if (plotx>xlimits(1))&&(plotx<xlimits(2))&&(ploty>ylimits(1))&&(ploty<ylimits(2))
    imbefore=imread(strcat(imfile,num2str(p_id_l(p_i)-1),'_MFM.tiff'));
%     figure;
%     imshow(imbefore); axis equal;
%     hold on
%     plot(plotx,ploty,'g*')
     plotx_rd=round(plotx);ploty_rd=round(ploty);
     dx=(xyafter_l(p_i,1)-xybefore_l(p_i,1))/2;
     dy=(xyafter_l(p_i,2)-xybefore_l(p_i,2))/2;
     rescalex=(xybefore_l(p_i,1)-plotx_rd+win_r)*20;
     rescaley=length(im_crop)-(xybefore_l(p_i,2)-ploty_rd+win_r+1)*20;
%     xlim([plotx-win_r plotx+win_r])
%     ylim([ploty-win_r ploty+win_r])
    
    im_crop=imbefore(ploty_rd-win_r:ploty_rd+win_r,plotx_rd-win_r:plotx_rd+win_r);
    im_crop=imresize(im_crop,20,'nearest');
    
    figure;
    imshow(im_crop)
    hold on
    scatter(rescalex,rescaley,80,'MarkerFaceColor','b',...rescaley
        'MarkerEdgeColor','b','MarkerFaceAlpha',.3,'MarkerEdgeAlpha',.3);
    axis equal
    hold on
    plot([rescalex,rescalex+dx*20],[rescaley,rescaley+dy*20],'-b','linewidth',2)
    export_fig([strcat('sk_large_arrow_',num2str(ee-topn+p_i)),'.png'],'-png')
    %imwrite(im_crop,strcat('sk_large_',num2str(ee-topn+p_i),'.png'))
    end
end

%%
%color plot of size

xybefore_all=[fullstat2_fil_sort(:,6)-xoffset,fullstat2_fil_sort(:,7)]*256/1080;
xyafter_all=[fullstat2_fil_sort(:,4),fullstat2_fil_sort(:,5)]*256/1080+xybefore_all;
cmap=colormixer([255,0,0;0,0,0],length(xybefore_all(:,1)));

xplot_all=[xybefore_all(:,1)';xyafter_all(:,1)'];
yplot_all=[xybefore_all(:,2)';xyafter_all(:,2)'];

figure;
imshow(im_com);
hold on
for plot_i=fliplr(1:length(xybefore_all(:,1)))
    plot1=plot(xplot_all(:,plot_i),yplot_all(:,plot_i),'-','color',cmap(plot_i,:));
    plot1.Color(4) = 0.7;
    hold on
    plot2=plot(xybefore_all(plot_i,1),xybefore_all(plot_i,2),'.','color',cmap(plot_i,:),'MarkerSize',20);
    plot2.Color(4) = 0.7;
end

xlim(xlimits)
ylim(ylimits)
set(gcf,'position',1.0e+03 * [0.0010    0.0410    1.5360    0.7488])

if saveit
    export_fig edge_effect_neg_j_coloursize_illustration.png
end
% figure(com_fig);
% plot(xplot,-yplot);
% hold on
% plot(xybefore_s(:,1),-xybefore_s(:,2),'.k');hold on

%%
%by histogram edges
%small sizes
sk_s_size_i=(sksize_fil>=size_edge(size_s_bin_i)).*(sksize_fil<=size_edge(size_s_bin_i+1))==1;
%large sizes
sk_l_size_i=(sksize_fil>=size_edge(size_l_bin_i)).*(sksize_fil<=size_edge(size_l_bin_i+1))==1;    

xybefore_s=[fullstat2_fil(sk_s_size_i,6),fullstat2_fil(sk_s_size_i,7)]*256/1080;
xyafter_s=[fullstat2_fil(sk_s_size_i,4),fullstat2_fil(sk_s_size_i,5)]*256/1080+xybefore_s;

xybefore_l=[fullstat2_fil(sk_l_size_i,6),fullstat2_fil(sk_l_size_i,7)]*256/1080;
xyafter_l=[fullstat2_fil(sk_l_size_i,4),fullstat2_fil(sk_l_size_i,5)]*256/1080+xybefore_l;

xplot_s=[xybefore_s(:,1)';xyafter_s(:,1)'];
yplot_s=[xybefore_s(:,2)';xyafter_s(:,2)'];

xplot_l=[xybefore_l(:,1)';xyafter_l(:,1)'];
yplot_l=[xybefore_l(:,2)';xyafter_l(:,2)'];
figure
% imshow((double(imbefore)./max(double(imbefore(:))))/2+0.5);
% hold on
plot(xplot_s,yplot_s);
hold on
plot(xybefore_s(:,1),xybefore_s(:,2),'.k');
axis equal
% figure(com_fig);
% plot(xplot,-yplot);
% hold on
% plot(xybefore_s(:,1),-xybefore_s(:,2),'.k');hold on

figure
% imshow((double(imbefore)./max(double(imbefore(:))))/2+0.5);
% hold on
plot(xplot_l,yplot_l);
hold on
plot(xybefore_l(:,1),xybefore_l(:,2),'.k');
axis equal
% xlim([84,84+80])
% ylim([227-160,227])

% figure(com_fig);
% plot(xplot,-yplot);
% hold on
% plot(xybefore_s(:,1),-xybefore_s(:,2),'.k');hold on

%%
%filter via bin3d
sksize=newfullstat2(:,9)*conv;
p_no=newfullstat2(:,2);
[vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);
[jA3,j_edgeA3,sksizeA3,sksize_edgeA3,vA3,vA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,vsk_flow,1,size_edge);
vA3(countsA3<count_min)=nan;

%%plot all
figure;
errorbar(sksizeA3,vA3,vA3std,'-o','DisplayName','all j_f_l_o_w');
hold on
plot(size_bins(size_s_bin_i),mean(r_cor_fil(sk_s_size_i)),'ro');
plot(size_bins(size_l_bin_i),mean(r_cor_fil(sk_l_size_i)),'ro');



%%
%filter via bin3d
[jA3,j_edgeA3,sksizeA3,sksize_edgeA3,thetaA3,thetaA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,theta_flow,1,size_edge);
thetaA3(countsA3<count_min)=nan;
thetaA3std(countsA3<count_min)=nan;
%%plot all
figure;
errorbar(sksizeA3,thetaA3,thetaA3std,'-o','DisplayName','all j_f_l_o_w');

