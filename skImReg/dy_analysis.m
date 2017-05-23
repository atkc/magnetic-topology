r=data(:,6);
filInd=(r>0);
datafil=data(filInd,:);

Vol=datafil(:,1);
v=datafil(:,2);
vx=datafil(:,3);
vy=datafil(:,4);
ang=datafil(:,5);
r=datafil(:,6);
sz=datafil(:,7);
xpos=datafil(:,8);
ypos=datafil(:,9);

nRange=10;
binrange= linspace(0,2,nRange+1);
[bincounts,ind]=histc(xpos,binrange);
 avgang=zeros(1,11);
 avgv=zeros(1,11);
 stdv=zeros(1,11);
for i =1:(nRange+1)
    avgv(i)=mean(v(ind==i));
    stdv(i)=std(v(ind==i));
%     avgv(i)=sum(v(ind==i))/sum(ind==i);
%     avgang(i)=sum(ang(ind==i))/sum(ind==i);
end
figure
bar(binrange,avgv,'histc')
xlim([0,2])
title('Skyrmion Hall Angle along Wire Width')
ylabel('Skyrmion Hall Angle (^o)')
xlabel('x pos (um)')
axis
figure

bar(binrange,bincounts,'histc')
title('Skyrmion (dynamic) counts along Wire Width')
xlabel('x pos (um)')
ylabel('Bin Counts (#)')
xlim([0,2])
figure

bar(binrange,avgv,'histc')
title('Skyrmion velocity along Wire Width')
xlabel('x pos (um)')
ylabel('Average Velocity (m/s)')
xlim([0,2])
% 
% binrange1= 70:10:180;
% [bincounts1,ind1]=histc(sz,binrange1);
% avga=zeros(size(binrange1));
% for i = 1:length(binrange1)
%     avga(i)=sum(ang(ind1==i))/sum(ind1==i)
% end
% figure
% bar(binrange1,avga,'histc');
% figure
% bar(binrange1,bincounts1,'histc');

% ploti=1;
% figure
% for e=[2.8 2.9 2.95 3.0]
%     szfil=sz(Vol==e,:);
%     angfil=ang(Vol==e,:);
%     [bincounts,ind1]=histc(szfil,binrange1);
%     avga=zeros(size(binrange1));
%     for i =1:length(binrange1)
%         avga(i)=sum(angfil(ind1==i))/sum(ind1==i);
%     end
% 
%     
%     subplot(2,2,ploti)
%     ploti=ploti+1;
%     bar(binrange1,avga,'histc')
%     title(strcat('Vol= ',num2str(e),' V','-Angle vs Size'));
%     ylabel('Angular displacement (^o)');
%     xlabel('Skyrmion Size (nm)');
% %     figure
% %     bar(binrange1,bincounts,'histc')
% %     title(strcat('Vol= ',num2str(e),' V','-Skyrmion Size Counts'));
% %     ylabel('Counts (#)');
% %     xlabel('Skyrmion Size (nm)');
% end