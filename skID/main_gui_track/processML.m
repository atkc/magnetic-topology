function [ fullstat2,theta_cor,r_cor ] = processML( MasterList, p_no,i1,fileno,flip_n )
%PROCESSML Summary of this function goes here
%   Detailed explanation goes here
%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
p_no=sort(p_no);
fullstat2=zeros(10000,8);%[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
fs_i=1;
skN_max=max(max(max(MasterList(:,:,1))));
%skN=(1:skN_max)';
for p=p_no
    p_before=p-1;
    if ismember(p_before,p_no)
        ml_now=reshape(MasterList(1:skN_max,p,:),[skN_max,4]);
        ml_before=reshape(MasterList(1:skN_max,p_before,:),[skN_max,4]);
        ml_now=sortrows(ml_now,1);
        ml_before=sortrows(ml_before,1);
        centroids=ml_now(:,2:3);
        centroids_before=ml_before(:,2:3);
        skID_now=ml_now(:,1);
        skID_before=ml_before(:,1);
        for skN_i=1:skN_max
            skN_index=skID_before==skID_now(skN_i);
            xy_now=centroids(skID_now(skN_i),:);
            xy_before=centroids_before(skN_index,:);
            dx=xy_now(1)-xy_before(1);
            dy=xy_now(2)-xy_before(2);
            dist1=sqrt(dx.^2+dy.^2);
            sel_index=((dist1>0)&&~ismember(xy_now,[0,0],'rows')&&~ismember(xy_before,[0,0],'rows'));
            if sel_index
                data=[fs_i,p,dist1,dx,dy,xy_before,skID_now(skN_i)];
                fullstat2(fs_i,:)=data;
                fs_i=fs_i+1;
            end
        end
    end
end
fullstat2=fullstat2(1:fs_i-1,:);

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
    if mod(fullstat2(ski,2),2)==0 %this code is the potential fkup
        plot(flip_n*fullstat2(ski,4)*c1,-flip_n*fullstat2(ski,5)*c1,'o','color',col_map(fullstat2(ski,2)-p_no(1)+2,:),'MarkerSize', 10)
        vx_cor(ski)=flip_n*fullstat2(ski,4)*c1;
        vy_cor(ski)=-flip_n*fullstat2(ski,5)*c1;

    else
        plot(-flip_n*fullstat2(ski,4)*c1,flip_n*fullstat2(ski,5)*c1,'o','color',col_map(fullstat2(ski,2)-p_no(1)+2,:),'MarkerSize', 10)
        vx_cor(ski)=-flip_n*fullstat2(ski,4)*c1;
        vy_cor(ski)=flip_n*fullstat2(ski,5)*c1;
    end
            v_cor(ski)=fullstat2(ski,3)*c1;
end
axis equal
xlabel('x speed(|m/s|)')
ylabel('y speed(|m/s|)')

[theta_cor,r_cor]=cart2pol(vy_cor,-vx_cor);
% save(strcat('r_cor-',num2str(fileno),'.mat'),'r_cor');
% save(strcat('theta_cor-',num2str(fileno),'.mat'),'theta_cor');
% save(strcat('fullstat2-',num2str(fileno),'.mat'),'fullstat2');

end

