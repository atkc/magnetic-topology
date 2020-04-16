foldername='C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp553_nanostructures\180412-1_fp553_1b_d2_2um_n4k-p750\analysis_750\CTF';
filename='Reg_180412_fp553_1b_d2_2um_p';

mode=1;%1:xy from fullstat2 2:xy from masterlist
if mode ==1
    newfullstat2=zeros(size(fullstat2)+[0,2]);
else
    newMasterList=zeros(size(MasterList));
end
imageSize=13;%um
saveInd = 0;  
%maxr=1.25:0.25:1.75;
approx_r_real=80;%nm
maxr=1.5;%fit std

pid_list=[36:40]%[1:24,27:40];%[5 6 7 38 39 40]%unique(p_sub);

fileList = dir('*.tiff');
fileList={fileList.name};
p_no=zeros(1,length(fileList));
for file_i=1:length(fileList)
    filename1=fileList{file_i};
    p_no(file_i)= str2double(regexp(filename1, '(?<=_p)\d+', 'match'));
end
[p_full_list]=sort(p_no);

xcor=0%-415.5-4.2539; %depends if analysis was done on ppt or on matlab
for p_i=1:length(pid_list)
    %****Load image*****
    if mode ==1
        fullfilename=strcat(filename,int2str(pid_list(p_i)-1),'_MFM.tiff')%fullstat2 xy is based on p -1
    else
        fullfilename=strcat(filename,int2str(pid_list(p_i)),'_MFM.tiff')%ML xy is based on p
    end
    im_fit=imread(fullfilename);
    
    %Resizing image to 1080p (ppt resolution)
    im_fit=imresize(im_fit,1080/256);
    try
        im_pos_id=logical(p_full_list==pid_list(p_i));
        im_pos_i=im_pos(im_pos_id,:);
        im_fit=imtranslate(im_fit,im_pos_i);
    end
    %Getting parameters
    [im_fit_size,~]=size(im_fit);
    approx_r=approx_r_real*im_fit_size/(imageSize*1000);
    fit_resize=im_fit_size/1080;
    if mode == 1
        %**position via fullstat2****
        p_sub=fullstat2(:,2);
        p_id_partial=(p_sub==pid_list(p_i));
        centroids=fullstat2(:,6:7);%use fullstat2 for now (only targeting shit that moved =D)
        %fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
        xy=centroids(p_id_partial,:);
        
    else
    %**position visa masterlist****
        xy=MasterList(:,pid_list(p_i),2:3);
        xy((xy(:,2)==0),:)=[];
        
    end
    

    figure;
    imshow(im_fit,[min(min(im_fit)),max(max(im_fit))]);
    hold on;
    plot((xy(:,1))+xcor,xy(:,2),'g*')
    %plot((xy(:,1)),xy(:,2),'g*')
    [sk_l,~]=size(xy);
    sksize_hold=zeros(sk_l,2);
    newxy_hold=zeros(sk_l,2);
    dgrayIm=double(im_fit);
    dgrayIm=dgrayIm*255/max(max(dgrayIm));
    for sk_i=1:sk_l
%         figure;
%         imshow(im_fit,[min(min(im_fit)),max(max(im_fit))]);
%         hold on
%         plot((xy(sk_i,1))+xcor,xy(sk_i,2),'g*')
        %Fitting algorithm
        %1. Estimating the window size (weighted fit)
        %disp('Estimate');
        [estfit,~,ex1,~]=m2_fit2d((approx_r/fit_resize), [xy(sk_i,1)+xcor,xy(sk_i,2)],dgrayIm,fullfilename,1.5,0,imageSize,0);        
        new_xy=(estfit(1:2));

        %2. Actual Fit (weighted fit)
        %disp('Final Fit');
        [isofit,~,fitstatus,res1]=m2_fit2d(estfit(4)/2, new_xy-1,dgrayIm,fullfilename,maxr,saveInd,imageSize,0);        
        %get fit parameters
        sksize_hold(sk_i,:)=[isofit(4),fitstatus];
        newxy_hold(sk_i,1)=isofit(1)-xcor;
        newxy_hold(sk_i,2)=isofit(2);
    end
    if mode == 1
        newfullstat2(p_id_partial,1:2)=fullstat2(p_id_partial,1:2);%index,pno
        newfullstat2(p_id_partial,8)=fullstat2(p_id_partial,8);%skid
        newfullstat2(p_id_partial,6:7)=newxy_hold;%new pos x y
        newfullstat2(p_id_partial,9:10)=sksize_hold;%size FWHM, fit status (if 1 = possibility of stripe fititnng)
    else
        newMasterList(1:length(sksize_hold(:,1)),pid_list(p_i),2:3)=newxy_hold;
        newMasterList(1:length(sksize_hold(:,1)),pid_list(p_i),4)=sksize_hold(:,1);
        newMasterList(:,pid_list(p_i),1)=MasterList(:,pid_list(p_i),1);
    end
