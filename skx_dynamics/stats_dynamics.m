%%******initialization*******
MasterList=zeros(1000,50,4);%#sk; frame; sk-id, x, y, size
MasterList(:,1,1)=(1:1000)';%%sk-id

cd('C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp226_nanostructures\fp226_1b_2um_d2\170421\bio-analysis')
filename='170421_15k_1b_2um_d2_n4k-p1100_p (';
fullFileName=strcat(filename,'0)','.png');
im=imread(fullFileName);
[ ~, beforeOld] = positionxy( im );
MasterList(1:length(beforeOld),1,2:3)=beforeOld;

threshold=30;
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
for imageInd = 1%[2 3 6 7 10 11 14 15]%2:noOfimages

fprintf('Analyzing image %i\n',imageInd);
fullFileName=strcat(filename,int2str(imageInd),')','.png');
im=imread(fullFileName);
[ afterNew, afterOld] = positionxy( im );
skID=MasterList(1:length(beforeOld),frameInd-1,1);%skID of beforeOld list of skyrmions

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

%%*****capture old skyrmions in after frame that did nto move******
MasterList(1:length(ibOld),frameInd,1)=skID(ibOld);
MasterList(1:length(ibOld),frameInd,2:3)=beforeOld(ibOld,1:2);
%%*****capture old skyrmions in after frame that did nto move******

[C,~,sbOld] = setxor(afterOld,beforeOld,'rows','stable');
afterUnique=C(1:(length(C)-offset)/2,:);
beforeUnique=C((((length(C)-offset)/2)+1):end,:);%beforeUnique>=afterUnique

skID_Unique=skID(sbOld);

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
while (repeat)
%     fig=imshow(oldIm(:,:,1)>120);
    repeat=false;
    p = randperm(mafter_unique);
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
        skID_min=skID_Unique(minj);
        
        MasterList(length(ibOld)+i,frameInd,1)=skID_min;
        MasterList(length(ibOld)+i,frameInd,2:3)=afterUnique(i,:);
        
        beforeUniqueDup(minj,:)=[];
        if abs(minDist) >threshold
            repeat=true;
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
    MasterList((length(ibOld)+length(p)+1):(length(ibOld)+length(p)+1+numel(afterNew)/2),frameInd,2:3)=afterNew;
    MasterList((length(ibOld)+length(p)+1):(length(ibOld)+length(p)+1+numel(afterNew)/2),frameInd,1)=skmax:numel(afterNew)/2;
    skmax=skmax+numel(afterNew)/2;
end

beforeOld=MasterList((length(ibOld)+length(p)+1):(length(ibOld)+length(p)+1+numel(afterNew)/2),frameInd,2:3);
framInd=frameInd+1;
oldIm=im;
end
fullstat=fullstat(1:(statInd-1),:);
fullstat2=fullstat2(1:(statInd2-1),:);
sum(fullstat2(:,1)==23)
% for pulseInd=[4 5 8 9 12 13 16 17 20 21]
%     fullstat2(fullstat2(:,2)==pulseInd,:)=[];
% end


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

% for binsize=5:15;
% binz=80:binsize:180;
% l=length(binz);
% avgv=zeros(l,1);
% stdv=zeros(l,1);
% figure;
% 
% 
% for vt=[ 2.9 2.95 3  ];
%     
%     p= (vol1==vt);
%     vp=v1(p);
%     sp=s1(p);
%     plot(sp,vp,'o');
%     hold on;
%     [binc,ind]=histc(sp,binz);
%     for i=1:l
%         sum((ind==i));
%         tv=sum(vp((ind==i)));
%         avgv(i)=tv/sum((ind==i));
%         stdv(i)=std(vp((ind==i)));
%     end
%     plot(binz(binc>2),avgv(binc>2));
%     [avgv,binc,stdv];
% %     errorbar(binz,avgv,stdv');
%     hold on;
%     %[binz',binc,avgv,stdv]
%     title(strcat('Bin Size:',int2str(binsize)));
%     %[binc,ind]=histc(vp(:,2),80:binsize:180);
% end
% %legend('2.9','2.9','2.95','2.95','3','3');
% end
% z=zeros(11,3);
%     index=1;
% for i = [2.5 2.6 2.7 2.8 2.9 2.95 3]  
% z(index,:)=[sum(abs(vol)==i),mean(spd(abs(vol)==i)),std(spd(abs(vol)==i))];
% index=index+1;
% end
% 
% z=zeros(11,1);
% xtar=0:0.2:2;
% ang=ang(abs(ang)<90);
% x=x(abs(ang)<90);
% for i = 2:11
%     ind=(x<xtar(i)).*(x>xtar(i-1));
%     z(i-1,1)=sum(ang.*ind)/sum(ind);
% end
% bar(xtar,z,'histc')
% 
% z2=zeros(11,1);
% ang2=ang2(abs(ang2)<90);
% x2=x2(abs(ang2)<90);
% for i = 2:11
%     ind2=(x2<xtar(i)).*(x2>xtar(i-1));
%     z2(i-1,1)=sum(ang2.*ind2)/sum(ind2);
% end
% figure
% bar(xtar,z2,'histc')
% 
% %%%***********velocity vs angle binning*************
% th=th1(abs(th1)<90);
% v=v1(abs(th1)<90);
% lkl=linspace(0,4.6,10);
% l=length(lkl);
% avgv=zeros(l,1);
% stdv=zeros(l,1);
% 
% [binc,ind]=histc(v,lkl);
% for i=1:l
%     tv=sum(th((ind==i)));
%     avgv(i)=mean(th((ind==i)));
%     stdv(i)=std(th((ind==i)));
% end
% figure
% plot(lkl,avgv.*(binc>2),'ro')
% 
% %%%***********angle vs x width binning*************
% [lkl'+mean(diff(lkl)/2),avgv,stdv,binc]