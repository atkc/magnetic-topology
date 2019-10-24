function [ fullstat2,theta_cor,r_cor ]= processML_nn( MasterList, p_no, conv,p_width,flip_n)
%PROCESSML_NN Summary of this function goes here
%   Detailed explanation goes here
%Processes MasterList based on nearest neighbours
%only recommended for simulations or in-situ imaging techniques where
%frames are quasi continuous
%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
%conv=13000/1080; %estimated nm/px
%p_width:pulse width in ns
%flipn: to account for flipping of current in experiments
%flipn=1: +V-V+V... | -1: -V+V-V... | 0: nothign alternating flips
p_no=sort(p_no);
fullstat2=zeros(10000,9);%[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,radius];
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
        
        radius_list_now=ml_now(:,4);
        centroids_now=ml_now(:,2:3);
        centroids_before=ml_before(:,2:3);
        skID_now=ml_now(:,1);
        skID_before=ml_before(:,1);
        for skN_i=1:skN_max
            radius_now=radius_list_now(skID_now(skN_i));
            xy_now=centroids_now(skID_now(skN_i),:);
            dx_list=xy_now(1)-centroids_before(:,1);
            dy_list=xy_now(2)-centroids_before(:,2);
            [dist1,min_i]=min(sqrt(dx_list.^2+dy_list.^2));
            dx=dx_list(min_i);
            dy=dy_list(min_i);
            xy_before=centroids_before(min_i,:);
            sel_index=((dist1>0)&&~ismember(xy_now,[0,0],'rows')&&~ismember(xy_before,[0,0],'rows'));
            if sel_index
                
                data=[fs_i,p,dist1,dx,dy,xy_before,skID_before(skN_i),radius_now];
                fullstat2(fs_i,:)=data;
                fs_i=fs_i+1;
            end
            centroids_before(min_i,:)=[];
        end
        
    end
end
fullstat2=fullstat2(1:fs_i-1,:);
%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size]
fullstat2=sortrows(fullstat2,[2,8]);
skID=fullstat2(:,8);

c1=conv*10^-6/(p_width*10^-9);

%rough cart plot % get vx_cor and vy_cor
col_map1=jet(max(unique(fullstat2(:,2)))-p_no(1)+2);
vx_cor=zeros(1,length(fullstat2));
vy_cor=zeros(1,length(fullstat2));
v_cor=zeros(1,length(fullstat2));
f1=figure;
hold on
f2=figure;
hold on
col_map1=jet(skN_max);
col_map2=jet(skN_max*max(p_no));
for ski=1:length(skID)
    if flip_n==0        
        figure(f1);
        col_map1=jet(skN_max);
        plot(fullstat2(ski,4),-fullstat2(ski,5),'o','color',col_map1(fullstat2(ski,8),:),'MarkerSize', 10)
        figure(f2);
        plot(fullstat2(ski,6),-fullstat2(ski,7),'o','color',col_map2((fullstat2(ski,8)-1)*max(p_no)+fullstat2(ski,2),:),'MarkerSize', 10)
        vx_cor(ski)=fullstat2(ski,4)*c1;
        vy_cor(ski)=-fullstat2(ski,5)*c1;
    elseif mod(fullstat2(ski,2),2)==0 %this code is the potential fkup
        plot(flip_n*fullstat2(ski,4)*c1,-flip_n*fullstat2(ski,5)*c1,'o','color',col_map1(fullstat2(ski,2)-p_no(1)+2,:),'MarkerSize', 10)
        vx_cor(ski)=flip_n*fullstat2(ski,4)*c1;
        vy_cor(ski)=-flip_n*fullstat2(ski,5)*c1;
    else
        plot(-flip_n*fullstat2(ski,4)*c1,flip_n*fullstat2(ski,5)*c1,'o','color',col_map1(fullstat2(ski,2)-p_no(1)+2,:),'MarkerSize', 10)
        vx_cor(ski)=-flip_n*fullstat2(ski,4)*c1;
        vy_cor(ski)=flip_n*fullstat2(ski,5)*c1;
    end
    v_cor(ski)=fullstat2(ski,3)*c1;
end
figure(f1);
title('Velocity Components')
axis equal;
xlabel('dx(px/frame)');
ylabel('dy(px/frame)');
figure(f2);
title('Position')
axis equal;
xlabel('x pos(px)');
ylabel('y pos(px)');


[theta_cor,r_cor]=cart2pol(vy_cor,-vx_cor);

size_cor=fullstat2(:,9);

f3=figure;
hold on
f4=figure;
hold on
f5=figure;
hold on
for ski=unique(skID)'
    figure(f3);
    title('Deflection Angle (^o) Summary')
    pp=fullstat2(skID==ski,2);
    tt=theta_cor(skID==ski)*180/pi;
    plot(pp,tt);
    xlabel('frame(#)');
    ylabel('theta (^o)');
    figure(f4);
    title('Speed Summary')
    vv=r_cor(skID==ski);
    plot(pp,vv/c1);
    xlabel('frame(#)');
    ylabel('speed(px/frame)');
    figure(f5);
    title('Size (diameter) Summary')
    ss=size_cor(skID==ski);
    plot(pp,2*ss*conv*10^3);
    xlabel('frame(#)');
    ylabel('size(nm)');
end

saveas(figure(f1),'Sk_velocity_components.png')
saveas(figure(f2),'Sk_position.png')
saveas(figure(f3),'Sk_deflection.png')
saveas(figure(f4),'Sk_speed.png')
saveas(figure(f5),'Sk_size.png')

end