end
%%
%Speed analysis using fullstat2 velocity (position identified via user,
%hence not fitted)
conv=13000/1080; %estimated nm/px
p_width=20;
c1=conv*10^-9/(p_width*10^-9);%m/s
sksize=newfullstat2(:,9)*conv;
% [N,~]=histcounts(x_coor,binE)
% [(avg_binE-x1)*13000/(1000*1080);N;avg_theta;std_theta]';

%%
%******1a.Dsk vs Vsk (average for all j/ all HA)******
%******1b.Dsk vs HA (average for all j/ all HA)*******

%p_id=[5 7 9 27 29 31 33]
%p_id=[6 8 10 8 30 32 34]
p_id=[6,7,39,40]
%p_id=[5 6 7 8 9 10 27 28 29 30 31 32 33 34];
%vlim=5.46
%for vlim = 0;%[10.06,7.76,5.46,3.16]
fil_para=ismember(fullstat2(:,2),p_id);
%fil_para=logical(fil_para.*(abs(r_cor')>vlim));

dsk1=70;
dsk2=200;

vsk_flow=r_cor(fil_para);
sksize_flow=sksize(fil_para);
theta_flow=theta_cor(fil_para);

for binN=6;

binE=linspace(dsk1,dsk2,binN)
avg_binE=zeros(1,length(binE)-1);
std_theta=zeros(1,length(binE)-1);
avg_theta=zeros(1,length(binE)-1);

std_v=zeros(1,length(binE)-1);
avg_v=zeros(1,length(binE)-1);
skN=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((sksize_flow>=binE(el)).*(sksize_flow<binE(el+1)));
    %angle dependence
    hold_theta=(180/pi)*theta_flow(hold_i);
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    avg_theta(el)= (mean(hold_theta(hold_theta>0)));
    std_theta(el)= (std(hold_theta(hold_theta>0)));

    %speed dependence
    hold_v=vsk_flow(hold_i);
    avg_v(el)= (mean(hold_v));
    std_v(el)= (std(hold_v));
    
    skN(el)=sum(hold_i);
    avg_binE(el)=(binE(el)+binE(el+1))/2;
end
figure
subplot(1,2,1)
errorbar((avg_binE),avg_theta,std_theta);
xlabel('Size(nm)')
ylabel('Theta(o)')

subplot(1,2,2)
errorbar((avg_binE),avg_v,std_v);
xlabel('Size(nm)')
ylabel('V_s_k(m/s)')

end

%%
%*****2.Vsk vs Theta (for each sksize bin)*****
%**********************************************
p_id=[6,7,39,40];
%p_id=[5 6 7 8 9 10 27 28 29 30 31 32 33 34];
%p_id=18:27;
%vlim=5.46
%for vlim = 0;%[10.06,7.76,5.46,3.16]
fil_para=ismember(fullstat2(:,2),p_id);
%fil_para=logical(fil_para.*(abs(r_cor')>vlim));

dsk1=70;
dsk2=200;

vsk_flow=r_cor(fil_para);
sksize_flow=sksize(fil_para);
theta_flow=theta_cor(fil_para);
binN2=5;
for binN=6;

binE=linspace(dsk1,dsk2,binN);
h1=figure;
for el=1:length(binE)-1
    hold_i=logical((sksize_flow>=binE(el)).*(sksize_flow<binE(el+1)));
    %angle dependence
    hold_theta=(180/pi)*theta_flow(hold_i);
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    
    %speed dependence
    hold_v=vsk_flow(hold_i);
    h2=figure;
    h=histogram(hold_v,binN2);
    
    vsk_E=h.BinEdges;
    vsk_bin_id=discretize(hold_v,vsk_E);
    std_theta=zeros(1,binN2);
    avg_theta=zeros(1,binN2);
    close(h2)
    skN=zeros(1,binN2);
    for bin_id=1:binN2
        bin_index=(vsk_bin_id==bin_id);
        avg_theta(bin_id)=mean(hold_theta(bin_index));
        std_theta(bin_id)=std(hold_theta(bin_index));     
    end
    figure(h1)
    hold on
    avg_binE(el)=(binE(el)+binE(el+1))/2;
    errorbar(vsk_E(1:binN2)+mean(diff(vsk_E))/2,avg_theta,std_theta,'-o','DisplayName',strcat(num2str(avg_binE(el),'%.1f'),'nm'))
end
hold off
legend show
ylabel('Theta(^o)')
xlabel('V_s_k(m/s)')
% ylim([0,inf])
end

%%
%*****3a.Dsk vs Theta (for each j, using pulse pattern as indicator to group)*****
%******3b.Dsk vs Vsk (for each j, using pulse pattern as indicator to group)******
%*****3c.Dsk vs Theta (for each j, using current magnitute to group)*****
%******3d.Dsk vs Vsk (for each j, using current magnitute to group)******

p_id=[6,7,8,9,39,40];%18:19%:27;
%p_id=[5 6 7 8 9 10 27 28 29 30 31 32 33 34];

p2i=unique(fullstat2(:,2));
p_id=sort(p_id);
f3=figure;
f4=figure;
for p_i=1:length(p_id)/2;
p_id_partial=p_id((2*(p_i-1)+1):(2*(p_i-1)+2));%[5 7 9 27 29 31 33 6 8 10 28 30 32 34];
[~,jid]=ismember(p2i,p_id_partial);
%[~,jid]=ismember(p2i,p_sub);
abs(i1(jid>0))

i_use=mean(abs(i1(jid>0)));
%vlim=5.46
%for vlim = 0;%[10.06,7.76,5.46,3.16]
fil_para=ismember(fullstat2(:,2),p_id_partial);
%fil_para=logical(fil_para.*(abs(r_cor')>vlim));

dsk1=70;
dsk2=200;

vsk_flow=r_cor(fil_para);
sksize_flow=sksize(fil_para);
theta_flow=theta_cor(fil_para);

for binN=6;
% show_theta=(180/pi)*theta_flow
% show_theta=show_theta+(show_theta<-90)*180;
% show_theta=show_theta-(show_theta>90)*180;
% figure
%hist(show_theta)
binE=linspace(dsk1,dsk2,binN);
avg_binE=zeros(1,length(binE)-1);
std_theta=zeros(1,length(binE)-1);
avg_theta=zeros(1,length(binE)-1);

std_v=zeros(1,length(binE)-1);
avg_v=zeros(1,length(binE)-1);
skN=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((sksize_flow>=binE(el)).*(sksize_flow<binE(el+1)));
    %angle dependence
    hold_theta=(180/pi)*theta_flow(hold_i);
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    hold_i2=(hold_theta>-90).*(hold_theta<90);
    hold_theta1=abs(hold_theta(hold_i2==1));
    avg_theta(el)= (mean((hold_theta1)));
    std_theta(el)= (std((hold_theta1)));

    %speed dependence
    hold_v=vsk_flow(hold_i);
    avg_v(el)= (mean(hold_v));
    std_v(el)= (std(hold_v));
    
    skN(el)=sum(hold_i);
    avg_binE(el)=(binE(el)+binE(el+1))/2;
end

figure(f3);
errorbar(avg_binE,avg_theta,std_theta,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.1f'),'e11 Am^-^2'));
xlabel('Size(nm)')
ylabel('Theta(o)')
hold on

figure(f4);
errorbar(avg_binE,avg_v,std_v,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.1f'),'e11 Am^-^2'));
xlabel('Size(nm)')
ylabel('V_s_k(m/s)')
hold on

end
end
figure(f3);
ylim([-5,60])
legend show
figure(f4);
legend show

%[(avg_binE)',avg_theta',std_theta',avg_v',std_v',skN']
[avg_theta',std_theta',avg_v',std_v',skN']
% [N,~]=histcounts(x_coor,binE)
% [(avg_binE-x1)*13000/(1000*1080);N;avg_theta;std_theta]';

%%
%*****4a.Dsk vs Theta (for each j, using current magnitute to group)*****
%******4b.Dsk vs Vsk (for each j, using current magnitute to group)******

p_id=[6,7,8,9,39,40];%18:19%:27;
%p_id=[5 6 7 8 9 10 27 28 29 30 31 32 33 34];

p2i=unique(newfullstat2(:,2));
[~,jid]=ismember(p2i,p_id);
i_use_all=unique(abs(i1(jid>0)));

p_id=sort(p_id);
p_sub=newfullstat2(:,2);
f5=figure;
f6=figure;
for i_use=i_use_all'
[~,jid]=ismember(abs(i1),i_use);
p_id_partial=p2i(jid>0);
%[~,jid]=ismember(p2i,p_sub);
%vlim=5.46
%for vlim = 0;%[10.06,7.76,5.46,3.16]
fil_para=ismember(newfullstat2(:,2),p_id_partial);
%fil_para=logical(fil_para.*(abs(r_cor')>vlim));

dsk1=60;
dsk2=200;

vsk_flow=r_cor(fil_para);
sksize_flow=sksize(fil_para);
theta_flow=theta_cor(fil_para);

for binN=6;
% show_theta=(180/pi)*theta_flow
% show_theta=show_theta+(show_theta<-90)*180;
% show_theta=show_theta-(show_theta>90)*180;
% figure
%hist(show_theta)
binE=linspace(dsk1,dsk2,binN);
avg_binE=zeros(1,length(binE)-1);
std_theta=zeros(1,length(binE)-1);
avg_theta=zeros(1,length(binE)-1);

std_v=zeros(1,length(binE)-1);
avg_v=zeros(1,length(binE)-1);
skN=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((sksize_flow>=binE(el)).*(sksize_flow<binE(el+1)));
    %angle dependence
    hold_theta=(180/pi)*theta_flow(hold_i);
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    hold_i2=(hold_theta>-90).*(hold_theta<90);
    hold_theta1=abs(hold_theta(hold_i2==1));
    avg_theta(el)= (mean((hold_theta1)));
    std_theta(el)= (std((hold_theta1)));

    %speed dependence
    hold_v=vsk_flow(hold_i);
    avg_v(el)= (mean(hold_v));
    std_v(el)= (std(hold_v));
    
    skN(el)=sum(hold_i);
    avg_binE(el)=(binE(el)+binE(el+1))/2;
end

figure(f5);
errorbar(avg_binE,avg_theta,std_theta,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.1f'),'e11 Am^-^2'));
xlabel('Size(nm)')
ylabel('Theta(o)')
hold on

figure(f6);
errorbar(avg_binE,avg_v,std_v,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.1f'),'e11 Am^-^2'));
xlabel('Size(nm)')
ylabel('V_s_k(m/s)')
hold on

end
end
figure(f5);
ylim([-5,60])
legend show
figure(f6);
legend show

%[(avg_binE)',avg_theta',std_theta',avg_v',std_v',skN']
[avg_theta',std_theta',avg_v',std_v',skN']
% [N,~]=histcounts(x_coor,binE)
% [(avg_binE-x1)*13000/(1000*1080);N;avg_theta;std_theta]';