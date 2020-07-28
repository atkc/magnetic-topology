%%*************************************************************************
%%***************************Information***********************************
%%*************************************************************************
%This program needs the user to identify the positions of skyrmions before
%hand and saving it as a skeleton image which only have colors:
%1. ANY COLOUR AS BACKGROUND (identified as bg col if it has the largest px
%countcd
%2. ANY NUMBER OF UNIQUE COLOURS to tag skyrmion positions/motion 
%identified by the user 
%3. additional skyrmions created are not addressed. ie. DO NOT INCLUDE
%CREATION OF SKYRMIONS
%Summary: the skeleton image is a very human task and might be subjected to
%individual human abilities - ie fraught with human errors/biasness

%Main data output:
%1. %fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
%2. %masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
%%*************************************************************************
%%**********************Additional Information*****************************
%% Created by Anthony K.C Tan for skyrmion research
%%*************************************************************************

%%==========directory of skeleton file for motion tracking=================C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp553_nanostructures\
cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp553_nanostructures\180410-4_fp553_1b_d2_2um_n4k-p1650\CTF\skel (p16-24)')
filename='pulse (';
fullFileName1=strcat(filename,'16)','.png');
pulseId=1:29;
flip_n=-1;%1: +V-V+V... | -1: -V+V-V...
%%==========directory of skeleton file for motion tracking=================

%%===================Size fitting Options/Information======================
sksz=false; %measure size?
fitframe=[26 27 28]; %which frames to fit? number should correspnd to the pulse number
radius=0.1*1080/13;% rough radius
%%==============directory of raw files to fit for size=====================
fitfiledir=('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp553_nanostructures\180410-4_fp553_1b_d2_2um_n4k-p1650\CTF\skel (p16-24)');
fitfilename='test';%MFM_170421_fp226_2um_d2_n4k-p1100_p26
%%==========Additional info on size fitting================================
%%Please optimize the 
%1. window size for fitting -> see m2_fit.m file
%2. check options to save individual fits and also to check individual fits
%   -> see m2_fit.m file

%%*************************************************************************
%%*************************************************************************
%%*****************************Processing begins here**********************
%%*************************************************************************


%%******************************initialization*****************************


%%load skeleton image to 
im=imread(fullFileName1);
%Get list of unique tracker colors
col_list=getCol_v2(im);

%Creation of Master list of skyrmions seperated by pulse number
MasterList=zeros(300,50,4);%[#sk]; [frame/pulse no]; [sk-id, x, y, size]

%Creation of full list of skyrmions in one giant list
fullstat2=zeros(10000,8);
%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min]
fullstat_index=1;%index for proper allocationof skyrmion information in fullstat2 vector

threshold=50;%~60m/s

%tracking for different coloured trackers
for colID=1:length(col_list)
   
%Clear prior tracker information
clearvars -except flip_n im col_list filename fullFileName fullFileName1 colID pulseId sksz vol i1 fullstat2 fullstat_index MasterList threshold

%display colour of tracker being tracked
display(strcat('color:',num2str(col_list(colID,:))));
    
%reading first image
im=imread(fullFileName1);
[ ~, beforeOld] = positionxy_v2(im,col_list(colID,:));%assign as old position
oldIm=im;%assign im as old im (previous frame)

%Assigning Unique sk ID
skid_offset=max(fullstat2(:,8));%account for different colored trackers
MasterList(skid_offset+1:skid_offset+length(beforeOld),pulseId(1)-1,2:3)=beforeOld;
MasterList(skid_offset+1:skid_offset+length(beforeOld),pulseId(1)-1,1)=(1:length(beforeOld))+skid_offset;%%sk-id
skmax=length(beforeOld);%what is this for?

for imageInd = pulseId%[2 3 6 7 10 11 14 15]%2:noOfimages

fprintf('Analyzing image %i\n',imageInd);
fullFileName=strcat(filename,int2str(imageInd),')','.png');
im=imread(fullFileName);

[ afterNew, afterOld] = positionxy_v2(im,col_list(colID,:));
%afterNew: newly created skyrmion positions in the after frame
%afterNew: Previosu skyrmion positions from the before frame in the after frame

skID=MasterList(skid_offset+1:skid_offset+length(beforeOld),imageInd-1,1);
%skID of skyrmions from before frame (beforeOld)


[mbefore,~]=size(beforeOld);
[mafter,~]=size(afterOld);
offset=abs(mafter-mbefore);

% hold on
% if imageInd==2
%     plot(afterOld(:,1),afterOld(:,2),'bo');
% else
%     plot(afterOld(:,1),afterOld(:,2),'go');
% end

[~,iaOld,ibOld]=intersect(afterOld,beforeOld,'rows','stable');

%%*****capture old skyrmions in after frame that did not move******
MasterList(skid_offset+1:skid_offset+length(ibOld),imageInd,1)=skID(ibOld);
MasterList(skid_offset+1:skid_offset+length(ibOld),imageInd,2:3)=beforeOld(ibOld,1:2);

%%*****capture old skyrmions in after frame that move******

[C,~,sbOld] = setxor(afterOld,beforeOld,'rows','stable');
skID_Unique=skID(sbOld);
afterUnique=C(1:(length(C)-offset)/2,:);
beforeUnique=C((((length(C)-offset)/2)+1):end,:);%beforeUnique>=afterUnique
%afterUnique: Unique skyrmion positions but not newly created from after 
%frame (aka skyrmions that moved from the before frame)
%beforeUnique: Unique skyrmion positions from before frame but not newly
%created (aka skyrmions that moved in the after fame)

% ************************************************************************
% % *******vectorization method --> limitiation is on permutation (n<11)
% ************************************************************************

% DistMatrix=pdist2(beforeUnique,afterUnique);%p11>p22
% [mbefore,~]=size(beforeUnique);
% [mafter,~]=size(afterUnique);
% Q=perms(1:mbefore).';
% Q=Q(1:mafter,:);
% Q=(unique(Q','rows'))';%p11
% P=repmat((1:mafter).',1,size(Q,2));%p22
% idx=sub2ind(size(DistMatrix),Q,P);
% [result,where] = min(sum(DistMatrix(idx)));
% statIndEnd=length(DistMatrix(idx(:,where)));
% fullstat(statInd:(statInd+statIndEnd-1),2)=DistMatrix(idx(:,where));
% fullstat(statInd:(statInd+statIndEnd-1),1)=imageInd*ones(statIndEnd,1);
% statInd=statInd+statIndEnd;

% ************************************************************************
% % *******DOOMED*********************************************************
% ************************************************************************

[mafter_unique,~]=size(afterUnique);

%%***randomized 
repeat=true;
repeat_i=1; %i know its inefficient
while (repeat)
%     fig=imshow(oldIm(:,:,1)>120);
    repeat=false;
    
    %randomized order
    p0 = randperm(mafter_unique);
    %order from top to btm
    scapegoat=afterUnique;
    scapegoat(:,2)=round(scapegoat(:,2)/100)*100;
    [~,p1] = sortrows(scapegoat,[2,1]);
    p1=p1';
    %order from btm to top
    p2=fliplr(p1);
    if repeat_i==1
        p=p1;
    else
        p=p2;
    end

    skID_UniqueDup=skID_Unique;
    beforeUniqueDup=beforeUnique;
    for i = p
        minDist=999999;
        minx=0;
        miny=0;
        [mbefore_unique,~]=size(beforeUniqueDup);
        for j= 1:mbefore_unique
            
            dist=pdist([afterUnique(i,:);beforeUniqueDup(j,:)]);
            if dist<minDist
                minDist=dist;
                minj=j;
                minx=afterUnique(i,1)-beforeUniqueDup(j,1);
                miny=afterUnique(i,2)-beforeUniqueDup(j,2);
            end
        end
        coortext=beforeUniqueDup(minj,:);

%             text(coortext(1),coortext(2), sprintf('    %d', statInd2), ...
%             'HorizontalAlignment', 'right', ...
%             'VerticalAlignment', 'middle','color','red');
        %abs(minDist)
        skID_min=skID_UniqueDup(minj);
        
        %update MasterList after skyrmion from before and after are matched
        MasterList(skid_offset+length(ibOld)+i,imageInd,1)=skID_min;
        MasterList(skid_offset+length(ibOld)+i,imageInd,2:3)=afterUnique(i,:);
        skID_UniqueDup(minj)=[];
        beforeUniqueDup(minj,:)=[];
        
        %update fullstat2 after skyrmion from before and after are matched
        fullstat2(fullstat_index,:)=[fullstat_index,imageInd,minDist,minx,miny,coortext(1),coortext(2),skID_min];
        fullstat_index=fullstat_index+1;
        
        %check for detection errors
%         if abs(minDist) >threshold
%             %abs(minDist)
%             repeat=true;
%             repeat_i=repeat_i+1;
%         end
    end
    
%     if repeat
%         fullstat_index=fullstat_index-mafter_unique;
%     end
    
end
% SavefullFileName=strcat(filename,int2str(imageInd-1),')_edit','.png');
% print(SavefullFileName,'-dpng');

if ~isempty(afterNew)
    MasterList((skid_offset+length(ibOld)+length(p)+1):(skid_offset+length(ibOld)+length(p)+numel(afterNew)/2),imageInd,2:3)=afterNew;
    MasterList((skid_offset+length(ibOld)+length(p)+1):(skid_offset+length(ibOld)+length(p)+numel(afterNew)/2),imageInd,1)=(skmax+1):(skmax+numel(afterNew)/2);
    skmax=skmax+numel(afterNew)/2;
end

beforeOld=[MasterList(skid_offset+1:(skid_offset+length(ibOld)+length(p)+numel(afterNew)/2),imageInd,2),MasterList(skid_offset+1:(skid_offset+length(ibOld)+length(p)+numel(afterNew)/2),imageInd,3)];
imageInd=imageInd+1;
oldIm=im;
end
fullstat2=fullstat2(1:(fullstat_index-1),:);
sum(fullstat2(:,1)==23)
% for pulseInd=[4 5 8 9 12 13 16 17 20 21]
%     fullstat2(fullstat2(:,2)==pulseInd,:)=[];
% end

%%write a sort function*****
%%size fitting is not tune for colour tracker analysis
if (sksz==true)
    cd(fitfiledir);
    for p=fitframe
        rawIm=imread(strcat(fitfilename,int2str(p),'.png'));
        dgrayIm=im2double(rawIm(:,:,1))*155;
        skID_fit=MasterList(:,p+1,1);
        coorxy=[MasterList(:,p+1,2),MasterList(:,p,3)];
        coorxy=coorxy(skID_fit~=0,:);
        z=length(coorxy);
        isofit=m2_fit2d(radius,coorxy, dgrayIm,'');
        MasterList(1:z,p+1,4)=isofit(:,4); %fwhm
    end
end
%***************************plot graph to check***************************
% conv=13000/1080; %estimated nm/px
% p_width=20;
% %quick frame statistics
% frame_stats=zeros(100,3);
% framelist=unique(fullstat2(:,2))';
% for frameid=framelist
%     idx=(fullstat2(:,2)==frameid);
%     v=fullstat2(idx,3);
%     if ~isempty(v)
%         avg_v=mean(abs(v))*conv*10^-9/(p_width*10^-9);
%         med_v=median(abs(v))*conv*10^-9/(p_width*10^-9);
%         max_v=max(abs(v))*conv*10^-9/(p_width*10^-9);%avg_v+2*std(abs(v))*conv*10^-9/(p_width*10^-9);
%         frame_stats(frameid,1)=avg_v;
%         frame_stats(frameid,2)=med_v;
%         frame_stats(frameid,3)=max_v;
%     end
% end
% frame_stats=frame_stats(min(framelist):max(framelist),:);
% figure
% plot(i1,frame_stats(:,1),'bo','LineWidth',2)
% xlabel('Current Density (A/m^2')
% ylabel('Speed(|m/s|)')
% title('Average Speed');
% figure
% plot(i1,frame_stats(:,3),'ro','LineWidth',2)
% xlabel('Current Density (A/m^2')
% ylabel('Speed(|m/s|)')
% title('Max v');
%***************************plot graph to check***************************
end

%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min]
fullstat2=sortrows(fullstat2,[2,8]);
conv=13000/1080; %estimated nm/px
p_width=20;
c1=conv*10^-9/(p_width*10^-9);


%rough cart plot % get vx_cor and vy_cor
col_map=jet(max(unique(fullstat2(:,2))));
vx_cor=zeros(1,length(fullstat2));
vy_cor=zeros(1,length(fullstat2));
v_cor=zeros(1,length(fullstat2));
f1=figure;
hold on
for ski=1:length(fullstat2)
    if mod(fullstat2(ski,2),2)==0
        plot(flip_n*fullstat2(ski,4)*c1,-flip_n*fullstat2(ski,5)*c1,'o','color',col_map(fullstat2(ski,2)-pulseId(1)+2,:),'MarkerSize', 10)
        vx_cor(ski)=flip_n*fullstat2(ski,4)*c1;
        vy_cor(ski)=-flip_n*fullstat2(ski,5)*c1;

    else
        plot(-flip_n*fullstat2(ski,4)*c1,flip_n*fullstat2(ski,5)*c1,'o','color',col_map(fullstat2(ski,2)-pulseId(1)+2,:),'MarkerSize', 10)
        vx_cor(ski)=-flip_n*fullstat2(ski,4)*c1;
        vy_cor(ski)=flip_n*fullstat2(ski,5)*c1;
    end
            v_cor(ski)=fullstat2(ski,3)*c1;
end
axis equal
xlabel('x speed(|m/s|)')
ylabel('y speed(|m/s|)')

[theta_cor,r_cor]=cart2pol(vy_cor,-vx_cor);

%Hall Angle vs J plot
f2=figure;
frame_list=unique(fullstat2(:,2));
avg_theta=zeros(floor(length(frame_list)/2),1);
std_theta=zeros(floor(length(frame_list)/2),1);
for i=1:length(frame_list)/2
    hold_theta=(180/pi)*theta_cor(logical((fullstat2(:,2)==frame_list(i*2))+(fullstat2(:,2)==frame_list(i*2-1))));
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    hold_i=(hold_theta>-90).*(hold_theta<90);
    hold_theta1=hold_theta(hold_i==1);
    avg_theta(i)= (mean(hold_theta1));
    std_theta(i)= (std(hold_theta1));
end
if abs(i1(end))<abs(i1(1))
    i2=flipud(unique(abs(i1)));
else
    i2=unique(abs(i1));
end
errorbar(i2(1:length(avg_theta)),avg_theta,std_theta,'-o')
xlabel('j(|A/m^2|)')
ylabel('Theta(o)')

%Speed (only sk in motion) vs J plot
f4=figure;
%[theta_cor,r_cor]=cart2pol(vy_cor,-vx_cor);

frame_list=unique(fullstat2(:,2));
avg_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
std_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
for i=1:length(frame_list)
    hold_v=r_cor(logical((fullstat2(:,2)==frame_list(i))));
    avg_v(i)= (mean(hold_v));
    std_v(i)= (std(hold_v));
end
i2=(abs(i1));
errorbar(i2(1:length(avg_v)),avg_v,std_v,'*r')
xlabel('j(|A/m^2|)')
ylabel('speed(|m/s^2|)')

%Speed (all sk (inc ones not moving)) vs J plot
f5=figure;
%[theta_cor,r_cor]=cart2pol(vy_cor,-vx_cor);
total_sk=max(fullstat2(:,8));
frame_list=unique(fullstat2(:,2));
avg_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
std_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
for i=1:length(frame_list)
    hold_v=r_cor(logical((fullstat2(:,2)==frame_list(i))));
    avg_v(i)= (mean([hold_v,zeros(1,total_sk-length(hold_v))]));
    std_v(i)= (std(hold_v));
end
i2=(abs(i1));
errorbar(i2(1:length(avg_v)),avg_v,std_v,'*r')
xlabel('j(|A/m^2|)')
ylabel('speed(|m/s^2|)')

%Speed vs Hall angle plot

for nedge=23
figure;
r=r_cor%(pID<p_lim);
theta=theta_cor%(pID<p_lim);
[N,edges] = histcounts(r,nedge);
avg_v=zeros(1,length(N));
avg_theta=zeros(1,length(N));
std_theta=zeros(1,length(N));
for el=1:length(edges)-1
    hold_i=logical((r>=edges(el)).*(r<edges(el+1)));
    hold_theta=(180/pi)*theta(hold_i)
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    avg_theta(el)= (mean(hold_theta))
    std_theta(el)= (std(hold_theta));
    avg_v(el)=(edges(el)+edges(el+1))/2;
end

errorbar(avg_v,avg_theta,std_theta);
ylim([-50 50])
xlabel('speed(|m/s^2|)')
ylabel('Theta(o)')
end


%Hall angle plot vs X plot
x1=min(fullstat2(:,6));
x2=max(fullstat2(:,6));
p_sub=unique(fullstat2(:,2));
%pid=p_sub(logical(i1<(-5.5*1e11)));
for p1=7
pid=[27 30]
vlim=5.46
%for vlim = 0;%[10.06,7.76,5.46,3.16]
fil_para=ismember(fullstat2(:,2),pid);
%fil_para=logical(fil_para.*(abs(r_cor')>vlim));
theta_cor_edge=theta_cor(fil_para);
x_coor=fullstat2(:,6);
x_coor=x_coor(fil_para);
for binN=[22];
figure
binE=linspace(x1,x2,binN);
avg_binE=zeros(1,length(binE)-1);
std_theta=zeros(1,length(binE)-1);
avg_theta=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((x_coor>=binE(el)).*(x_coor<binE(el+1)));
    hold_theta=(180/pi)*theta_cor_edge(hold_i);
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    avg_theta(el)= (mean(hold_theta));
    std_theta(el)= (std(hold_theta));
    avg_binE(el)=(binE(el)+binE(el+1))/2;
end
errorbar((avg_binE-x1)*13000/1080,avg_theta,std_theta);
ylim([-40 40])
xlabel('edge(um)')
ylabel('Theta(o)')
end
[N,~]=histcounts(x_coor,binE)
[(avg_binE-x1)*13000/(1000*1080);N;avg_theta;std_theta]';
end


%sk speed vs X plot
x1=min(fullstat2(:,6));
x2=max(fullstat2(:,6));
for binN=14;
    figure
binE=linspace(x1,x2,binN);
x_coor=fullstat2(:,6);
r_cor_edge=r_cor(logical((fullstat2(:,2)==12)+(fullstat2(:,2)==10)));
x_coor=x_coor(logical((fullstat2(:,2)==12)+(fullstat2(:,2)==10)));
avg_binE=zeros(1,length(binE)-1);
std_r=zeros(1,length(binE)-1);
avg_r=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((x_coor>=binE(el)).*(x_coor<binE(el+1)));
    hold_r=r_cor_edge(hold_i)
    avg_r(el)= (mean(hold_r))
    std_r(el)= (std(hold_r));
    avg_binE(el)=(binE(el)+binE(el+1))/2;
end
errorbar((avg_binE-x1)*13000/1080,avg_r,std_r);
% ylim([-40 40])
xlabel('edge(um)')
ylabel('Speed(m/s)')
end
[N,~]=histcounts(x_coor,binE);
%********polar plot
for ski=fliplr(1:length(fullstat2))
        polarplot(theta_cor(ski),r_cor(ski),'o','color',col_map(fullstat2(ski,2),:),'MarkerSize', 7)
        hold on
end
pax = gca;
pax.ThetaZeroLocation = 'top';
pax.RAxisLocation=90;

%population graph
total_sk=max(fullstat2(:,8));
id_1=[3:8];
p=zeros(length(id_1),2);
for i=1:length(id_1)
    p(i,1)=sum(fullstat2(:,2)==id_1(i));
    p(i,2)=p(i,1)/total_sk;
end
