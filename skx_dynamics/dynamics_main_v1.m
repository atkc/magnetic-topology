%%*************************************************************************
%%***************************Information***********************************
%%*************************************************************************
%This program needs the user to identify the positions of skyrmions before
%hand and saving it as a skeleton image which only have colors:
%1. gray as background
%2. BLACK to indicate skyrmion positions (ie skyrmion was there in the
%   previous frame regardless of whether they moved or not
%3. red to indicate additional skyrmions (ie was not there in the previous
%   frame)
%Summary: the skeleton image is a very human task and might be subjected to
%individual human abilities - ie fraught with human errors/biasness
%%*************************************************************************
%%**********************Additional Information*****************************
%% Created by Anthony K.C Tan for skyrmion research
%%*************************************************************************

%%===================Size fitting Options/Information======================
sksz=false; %measure size?
fitframe=[26 27 28]; %which frames to fit? number should correspnd to the pulse number
radius=0.1*1080/13;
%%==========Additional info on size fitting================================
%%Please optimize the 
%1. window size for fitting -> see m2_fit.m file
%2. check options to save individual fits and also to check individual fits
%   -> see m2_fit.m file

%%==============directory of skeleton file=================================
cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\180412\skel')
filename='Reg_180412_fp553_1b_d2_2um_p (';
fullFileName=strcat(filename,'4)','.png');
%%==============directory of skeleton file=================================

%%==============directory of raw files to fit for size=====================
fitfiledir=('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170421\bio-analysis');
fitfilename='MFM_170421_fp226_2um_d2_n4k-p1100_p';%MFM_170421_fp226_2um_d2_n4k-p1100_p26
%%==============directory of raw files to fit for size=====================


%%*************************************************************************
%%*************************************************************************
%%*****************************Processing begins here**********************
%%*************************************************************************


%%******************************initialization*****************************
MasterList=zeros(200,50,4);%#sk; frame; sk-id, x, y, size

%%load skeleton image to 
im=imread(fullFileName);
[ ~, beforeOld] = positionxy( im );
MasterList(1:length(beforeOld),1,2:3)=beforeOld;
MasterList(1:length(beforeOld),1,1)=1:length(beforeOld);%%sk-id
skmax=length(beforeOld);
threshold=50;%~60m/s
%figure
%plot(beforeOld(:,1),beforeOld(:,2),'r*');
noOfimages=10;
% beforeOld=p0;
% afterOld=p1;
% [~,beforeOld]=positionxy(imBefore);
% [~,afterOld]=positionxy(imAfter);
fullstat=zeros(10000,2);%pulse#, velocity
statInd=1;

fullstat2=zeros(10000,8);%pulse#, velocity
statInd2=1;
oldIm=im;
index=1;

frameInd=2;
for imageInd = [5]%[2 3 6 7 10 11 14 15]%2:noOfimages

fprintf('Analyzing image %i\n',imageInd);
fullFileName=strcat(filename,int2str(imageInd),')','.png');
im=imread(fullFileName);

[ afterNew, afterOld] = positionxy( im ); 
%afterNew: newly created skyrmion positions in the after frame
%afterNew: Previosu skyrmion positions from the before frame in the after frame

skID=MasterList(1:length(beforeOld),frameInd-1,1);
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
MasterList(1:length(ibOld),frameInd,1)=skID(ibOld);
MasterList(1:length(ibOld),frameInd,2:3)=beforeOld(ibOld,1:2);

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
    p=p0;
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
        
        MasterList(length(ibOld)+i,frameInd,1)=skID_min;
        MasterList(length(ibOld)+i,frameInd,2:3)=afterUnique(i,:);
        skID_UniqueDup(minj)=[];
        beforeUniqueDup(minj,:)=[];
        if abs(minDist) >threshold
            %abs(minDist)
            repeat=true;
            repeat_i=repeat_i+1;
        end
        
        fullstat2(statInd2,:)=[index,imageInd,minDist,minx,miny,coortext(1),coortext(2),skID_min];
        statInd2=statInd2+1;
        index=index+1;
    end
    if repeat
        index=index-mafter_unique;
        statInd2=statInd2-mafter_unique;
    end
    
end
% SavefullFileName=strcat(filename,int2str(imageInd-1),')_edit','.png');
% print(SavefullFileName,'-dpng');

if ~isempty(afterNew)
    MasterList((length(ibOld)+length(p)+1):(length(ibOld)+length(p)+numel(afterNew)/2),frameInd,2:3)=afterNew;
    MasterList((length(ibOld)+length(p)+1):(length(ibOld)+length(p)+numel(afterNew)/2),frameInd,1)=(skmax+1):(skmax+numel(afterNew)/2);
    skmax=skmax+numel(afterNew)/2;
end

beforeOld=[MasterList(1:(length(ibOld)+length(p)+numel(afterNew)/2),frameInd,2),MasterList(1:(length(ibOld)+length(p)+numel(afterNew)/2),frameInd,3)];
frameInd=frameInd+1;
oldIm=im;
end
fullstat=fullstat(1:(statInd-1),:);
fullstat2=fullstat2(1:(statInd2-1),:);
sum(fullstat2(:,1)==23)
% for pulseInd=[4 5 8 9 12 13 16 17 20 21]
%     fullstat2(fullstat2(:,2)==pulseInd,:)=[];
% end

%%write a sort function*****

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

conv=13000/1080; %estimated nm/px
p_width=20;
%quick frame statistics
frame_stats=zeros(100,3);
framelist=unique(fullstat2(:,2))';
for frameid=framelist
    idx=(fullstat2(:,2)==frameid);
    v=fullstat2(idx,3);
    if ~isempty(v)
        avg_v=mean(abs(v))*conv*10^-9/(p_width*10^-9);
        med_v=median(abs(v))*conv*10^-9/(p_width*10^-9);
        max_v=max(abs(v))*conv*10^-9/(p_width*10^-9);%avg_v+2*std(abs(v))*conv*10^-9/(p_width*10^-9);
        frame_stats(frameid,1)=avg_v;
        frame_stats(frameid,2)=med_v;
        frame_stats(frameid,3)=max_v;
    end
end
frame_stats=frame_stats(min(framelist):max(framelist),:);
figure
plot(i1,frame_stats(:,1),'bo','LineWidth',2)
xlabel('Current Density (A/m^2')
ylabel('Speed(|m/s|)')
title('Average Speed');
figure
plot(i1,frame_stats(:,3),'ro','LineWidth',2)
xlabel('Current Density (A/m^2')
ylabel('Speed(|m/s|)')
title('Average Speed + 2 Std');
%sum(fullstat2(:,1)==23)
% cd('C:\Users\Anthony\Documents\Matlab')

% %%*****polar plot******
% t = 0 : .01 : 2 * pi;
% P = polar(t, 4 * ones(size(t)));
% set(P, 'Visible', 'off')
% cmap=flipud(autumn(6));
% ind=[0 9 17 24 39 55 78];
% for i=2:7
%     hold on
%     [th,r] = cart2pol(vel((ind(i-1)+1):ind(i),1),-vel((ind(i-1)+1):ind(i),2));
%     pplot=polar(th,r,'o');
%     set(pplot,'MarkerEdgeColor',cmap(i-1,:),'LineWidth',1)
%     
% end
% legend('','3.78E11 A/m2','3.93E11 A/m2','4.07E11 A/m2','4.22E11 A/m2','4.29E11 A/m2','4.36E11 A/m2');

% binsize=10;
% l=length(60:binsize:180);
% avgv=zeros(l,1);
% v=v6;
% [binc,ind]=histc(v(:,2),60:binsize:180);
% for i=1:l
%     vel=v(:,1);
%     tv=sum(vel((ind==i)));
%     avgv(i)=tv/sum((ind==i));
% end
% plot(60:binsize:180,avgv.*(binc>1),'bo')
% hold on

% binsize=20;
% l=length(60:binsize:180);
% avgv=zeros(l,1);
% v=v5;
% [binc,ind]=histc(v(:,2),60:binsize:180);
% for i=1:l
%     vel=v(:,1);
%     tv=sum(vel((ind==i)));
%     avgv(i)=tv/sum((ind==i));
% end
% plot(60:binsize:180,avgv.*(binc>1),'go')
% hold on


% for binsize=10
% l=length(80:binsize:180);
% avgv=zeros(l,1);
% v=v3456;
% [binc,ind]=histc(v(:,2),80:binsize:180);
% for i=1:l
%     vel=v(:,1);
%     tv=sum(vel((ind==i)));
%     avgv(i)=tv/sum((ind==i));
% end
% figure
% plot(80:binsize:180,avgv.*(binc>2),'ro')
% end

for binsize=5:15;
binz=80:binsize:180;
l=length(binz);
avgv=zeros(l,1);
stdv=zeros(l,1);
figure;


for vt=[3.3 3.3 3.3 3.3];
    
    p= (vol1==vt);
    vp=v1(p);
    sp=s1(p);
    plot(sp,vp,'o');
    hold on;
    [binc,ind]=histc(sp,binz);
    for i=1:l
        sum((ind==i));
        tv=sum(vp((ind==i)));
        avgv(i)=tv/sum((ind==i));
        stdv(i)=std(vp((ind==i)));
    end
    plot(binz(binc>2),avgv(binc>2));
    [avgv,binc,stdv];
%     errorbar(binz,avgv,stdv');
    hold on;
    %[binz',binc,avgv,stdv]
    title(strcat('Bin Size:',int2str(binsize)));
    %[binc,ind]=histc(vp(:,2),80:binsize:180);
end
%legend('2.9','2.9','2.95','2.95','3','3');
end
z=zeros(11,3);
    index=1;
for i = [2.5 2.6 2.7 2.8 2.9 2.95 3]  
z(index,:)=[sum(abs(vol)==i),mean(spd(abs(vol)==i)),std(spd(abs(vol)==i))];
index=index+1;
end

for w = 11

xtar=linspace(0,max(x),w);
l=length(xtar);
avgv=zeros(l,1);
stdv=zeros(l,1);
% x=x(abs(ang)<200);
% ang=ang(abs(ang)<200);
[binc,ind]=histc(x,xtar);
ang=double(binc)/(29*(max(x)/w)*10);
figure
plot(xtar,ang,'ro')
title(int2str(w));
end
for i = 1:l
    avgv(i)=mean(ang((ind==i)));
    stdv(i)=std(ang((ind==i)));
end
plot(xtar,avgv.*(binc>2),'ro')
figure
plot(xtar,avgv,'ro')

z2=zeros(11,1);
ang2=ang2(abs(ang2)<90);
x2=x2(abs(ang2)<90);
for i = 2:11
    ind2=(x2<xtar(i)).*(x2>xtar(i-1));
    z2(i-1,1)=sum(ang2.*ind2)/sum(ind2);
end
figure
bar(xtar,z2,'histc')

%%***********velocity vs angle binning*************
th=th1(abs(th1)<90);
v=v1(abs(th1)<90);
sz=sz1(abs(th1)<90);
v=v1(vol1==3);
sz=sz1(vol1==3);
lkl=linspace(0,4.6,10);
l=length(lkl);
avgv=zeros(l,1);
stdv=zeros(l,1);

[binc,ind]=histc(sz,lkl);
for i=1:l
    tv=sum(v((ind==i)));
    avgv(i)=mean(v((ind==i)));
    stdv(i)=std(v((ind==i)));
end
figure
plot(lkl,avgv.*(binc>2),'ro')

%%%***********angle vs x width binning*************

v=v1(vol1==2.95);
sz=sz1(vol1==2.95);
for space=[2:20]

lkl=100:space:175;
l=length(lkl);
avgv=zeros(l,1);
stdv=zeros(l,1);
% avgvv=zeros(l,1);
% stdvv=zeros(l,1);
[binc,ind]=histc(sz,lkl);
for i=1:l
avgv(i)=mean(v((ind==i)));
stdv(i)=std(v((ind==i)));
%     avgvv(i)=mean(v((ind==i)));
%     stdvv(i)=std(v((ind==i)));
end
figure
plot(lkl,avgv.*(binc>2),'ro')
title(num2str(space));
end
% figure
% plot(lkl,avgvv.*(binc>2),'ro')
% title(num2str(space));
[lkl'+mean(diff(lkl)/2),avgv,stdv,binc]

pointx=zeros(1,10000);
st=1;
    for p=0:29
        coorx=MasterList(:,p+1,2);
        coorx=coorx(coorx~=0,:);
        l=length(coorx);
        pointx(st:st+l-1)=coorx;
        st=st+l;
    end
    pointx=pointx(1:st-1);