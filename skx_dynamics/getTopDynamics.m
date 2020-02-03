%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
%fullstat2_fil(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
load('fullstat2-combine.mat')
load('MasterList.mat')
load('fullstat2-size-combine.mat')
load('newMasterList.mat')
load('i1-combine.mat')
load('theta_cor-combine.mat')
load('r_cor-combine.mat')


conv=13000/1080; %estimated nm/px
pulse_range=[6 7 39 40]%[6 8 10 28 30 32 34];%[6 7 39 40]%[6 8 10 28 30 32 34]%[5 7 9 27 29 31 33]%[6 8 10 28 30 32 34];%;
storage=zeros(1000,6);
store_i=1;
sk_hall=-20;
divide=1;%1: count the assymetries of the flow based on sk_hall
% before=1;%capture before or after pulse position
[fullstat2_fil,~,~]=minDist_filter(fullstat2);
staticsk_no=0;
NN_staticsk_size=zeros([1000,2]);
NNdist=zeros([1000,2]);

NN_staticsk_size_before=zeros([1000,2]);
NNdist_before=zeros([1000,2]);
NN_staticsk_size_after=zeros([1000,2]);
NNdist_after=zeros([1000,2]);

for pulse_i=1:length(pulse_range)
    skN=MasterList(:,pulse_range(pulse_i)-1,1);
    skN_max= max(skN);
    
    checkSkList=1:skN_max;
    movingSkList=sort(fullstat2_fil((fullstat2_fil(:,2)==(pulse_range(pulse_i))),8));
    
    checkSkList(movingSkList)=[];%based on skN (full), stationary sk
    
    
    m_vx=fullstat2_fil((fullstat2_fil(:,2)==(pulse_range(pulse_i))),4);
    m_vy=fullstat2_fil((fullstat2_fil(:,2)==(pulse_range(pulse_i))),5);
    m_x=fullstat2_fil((fullstat2_fil(:,2)==(pulse_range(pulse_i))),6);
    m_y=fullstat2_fil((fullstat2_fil(:,2)==(pulse_range(pulse_i))),7);
    
    dsk=newMasterList(:,pulse_range(pulse_i)-1,4);
    x= MasterList(:,pulse_range(pulse_i)-1,2);
    y = MasterList(:,pulse_range(pulse_i)-1,3);
    
    dsk_after=newMasterList(:,pulse_range(pulse_i),4);
    x_after= MasterList(:,pulse_range(pulse_i),2);
    y_after = MasterList(:,pulse_range(pulse_i),3);    
    %remove 0s
    y(x==0)=[];
    skN(x==0)=[];
    x(x==0)=[];
    
    tri = delaunayTriangulation(x,y);
    clist=tri.ConnectivityList;%based on skN (temp)
    
    length(checkSkList)
    staticsk_no=staticsk_no+length(checkSkList);
    sk_temp=1:length(skN);
    for sk_id=checkSkList
        sk_id_temp=sk_temp(skN==sk_id);%static Sk id
        if ~isempty(sk_id_temp)
        [r,c] = find(clist==sk_id_temp);%find triangulations based on skN (temp) i.e. involving chosen static sk
        nn_id_temp=unique(reshape(clist(r,:),1,[]));%based on skN (temp)
        sum(nn_id_temp==sk_id_temp);%must be truel
        nn_id_temp(nn_id_temp==sk_id_temp)=[];%based on skN (temp)
        nn_id=skN(nn_id_temp);%based on skN (full)
        for skj=nn_id'
            if ~isempty(find(movingSkList==skj,1))
                dx=m_x(find(movingSkList==skj,1))-x(sk_id_temp);
                dy=m_y(find(movingSkList==skj,1))-y(sk_id_temp);

                dx_after=x_after(skj)-x(sk_id_temp);
                dy_after=y_after(skj)-y(sk_id_temp);
%                 if before==1
%                     NNdist(store_i,:)=[dx,dy];
%                     NN_staticsk_size(store_i,:)=[dsk(sk_id_temp),dsk(skj)];%[pinned dsk, moving dsk]   
%                 elseif before ==0
%                     NNdist(store_i,:)=[dx_after,dy_after];
%                     NN_staticsk_size(store_i,:)=[dsk_after(sk_id_temp),dsk_after(skj)];%[pinned dsk, moving dsk]                   
%                 end

                %[NNx_before, NNy_before,NNx_after,NNy_after]
                NNdist_all(store_i,:)=[dx,dy,dx_after,dy_after];
                %[pinned dsk_before, moving dsk_before,pinned dsk_after, moving dsk_after]
                NN_staticsk_size_all(store_i,:)=[dsk(sk_id_temp),dsk(skj),dsk_after(sk_id_temp),dsk_after(skj)];
                
                if ((dx==0)&&(dy==0))||((dx_after==0)&&(dy_after==0))
                    display('Algo is fucked');
                end
                vx=m_vx(find(movingSkList==skj,1));
                vy=m_vy(find(movingSkList==skj,1));
                storage(store_i,:)=[dx,dy,dx_after,dy_after,vx,vy];
                store_i=store_i+1;
            end
        end
        end
    end
end
% plot(storage(1:store_i-1,1),storage(1:store_i-1,2),'o')
% axis equal

rc=0;%red counts
bc=0;%blue counts
allc=0;%red+blue
r_thresh=400;%nm
theta_pos=zeros(1,store_i-1);
theta_v=zeros(1,store_i-1);
figure
hold on
axis equal
xlim([-40*conv,40*conv]);
ylim([-40*conv,40*conv]);
if divide
    for sk_i=1:store_i-1
        x=storage(sk_i,1)*conv;
        y=-storage(sk_i,2)*conv;
        vx=storage(sk_i,5)*conv;
        vy=-storage(sk_i,6)*conv;
        if sqrt(x^2+y^2)<r_thresh
        allc=allc+1;
        if ((y-x/tan(sk_hall*pi/180))>0)
            plot(x,y,'ro');
            rc=rc+1;
        else
            plot(x,y,'bo');
            bc=bc+1;
        end
%         quiver(x,y,vx,vy);
%         wrapTo180(atan2(-x,y)*180/pi)
%         wrapTo180(atan2(-vx,vy)*180/pi)
        theta_pos(allc)=wrapTo180(atan2(x,-y)*180/pi);
        theta_v(allc)=wrapTo180(atan2(vx,-vy)*180/pi);
        else
            plot(x,y,'ko');
        end
        
        %wrapTo180(atan2(-x,y)*180/pi)
        %wrapTo180(atan2(-vx,vy)*180/pi)

    end
else
    hold on
    plot(storage(1:store_i-1,1)*conv,-storage(1:store_i-1,2)*conv,'ro');
    plot(storage(1:store_i-1,3)*conv,-storage(1:store_i-1,4)*conv,'bo');
end
hold on
q=quiver(storage(1:store_i-1,1)*conv,-storage(1:store_i-1,2)*conv,storage(1:store_i-1,5)*conv,-storage(1:store_i-1,6)*conv);
q.AutoScale='off';
q.LineWidth=1;
q.Color = 'black';
axis equal
xlim([-40*conv,40*conv]);
ylim([-40*conv,40*conv]);
xlabel('x (nm)')
ylabel('y (nm)')
set(gca,'FontSize',15)
legend('NN position before pulse','NN position after pulse','NN velocity vector','FontSize',10);%

%*************************counting no of moving sk on each side of a static skyrmion*********
figure
b = bar([bc,rc]);
b.FaceColor = 'flat';
b.CData(1,:) = [0 0 1];
b.CData(2,:) = [1 0 0];

%*************************velocity_theta as a function of positon_theta*********
theta_pos=theta_pos(1:allc-1);
theta_v=theta_v(1:allc-1);
figure;plot(theta_pos,theta_v,'o')

ntheta=10;
avg_theta_v=zeros([ntheta-1,1]);
std_theta_v=zeros([ntheta-1,1]);
theta_edge=linspace(-180,180,ntheta);
theta_mid=theta_edge(1:end-1)+mean(diff(theta_edge));
for thetai=1:length(theta_edge)-1
    hold_tpos=logical((theta_pos>=theta_edge(thetai)).*(theta_pos<theta_edge(thetai+1)));
    avg_theta_v(thetai)=mean(theta_v(hold_tpos));
    std_theta_v(thetai)=std(theta_v(hold_tpos));
end
figure;errorbar(theta_mid,avg_theta_v,std_theta_v,'-o')

%*************************static sk size as a function of NN dist*********

NNdist_all=NNdist_all(1:store_i-1,:);
NN_staticsk_size_all=NN_staticsk_size_all(1:store_i-1,:);

%*********Analysis before pulse***************
%*********************************************
title_name='Skyrmion Size Before Pulse';
figure;
NNdist=NNdist_all(1:store_i-1,1:2);
NN_staticsk_size=NN_staticsk_size_all(1:store_i-1,1:2);
NNdist_n=sqrt(NNdist(:,1).^2+NNdist(:,2).^2).*conv;
NN_staticsk_size_fil=NN_staticsk_size(NNdist_n<400,:).*conv;
NNdist_n_fil=NNdist_n(NNdist_n<400);
plot(NNdist_n_fil,NN_staticsk_size_fil,'o');
xlabel('NN distance (nm)')
ylabel('stationary d_{sk} (nm)')
title(title_name);

figure;
set(gca,'FontSize',18)
values_staticsk=NN_staticsk_size_fil(:,1);
values_NNsk=NN_staticsk_size_fil(:,2);
binN=6;

%x=NNdist_n_fil;
x=NNdist_n_fil./values_staticsk;
y=values_NNsk./values_staticsk;

binE=linspace(1.6,3.4,binN);%linspace(min(x),max(x),binN);
avg_y=zeros(1,length(binE)-1);
avg_x=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((x>=binE(el)).*(x<binE(el+1)));
    avg_y(el)= mean(y(hold_i));
    avg_x(el)=(binE(el)+binE(el+1))/2;
end
hold on 
plot(avg_x,avg_y,'-*')
plot(x,y,'o')
xlabel('dist_{NN}/d_{sk-pinned}')
ylabel('d_{sk-move}/d_{sk-pinned}')
xlim([min(binE),max(binE)])
ylim([0,2])
title(title_name);

figure;
plot(NNdist_n_fil,NN_staticsk_size_fil(:,1),'o');
set(gca,'FontSize',18)
xlabel('dist_{NN}')
ylabel('d_{sk-pinned}')
ylim([60,200])
title(title_name);

%*********Analysis before pulse***************
%*********************END*********************

%*********Analysis after pulse***************
%*********************************************
title_name='Skyrmion Size After Pulse';
figure;
NNdist=NNdist_all(1:store_i-1,3:4);
NN_staticsk_size=NN_staticsk_size_all(1:store_i-1,3:4);
NNdist_n=sqrt(NNdist(:,1).^2+NNdist(:,2).^2).*conv;
NN_staticsk_size_fil=NN_staticsk_size(NNdist_n<400,:).*conv;
NNdist_n_fil=NNdist_n(NNdist_n<400);
plot(NNdist_n_fil,NN_staticsk_size_fil,'o');
xlabel('NN distance (nm)')
ylabel('stationary d_{sk} (nm)')
title(title_name);

figure;
set(gca,'FontSize',18)
values_staticsk=NN_staticsk_size_fil(:,1);
values_NNsk=NN_staticsk_size_fil(:,2);
binN=6;

%x=NNdist_n_fil;
x=NNdist_n_fil./values_staticsk;
y=values_NNsk./values_staticsk;

binE=linspace(1.6,3.4,binN);%linspace(min(x),max(x),binN);
avg_y=zeros(1,length(binE)-1);
avg_x=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((x>=binE(el)).*(x<binE(el+1)));
    avg_y(el)= mean(y(hold_i));
    avg_x(el)=(binE(el)+binE(el+1))/2;
end
hold on 
plot(avg_x,avg_y,'-*')
plot(x,y,'o')
xlabel('dist_{NN}/d_{sk-pinned}')
ylabel('d_{sk-move}/d_{sk-pinned}')
xlim([min(binE),max(binE)])
ylim([0,2])
title(title_name);

figure;
plot(NNdist_n_fil,NN_staticsk_size_fil(:,1),'o');
set(gca,'FontSize',18)
xlabel('dist_{NN}')
ylabel('d_{sk-pinned}')
ylim([60,200])
title(title_name);

%*********Analysis after pulse***************
%*********************END*********************

%*********Before + After pulse analysis*******
%*********************************************
NN_staticsk_size=[NN_staticsk_size_all(:,1),NN_staticsk_size_all(:,3)]*conv;
NN_staticsk_size=unique(NN_staticsk_size,'rows');
ratio_pinned=NN_staticsk_size(:,2)./NN_staticsk_size(:,1);
r_mean=mean(ratio_pinned);
r_std=std(ratio_pinned);

figure;
title_name='Pinned Skyrmion Size Before/After Pulse';
plot(NN_staticsk_size(:,1),ratio_pinned,'ro')
set(gca,'FontSize',18)
xlabel('d_{sk-pin}^{before} (nm)')
ylabel('r_{pin} = d_{sk-pin}^{after}/d_{sk-pin}^{before}')
txt=strcat('r_{mean}=',num2str(r_mean,'%.1f'),'\pm',num2str(r_std,'%.1f'));
text(130,1.6,txt)
h1=refline([0 1]);
h1.LineStyle='--'; 
title(title_name);

figure;
title_name='Pinned Skyrmion Size Before/After Pulse';
plot(NN_staticsk_size(:,1),NN_staticsk_size(:,2),'ro')
set(gca,'FontSize',18)
xlabel('d_{sk-pin}^{before} (nm)')
ylabel('d_{sk-pin}^{after} (nm)')
title(title_name);
ylim([100,200]);
xlim([100,200]);


NN_staticsk_size=[NN_staticsk_size_all(:,2),NN_staticsk_size_all(:,4)]*conv;
ratio_move=NN_staticsk_size(:,2)./NN_staticsk_size(:,1);
r_mean=mean(ratio_move);
r_std=std(ratio_move);

figure;
title_name='Moving Skyrmion Size Before/After Pulse';
plot(NN_staticsk_size(:,1),ratio_move,'ro')
set(gca,'FontSize',18)
xlabel('d_{sk-move}^{before} (nm)')
ylabel('r_{move} = d_{sk-move}^{after}/d_{sk-move}^{before}')
txt=strcat('r_{mean}=',num2str(r_mean,'%.1f'),'\pm',num2str(r_std,'%.1f'));
text(130,2,txt)
ylim([0,3]);
xlim([50,inf]);
h1=refline([0 1]);
h1.LineStyle='--'; 
title(title_name);

figure;
title_name='Moving Skyrmion Size Before/After Pulse';
plot(NN_staticsk_size(:,1),NN_staticsk_size(:,2),'ro')
set(gca,'FontSize',18)
xlabel('d_{sk-move}^{before} (nm)')
ylabel('d_{sk-move}^{after} (nm)')
title(title_name);
xlim([50,inf]);