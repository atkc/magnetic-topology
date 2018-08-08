pID=unique(fullstat2(:,2));
conv=13000/1080; %estimated nm/px
%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
dx=zeros(10000,1);
dy=zeros(10000,1);
avgd=zeros(length(pID)/2,1);
stdd=zeros(length(pID)/2,1);
avgi=zeros(length(pID)/2,1);
d_i=1;
cm=jet(length(pID)/2);
figure
hold all
for p_i=1:(length(pID)/2)
    i_1=i1(2*p_i-1);
    i_2=i1(2*p_i);
    skList1=reshape(MasterList(:,pID(2*p_i-1)-1,:),length(MasterList),4);
    skList2=reshape(MasterList(:,pID(2*p_i),:),length(MasterList),4);
    skList1=sortrows(skList1);
    skList2=sortrows(skList2);
    skList1(skList1(:,1)==0,:)=[];
    skList2(skList2(:,1)==0,:)=[];
    skList1(skList1(:,2)==0,:)=[];
    skList2(skList2(:,2)==0,:)=[];
    temp_i=1;
    for skN=skList1(:,1)'
        
        if sum((skList2(:,1)==skN))==1
            index2=(skList2(:,1)==skN);
            index1=(skList1(:,1)==skN);
            dx_temp(temp_i)=skList2(index2,2)-skList1(index1,2);
            dy_temp(temp_i)=skList2(index2,3)-skList1(index1,3);
            temp_i=temp_i+1;
        end
    end
%     avgd(p_i)=mean(sqrt(dx.^2+dy.^2));
%     stdd(p_i)=std(sqrt(dx.^2+dy.^2));
%     avgi(p_i)=abs(i_1);
    dx(d_i:(d_i+length(dx_temp)-1))=dx_temp;
    dy(d_i:(d_i+length(dy_temp)-1))=dy_temp;
    d_i=d_i+length(dy_temp);
    if sum(avgd>(900/conv))==1
        disp('asda')
    end
    plot(conv*dx_temp,-conv*dy_temp,'o','color',cm(p_i,:),'DisplayName',strcat(num2str(i_1/10^11),'E11A/m^2'));
    
end
legend(gca,'show')
axis equal
xlabel('X(nm)')
ylabel('Y(nm)')
dx=dx(1:d_i-1);
dy=dy(1:d_i-1);