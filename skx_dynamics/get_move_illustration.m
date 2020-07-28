folder='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180412-1_fp553_1b_d2_2um_n4k-p750\analysis_750\CTF\';
imfile='Reg_180412_fp553_1b_d2_2um_p';
data_folder='';
% folder='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180417-1_fp553_1b_d3_2um_n4k-p750\analysis\registered_ctf\';
% data_folder='skel (p4-34)\';
% imfile='Reg_180417_fp553_1b_d3_2um_p';
cd(folder)
% datasets
load(strcat(data_folder,'fullstat2-combine.mat'));
load(strcat(data_folder,'fullstat2-size-combine.mat'));
load(strcat(data_folder,'i1-combine.mat'));
load(strcat(data_folder,'r_cor-combine.mat'));
load(strcat(data_folder,'theta_cor-combine.mat'));
%[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x(before),coor_y(before),skID_min,radius];
skID=unique(fullstat2(:,8));
colID=summer(max(skID)+100);

%180412-1_fp553_1b_d2_2um_n4k-p750 flow pulse id
p_range=[6 7 8];%+j
%p_range=[6,40];%-j
colInt=linspace(0.3,1,length(p_range));
%newfullstat2(:,3:5)=fullstat2(:,3:5);
conv=13000/1080;
minDist=1080/256;%min pixel size
[fullstat2_fil,r_cor_fil,theta_cor_fil]=minDist_filter(fullstat2,r_cor,theta_cor,minDist);
com_fig=figure;
im_com=zeros([256,256]);
skID_trim=skID;
for p_i=1:length(p_range)
    skID_p_i=unique(fullstat2_fil(fullstat2_fil(:,2)==p_range(p_i),8));
    ia=ismember(skID_trim,skID_p_i);
    skID_trim=skID_trim(ia);
    length(skID_trim)
    imafter=imread(strcat(imfile,num2str(p_range(p_i)),'_MFM.tiff'));
    im_com=im_com+double(imafter);
end
imshow(rescale(im_com,0.5,1));
hold on
% xoffset=415;
xoffset=0;
for p_i=1:length(p_range)
    fullstat2_p_i=fullstat2_fil(fullstat2_fil(:,2)==p_range(p_i),:);
    imafter=imread(strcat(imfile,num2str(p_range(p_i)),'_MFM.tiff'));
    skID_p_i=fullstat2_p_i(:,8);
    fullstat2_p_i=fullstat2_p_i(ismember(skID_p_i,skID_trim),:);
    xybefore=[fullstat2_p_i(:,6)-xoffset,fullstat2_p_i(:,7)]*256/1080;
    xyafter=[fullstat2_p_i(:,4),fullstat2_p_i(:,5)]*256/1080+xybefore;
   
    figure;
%     imshow(imbefore);
%     hold on
%     plot(xybefore(:,1),xybefore(:,2),'.k')
%     figure;
    imshow(rescale(imafter,0.5,1));
    hold on
    for ski=1:length(skID_trim)       
        plot(xyafter(ski,1),xyafter(ski,2),'o',...
            'LineWidth',0.7,...
            'MarkerEdgeColor','k',...
            'MarkerSize',7,...
            'MarkerFaceColor',...
            colID(skID_trim(ski)+(p_i-1)*50,:));
    end
%     xlim([91,152])
%     ylim([83,166])
    set(gcf,'position',1.0e+03 * [0.0010    0.0410    1.5360    0.7488])
    figure(com_fig);
    hold on
    if p_i==2
        colline='b';
    else
        colline='k';
    end

    for ski=1:length(skID_trim)
        plot(xyafter(ski,1),xyafter(ski,2),'o',...
            'LineWidth',0.7,...
            'MarkerEdgeColor','k',...
            'MarkerSize',7,...
            'MarkerFaceColor',...
            colID(skID_trim(ski)+(p_i-1)*50,:));
    end
    if p_i>1
        xplot=[xybefore(:,1)';xyafter(:,1)'];
        yplot=[xybefore(:,2)';xyafter(:,2)']; 
        quiver(xybefore(:,1)',xybefore(:,2)',xyafter(:,1)'-xybefore(:,1)',xyafter(:,2)'-xybefore(:,2)',0.25...
            ,'LineWidth',1.5,'color',colline)
        %plot(xplot,yplot,'-k');
    end
    axis equal

