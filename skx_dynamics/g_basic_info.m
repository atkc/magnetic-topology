conv=13000/1080; %estimated nm/px
p_width=20;
c1=conv*10^-9/(p_width*10^-9);
col_map=jet(max(unique(fullstat2(:,2))));
frame_list=unique(fullstat2(:,2));
% fullstat2_fil=fullstat2;
% r_cor_fil=r_cor;
% theta_cor_fil=theta_cor;
minDist=1080/256;
[fullstat2_fil,r_cor_fil,theta_cor_fil]=minDist_filter(fullstat2,r_cor,theta_cor,minDist);

%Hall Angle vs J plot
f2=figure;
avg_theta=zeros(length(frame_list),1);
std_theta=zeros(length(frame_list),1);
for i=1:length(frame_list)
    hold_theta=(180/pi)*theta_cor_fil((fullstat2_fil(:,2)==frame_list(i)));
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    hold_i=(hold_theta>-90).*(hold_theta<90)
    hold_theta1=hold_theta(hold_i==1)
    avg_theta(i)= (mean(hold_theta1));
    std_theta(i)= (std(hold_theta1));
end
% if abs(i1(end))<abs(i1(1))
%     i2=flipud(unique(abs(i1)));
% else
%     i2=unique(abs(i1));
% end
errorbar(abs(i1(1:length(avg_theta))),avg_theta,std_theta,'o')
xlabel('j(|A/m^2|)')
ylabel('Theta(o)')

%Speed (only sk in motion) vs J plot
f4=figure;
%[theta_cor,r_cor]=cart2pol(vy_cor,-vx_cor);

avg_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
std_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
for i=1:length(frame_list)
    hold_v=r_cor_fil(logical((fullstat2_fil(:,2)==frame_list(i))));
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
total_sk=max(fullstat2_fil(:,8));

avg_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
std_v=zeros(length(frame_list),1);%zeros(floor(size(frame_list)/2));
for i=1:length(frame_list)
    hold_v=r_cor_fil(logical((fullstat2_fil(:,2)==frame_list(i))));
    avg_v(i)= (mean([hold_v,zeros(1,total_sk-length(hold_v))]));
    std_v(i)= (std(hold_v));
end
i2=(abs(i1));
errorbar(i2(1:length(avg_v)),avg_v,std_v,'*r')
xlabel('j(|A/m^2|)')
ylabel('speed(|m/s^2|)')

%Speed vs Hall angle plot

for nedge=22
figure;
r=r_cor_fil%(pID<p_lim);
theta=theta_cor_fil%(pID<p_lim);
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
x1=min(fullstat2_fil(:,6));
x2=max(fullstat2_fil(:,6));
p_sub=unique(fullstat2_fil(:,2));
%pid=p_sub(logical(i1<(-5.5*1e11)));
for p1=7
pid=[6 40]
vlim=5.46
%for vlim = 0;%[10.06,7.76,5.46,3.16]
fil_para=ismember(fullstat2_fil(:,2),pid);
%fil_para=logical(fil_para.*(abs(r_cor')>vlim));
theta_cor_edge=theta_cor_fil(fil_para);
x_coor=fullstat2_fil(:,6);
x_coor=x_coor(fil_para);
for binN=20:30
figure
binE=linspace(x1,x2,binN);
avg_binE=zeros(1,length(binE)-1);
std_theta=zeros(1,length(binE)-1);
avg_theta=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((x_coor>=binE(el)).*(x_coor<binE(el+1)));
    hold_theta=(180/pi)*theta_cor_edge(hold_i);
    hold_theta_i=logical((hold_theta>=-90).*(hold_theta<90));
    hold_theta=hold_theta(hold_theta_i);
    %hold_theta=hold_theta+(hold_theta<-90)*180;
    %hold_theta=hold_theta-(hold_theta>90)*180;
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
%[(avg_binE-x1)*13000/(1000*1080);N;avg_theta;std_theta]';

%sk speed vs X plot
x1=min(fullstat2_fil(:,6));
x2=max(fullstat2_fil(:,6));
for binN=14;
    figure
binE=linspace(x1,x2,binN);
x_coor=fullstat2_fil(:,6);
r_cor_edge=r_cor_fil(logical((fullstat2_fil(:,2)==12)+(fullstat2_fil(:,2)==10)));
x_coor=x_coor(logical((fullstat2_fil(:,2)==12)+(fullstat2_fil(:,2)==10)));
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
for ski=fliplr(1:length(fullstat2_fil))
        polarplot(theta_cor_fil(ski),r_cor_fil(ski),'o','color',col_map(fullstat2_fil(ski,2),:),'MarkerSize', 7)
        hold on
end
pax = gca;
pax.ThetaZeroLocation = 'top';
pax.RAxisLocation=90;

%population graph
total_sk=max(fullstat2_fil(:,8));
id_1=[3:8];
p=zeros(length(id_1),2);
for i=1:length(id_1)
    p(i,1)=sum(fullstat2_fil(:,2)==id_1(i));
    p(i,2)=p(i,1)/total_sk;
end