end
figure(com_fig);
% xlim([91,152])
% ylim([83,166])
set(gcf,'position',1.0e+03 * [0.0010    0.0410    1.5360    0.7488])
axis equal;

%%
figure;
imshow(rescale(im_com,0.5,1));
hold on;

for p_i=1:length(p_range)
    fullstat2_p_i=fullstat2_fil(fullstat2_fil(:,2)==p_range(p_i),:);
    xybefore=[fullstat2_p_i(:,6),fullstat2_p_i(:,7)]*256/1080;
    xyafter=[fullstat2_p_i(:,4),fullstat2_p_i(:,5)]*256/1080+xybefore;
    if p_i==2
        xybefore(:,2)=xybefore(:,2)+2;
        xyafter(:,2)=xyafter(:,2)+2;
        xybefore(:,1)=xybefore(:,1)+0.5;
        xyafter(:,1)=xyafter(:,1)+0.5;
    end
    xplot=[xybefore(:,1)';xyafter(:,1)'];
    yplot=[xybefore(:,2)';xyafter(:,2)'];
    plot(xplot,yplot,'-k','LineWidth',1);
    plot(xybefore(:,1),xybefore(:,2),'.k','LineWidth',1);

end
xlim([84,84+80])
ylim([40,200])
set(gcf,'position',1.0e+03 * [0.0010    0.0410    1.5360    0.7488])
export_fig edge_effect_pos_j_illustration.png
%%
% Axes = zeros(nMdls);
% Axes(1) = axes;
% surf(Axes(1),B_axis,theta_axis,pl_Btheta);
% xlim(Axes(1),[0,80])
% ylim(Axes(1),[0,theta_axis(end)])
% view(2); shading flat; colormap(gray);
% xlabel('B Field (mT)');ylabel('Theta(^o)')
% colorbar;
% hold on;

p_range=[6,40];%-j

for p_i=1:length(p_range)
    fullstat2_p_i=fullstat2_fil(fullstat2_fil(:,2)==p_range(p_i),:);
    xybefore=[fullstat2_p_i(:,6),fullstat2_p_i(:,7)]*256/1080;
    xyafter=[fullstat2_p_i(:,4),fullstat2_p_i(:,5)]*256/1080+xybefore;
    imbefore=imread(strcat(imfile,num2str(p_range(p_i)-1),'_MFM.tiff'));
    imafter=imread(strcat(imfile,num2str(p_range(p_i)),'_MFM.tiff'));
    im_com=im_com+double(imbefore)+double(imafter);
%     figure;
%     imshow(imbefore);
%     hold on
%     plot(xybefore(:,1),xybefore(:,2),'.k')
%     figure;
%     imshow(imafter);
%     hold on
%     plot(xyafter(:,1),xyafter(:,2),'.k')
    xplot=[xybefore(:,1)';xyafter(:,1)'];
    yplot=[xybefore(:,2)';xyafter(:,2)'];
    figure
    imshow((double(imbefore)./max(double(imbefore(:))))/2+0.5);
    hold on
    plot(xplot,yplot);
    plot(xybefore(:,1),xybefore(:,2),'.k');
    axis equal
end

%%
figure;
imshow(rescale(im_com,0.5,1));
hold on;

for p_i=1:length(p_range)
    fullstat2_p_i=fullstat2_fil(fullstat2_fil(:,2)==p_range(p_i),:);
    xybefore=[fullstat2_p_i(:,6),fullstat2_p_i(:,7)]*256/1080;
    xyafter=[fullstat2_p_i(:,4),fullstat2_p_i(:,5)]*256/1080+xybefore;
    if p_i==2
        xybefore(:,2)=xybefore(:,2)+2;
        xyafter(:,2)=xyafter(:,2)+2;
        xybefore(:,1)=xybefore(:,1)+0.5;
        xyafter(:,1)=xyafter(:,1)+0.5;
    end
    xplot=[xybefore(:,1)';xyafter(:,1)'];
    yplot=[xybefore(:,2)';xyafter(:,2)'];
    plot(xplot,yplot,'-k','LineWidth',1);
    plot(xybefore(:,1),xybefore(:,2),'.k','LineWidth',1);

end
xlim([84,84+80])
ylim([227-160,227])
set(gcf,'position',1.0e+03 * [0.0010    0.0410    1.5360    0.7488])
export_fig edge_effect_neg_j_illustration.png