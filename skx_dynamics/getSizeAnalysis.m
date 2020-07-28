%Speed analysis using fullstat2 velocity (position identified via user,
%hence not fitted)
conv=13000/1080; %estimated nm/px
p_width=20;
c1=conv*10^-9/(p_width*10^-9);%m/s
minDist=1080/256;%min pixel size
sksize=newfullstat2(:,9)*conv;
p_no=newfullstat2(:,2);
p_sub=unique(p_no);
%Vsk filter parameters
%v1=2;%m/s
v1=minDist*c1;%m/s
vpct1=0;%lower percentile
vpct2=100;%upper percentile

%**Select pulse no parameters**
%p_id=[6,7,8,9,39,40];%180412-1_fp553_1b_d2_2um_n4k-p750\analysis_750\CTF
%p_id=[5 6 7 8 9 10 27 28 29 30 31 32 33 34];%180417-1_fp553_1b_d3_2um_n4k-p750\analysis\registered_ctf\skel (p4-34)
%p_id=[26,27,30,31];%180411-1a_fp553_1b_d2_2um_n4k-p1050\analysis_1050\TF
p_id=[18:27];%180504-1_fp553_1b_d3_2um_n4k-p1050

%p_id=[6 7 8 9 10 11];
%p_id=[6:11];b
%p_id=[26 27 30 31];

%**Select sk size range parameters**
dsk1=60;
dsk2=200;

%**Select HA filtering parameters**
HA1=-90;
HA2=90;
HApct1=0;%lower percentile (only in use if HA1 & HA2 is NAN)
HApct2=100;%upper percentile
HAoffset=0;
proj=0;%0: no proj, 1: proj to -90 to 90 2: proj to 0 to 90

%**Counts filter parameters**
count_min=5;

fil_para.sel_p=p_id;
fil_para.vcutoff=v1;
fil_para.vpct1=vpct1;
fil_para.vpct2=vpct2;
fil_para.dsk1=dsk1;
fil_para.dsk2=dsk2;
fil_para.HAoffset=HAoffset;
fil_para.HA1=HA1;
fil_para.HA2=HA2;
fil_para.proj=proj;
fil_para.HApct1=HApct1;
fil_para.HApct2=HApct2;

%%
% %**********Analysis 1: HA vs Size (Vsk)**************
% [vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);
% [vA1,v_edgeA1,sksizeA1,sksize_edgeA1,thetaA1,thetaA1_std,countsA1]=bin3D(vsk_flow,sksize_flow,theta_flow,5,5);
% [ro,co]=size(sksizeA1);
% figure
% thetaA1(countsA1<c1)=nan;
% 
% for ix=1:ro
%     hold on
%     plot(sksizeA1(ix,:),thetaA1(ix,:),'-o','DisplayName',strcat(num2str(vA1(ix),'%.1f'),'m/s'))
% end
% xlabel('d_S_k (nm)');
% ylabel('HA (^o)');
% legend('Location','southeast')

%%
%**********Analysis 2a: HA vs Size (j)**************
%**********Analysis 2b: V vs Size (j)**************
[~,jlist_id]=ismember(p_id,p_sub);
i_list=(abs(i1(jlist_id)));
i_list=unique(i_list);
for n2=10
f3=figure;
f4=figure;
f5=figure;

data_dsk_HA_j=zeros(n2-1,length(i_list));
data_dsk_HAstd_j=zeros(n2-1,length(i_list));
data_dsk_vsk_j=zeros(n2-1,length(i_list));
data_dsk_vskstd_j=zeros(n2-1,length(i_list));
data_dsk_HA_j_N=zeros(n2-1,length(i_list));
data_dsk_vsk_j_N=zeros(n2-1,length(i_list));
data_all=zeros(n2-1,6*length(i_list));
hist_size=zeros(20,2*length(i_list)+1);

size_edge=linspace(dsk1,dsk2,n2);
for jid=1:length(i_list)
    p_id_partial=p_sub(abs(i1)==i_list(jid));
    p_id_partial=p_id(ismember(p_id,p_id_partial));
    i_use=mean(abs(i_list(jid)));
    fil_para.sel_p=p_id_partial;
    
    [vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);
    
    figure(f3);
    [jA2,j_edgeA2,sksizeA2,sksize_edgeA2,thetaA2,thetaA2_std,countsA2]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,theta_flow,1,size_edge);
    thetaA2(countsA2<count_min)=nan;
    plot(sksizeA2,thetaA2,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.2f'),'e11 Am^-^2'));
    data_dsk_HA_j(:,jid)=thetaA2;
    data_dsk_HAstd_j(:,jid)=thetaA2_std;
    data_dsk_HA_j_N(:,jid)=countsA2;
    hold on
    
    figure(f4);    
    [jA2,j_edgeA2,sksizeA2,sksize_edgeA2,vA2,vA2_std,countsA2]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,vsk_flow,1,size_edge);
    vA2(countsA2<count_min)=nan;
    plot(sksizeA2,vA2,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.2f'),'e11 Am^-^2'));
    xlabel('Size(nm)')
    ylabel('V_s_k(m/s)')
    data_dsk_vsk_j(:,jid)=vA2;
    data_dsk_vskstd_j(:,jid)=vA2_std;
    data_dsk_vsk_j_N(:,jid)=countsA2;    
    hold on
    figure(f5); 
    [sizeN,sizeEdge] = histcounts(sksize_flow,10);
    sizebin=sizeEdge(1:length(sizeEdge)-1)+diff(sizeEdge)/2;
    plot(sizebin,sizeN,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.2f'),'e11 Am^-^2'));
    hold on
    
    hist_size(1:10,(2*(jid-1)+1):(2*(jid)))=[sizeN',sizebin'];
    data_all(:,(6*(jid-1)+1):(6*(jid)))=[thetaA2',thetaA2_std',countsA2',vA2',vA2_std',countsA2'];
end
figure(f3);
xlabel('d_S_k (nm)');
ylabel('HA (^o)');
legend('Location','northwest')
figure(f4);
legend('Location','northwest')
xlabel('d_S_k (nm)');
ylabel('V_s_k(m/s)')
figure(f5);
legend('Location','northwest')
xlabel('n_s_k(#)');
ylabel('V_s_k(m/s)')
end
%%insert distribution of sizes in all flow
figure(f5)
fil_para.sel_p=p_sub;
[~,~,sksize_flow,~] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);
[sizeN,sizeEdge] = histcounts(sksize_flow,20);
sizebin=sizeEdge(1:length(sizeEdge)-1)+diff(sizeEdge)/2;
%plot(sizebin,sizeN,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.2f'),'e11 Am^-^2'));
%hist_size(1:20,(2*(jid)+1):(2*(jid+1)))=[sizeN',sizebin'];
%%
%**********Analysis 2c: HA vs Size (j) Spline ver.**************
%**********Analysis 2d: V vs Size (j) Spline ver.**************
[~,jlist_id]=ismember(p_id,p_sub);
i_list=(abs(i1(jlist_id)));
i_list=unique(i_list);
for n2=10%6:2:10
f3=figure;
f4=figure;

data_dsk_HA_j=zeros(n2,length(i_list));
data_dsk_vsk_j=zeros(n2,length(i_list));
data_dsk_HA_j_N=zeros(n2,length(i_list));
data_dsk_vsk_j_N=zeros(n2,length(i_list));
data_all=zeros(n2,4*length(i_list));

for jid=1:length(i_list)
    p_id_partial=p_sub(abs(i1)==i_list(jid));
    p_id_partial=p_id(ismember(p_id,p_id_partial));
    i_use=mean(abs(i_list(jid)));
    fil_para.sel_p=p_id_partial;
    
    [vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);
    
    figure(f3);
    [jA2,sksizeA2,thetaA2,countsA2]=spline3D(i_use*ones(size(sksize_flow)),sksize_flow,theta_flow,1,n2);
    %thetaA2(countsA2<c1)=nan;
    plot(sksizeA2,thetaA2,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.2f'),'e11 Am^-^2'));
    data_dsk_HA_j(:,jid)=thetaA2;
    data_dsk_HA_j_N(:,jid)=countsA2;
    hold on
    
    figure(f4);    
    [jA2,sksizeA2,vA2,countsA2]=spline3D(i_use*ones(size(sksize_flow)),sksize_flow,vsk_flow,1,n2);
    %vA2(countsA2<c1)=nan;
    plot(sksizeA2,vA2,'-o','DisplayName',strcat(num2str(i_use*10^-11,'%.2f'),'e11 Am^-^2'));
    xlabel('Size(nm)')
    ylabel('V_s_k(m/s)')
    data_dsk_vsk_j(:,jid)=vA2;
    data_dsk_vsk_j_N(:,jid)=countsA2;    
    hold on
    
    data_all(:,(4*(jid-1)+1):(4*(jid)))=[thetaA2',countsA2',vA2',countsA2'];
end
figure(f3);
xlabel('d_S_k (nm)');
ylabel('HA (^o)');
legend('Location','southeast')
figure(f4);
legend('Location','southeast')
xlabel('d_S_k (nm)');
ylabel('V_s_k(m/s)')
end

%%
% %**********Analysis 3a: HA vs Size Surface Plot (for all)**************
size_edge=linspace(dsk1,dsk2,7);
fil_para.sel_p=p_id;
[vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);
[jA2,j_edgeA2,sksizeA2,sksize_edgeA2,thetaA2,thetaA2_std,countsA2]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,theta_flow,1,size_edge);
figure;
errorbar(sksizeA2,thetaA2,thetaA2_std,'-o')
hold on
plot(sksize_flow,theta_flow,'.r');
[jA2,j_edgeA2,sksizeA2,sksize_edgeA2,vA2,vA2_std,countsA2]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,vsk_flow,1,size_edge);
[thetaA2',thetaA2_std',countsA2',vA2',vA2_std',countsA2']

HAedge=-92.5:5:92.5; 
HAaxis=-90:5:90;
nedge=(length(size_edge)-1);
im=zeros(length(HAaxis),nedge);
im_norm=zeros(length(HAaxis),nedge);
im_norm_norm=zeros(length(HAaxis),nedge);

for el=1:nedge
for HAi=1:length(HAaxis)
    im(HAi,el)=sum(((theta_flow>=HAedge(HAi)).*(theta_flow<HAedge(HAi+1)))'.*(sksize_flow>=size_edge(el)).*(sksize_flow<size_edge(el+1)));
    im_norm(HAi,el)=sum(((theta_flow>=HAedge(HAi)).*(theta_flow<HAedge(HAi+1)))'.*(sksize_flow>=size_edge(el)).*(sksize_flow<size_edge(el+1)))/sum((sksize_flow>=size_edge(el)).*(sksize_flow<size_edge(el+1)));        
end
im_norm_norm(:,el)=im_norm(:,el)/max(im_norm(:,el));
end

im(isnan(im)) = 0;
im_norm(isnan(im_norm)) = 0;
im_norm_norm(isnan(im_norm_norm)) = 0;

figure
avg_v=size_edge(1:end-1)+mean(diff(size_edge))/2;
surf(avg_v, HAaxis, im_norm, 'EdgeColor', 'interp')
colormap('jet');
%zlim([0,0.15]);
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');

hsize=5;h = fspecial('gaussian',hsize,0.5);
h(:,[1,2,4,5])=0;
im_norm_norm_fil = imfilter(im_norm,h);%filter in one dimension only
%im_norm_fil=imgaussfilt(im_norm,1.5);
figure
avg_v=size_edge(1:end-1)+mean(diff(size_edge))/2;
surf(avg_v, HAaxis, im_norm_norm_fil, 'EdgeColor', 'interp')
colormap('jet');
%zlim([0,0.15]);
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');


%save('parameters.mat','conv', 'p_width', 'c1', 'fil_para', 'HAedge', 'HAaxis', 'nedge')
%save('results.mat','jA2', 'sksizeA2', 'data_dsk_HA_j', 'data_dsk_HAstd_j', 'data_dsk_HA_j_N', 'data_dsk_vsk_j', 'data_dsk_vskstd_j', 'data_dsk_vsk_j_N','im','im_norm','im_norm_fil','im_norm_norm')

%%
% %**********Analysis 3b: HA vs Size (for all)**************
% %**********Analysis 3c: Vsk vs Size (for all)**************
% [~,jlist_id]=ismember(p_id,p_sub);
% i_list=(abs(i1(jlist_id)));
% i_list=unique(i_list);
for n2=20
f3=figure;
f4=figure;
i_use=1;
size_edge=linspace(dsk1,dsk2,n2);
%size_edge=linspace(86-6,194+6,9);
theta_edge=-90:5:90;;
fil_para.sel_p=p_id;
[vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);

figure
histogram2(sksize_flow(:),theta_flow(:),size_edge,theta_edge,'FaceColor','flat')
view(2);

figure(f3);
[jA3,j_edgeA3,sksizeA3,sksize_edgeA3,thetaA3,thetaA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,theta_flow,1,size_edge);
thetaA3(countsA3<count_min)=nan;
errorbar(sksizeA3,thetaA3,thetaA3std,'-o','DisplayName','all j_f_l_o_w');
xlabel('d_S_k (nm)');
ylabel('HA (^o)');
%plot(sksizeA3,thetaA3,'-o','DisplayName','all j_f_l_o_w');
hold on
figure(f4);    
[jA3,j_edgeA3,sksizeA3,sksize_edgeA23,vA3,vA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,vsk_flow,1,size_edge);
vA3(countsA3<count_min)=nan;
errorbar(sksizeA3,vA3,vA3std,'-o','DisplayName','all j_f_l_o_w');
xlabel('d_S_k (nm)')
ylabel('V_s_k(m/s)')
hold on
[sksizeA3',thetaA3',thetaA3std',vA3',vA3std',countsA3']
end
% figure(f3);
% xlabel('d_S_k (nm)');
% ylabel('HA (^o)');
% legend('Location','southeast')
% figure(f4);
% legend('Location','southeast')
% xlabel('d_S_k (nm)');
% ylabel('V_s_k(m/s)')

%%
% %******Analysis 3d: HA vs Size (for all j but selected wire width)*******
% %******Analysis 3e: Vsk vs Size (for all j but selected wire width)******
% [~,jlist_id]=ismember(p_id,p_sub);
% i_list=(abs(i1(jlist_id)));
% i_list=unique(i_list);

dFedge=250;%distance from edge (nm)
xcoor=fullstat2(:,6)*13000/1080;
ycoor=fullstat2(:,7)*13000/1080;

x1=min(xcoor);
x2=max(xcoor);

fil_i=((xcoor>(x1+dFedge)).*(xcoor<(x2-dFedge)))==1;
r_cor_in=r_cor(fil_i);
theta_cor_in=theta_cor(fil_i);
sksize_in=sksize(fil_i);
p_no_in=p_no(fil_i);
xcoor=xcoor(fil_i);
ycoor=ycoor(fil_i);

for n2=10
f3=figure;
f4=figure;
i_use=1;
size_edge=linspace(60,200,n2);
%size_edge=linspace(86-6,194+6,9);
theta_edge=-90:5:90;
fil_para.sel_p=p_id;
[vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor_in,theta_cor_in,sksize_in,p_no_in,fil_para);
length(sksize_flow)

figure
histogram2(sksize_flow(:),theta_flow(:),size_edge,theta_edge,'FaceColor','flat')
view(2);

figure(f3);
[jA3,j_edgeA3,sksizeA3,sksize_edgeA3,thetaA3,thetaA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,theta_flow,1,size_edge);
thetaA3(countsA3<count_min)=nan;
errorbar(sksizeA3,thetaA3,thetaA3std,'-o','DisplayName','all j_f_l_o_w');
xlabel('d_S_k (nm)');
ylabel('HA (^o)');
title(strcat('only mid section (',num2str(dFedge),'nm from edge)'))
ylim([-15,45])
%plot(sksizeA3,thetaA3,'-o','DisplayName','all j_f_l_o_w');
hold on
figure(f4);    
[jA3,j_edgeA3,sksizeA3,sksize_edgeA23,vA3,vA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,vsk_flow,1,size_edge);
vA3(countsA3<count_min)=nan;
errorbar(sksizeA3,vA3,vA3std,'-o','DisplayName','all j_f_l_o_w');
xlabel('d_S_k (nm)')
ylabel('V_s_k(m/s)')
title(strcat('only mid section (',num2str(dFedge),'nm from edge)'))
ylim([4,13])
hold on
[sksizeA3',thetaA3',thetaA3std',vA3',vA3std',countsA3']
end

%%
%%histogram of size vs theta/vsk
for n2=14
f3=figure;
f4=figure;
i_use=1;

size_edge=linspace(dsk1,dsk2,n2);
size_bins=mean(diff(size_edge))/2+size_edge(1:(length(size_edge)-1));

%size_bins=70:20:190;

% size_bins=linspace(dsk1,dsk2,n2);
% delta=mean(diff(size_bins));
% size_edge=zeros([1,length(size_bins)+1]);
% size_edge(1:length(size_bins))=size_bins-delta/2;
% size_edge(end)=size_edge(end-1)+delta;

theta_edge=-45:4:90;
theta_bins=mean(diff(theta_edge))/2+theta_edge(1:(length(theta_edge)-1));
fil_para.sel_p=p_id;
[vsk_flow,theta_flow,sksize_flow,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para);

figure
histogram2(sksize_flow(:),theta_flow(:),size_edge,theta_edge,'FaceColor','flat')
N=hist3([theta_flow(:),sksize_flow(:)],{theta_bins,size_bins}); 
%N_norm=N./sum(N);
N_norm=imNorm(N,1,'max','min','min');
[xmat,ymat]=meshgrid(size_bins,theta_bins);
figure
surf(xmat,ymat,N);view(2);shading flat;
figure
surf(xmat,ymat,N_norm);view(2);shading flat;

figure(f3);
[jA3,j_edgeA3,sksizeA3,sksize_edgeA3,thetaA3,thetaA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,theta_flow,1,size_edge);
thetaA3(countsA3<count_min)=nan;
errorbar(sksizeA3,thetaA3,thetaA3std,'-o','DisplayName','all j_f_l_o_w');
%plot(sksizeA3,thetaA3,'-o','DisplayName','all j_f_l_o_w')
xlabel('d_S_k (nm)');
ylabel('HA (^o)');
v_bins=-5:0.5:25;


N=hist3([vsk_flow(:)*c1,sksize_flow(:)],'Ctrs',{v_bins,size_bins}); 
N_norm=imNorm(N,1,'max','min','min');
[xmat,ymat]=meshgrid(size_bins,v_bins);
figure
surf(xmat,ymat,N,'EdgeColor','flat');view(2);
figure
surf(xmat,ymat,N_norm,'EdgeColor','flat');view(2);;shading flat;
figure(f4);    
[jA3,j_edgeA3,sksizeA3,sksize_edgeA23,vA3,vA3std,countsA3]=bin3D(i_use*ones(size(sksize_flow)),sksize_flow,vsk_flow,1,size_edge);
vA3(countsA3<count_min)=nan;
errorbar(sksizeA3,vA3,vA3std,'-o','DisplayName','all j_f_l_o_w');
xlabel('Size(nm)')
ylabel('V_s_k(m/s)')


end

%%
%*****************Size vs edge*****************
dsk_min=60;
dsk_max=200;
x1=min(fullstat2(:,6));
x2=max(fullstat2(:,6));
p_sub=unique(fullstat2(:,2));
%p_id=[5 6 7 8 9 10 27 28 29 30 31 32 33 34];
%for vlim = 0;%[10.06,7.76,5.46,3.16]

fil_i=ismember(fullstat2(:,2),p_id);
%fil_para=logical(fil_para.*(abs(r_cor')>vlim));
dsk_cor_edge=newfullstat2(:,9);
dsk_cor_edge=dsk_cor_edge(fil_i)*13000/(1080);
x_coor=fullstat2(:,6);
x_coor=x_coor(fil_i);
for binN=13
figure
binE=linspace(x1,x2,binN);
avg_binE=zeros(1,length(binE)-1);
std_dsk=zeros(1,length(binE)-1);
avg_dsk=zeros(1,length(binE)-1);
N=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((x_coor>=binE(el)).*(x_coor<binE(el+1)));
    hold_dsk=dsk_cor_edge(hold_i);
    hold_dsk(hold_dsk<dsk_min)=[];
    hold_dsk(hold_dsk>dsk_max)=[];
    avg_dsk(el)= (mean(hold_dsk));
    std_dsk(el)= (std(hold_dsk));
    avg_binE(el)=(binE(el)+binE(el+1))/2;
    N(el)=length(hold_dsk);
end
errorbar((avg_binE-x1)*13000/(1000*1080),avg_dsk,std_dsk);
%ylim([-40 40])
xlabel('edge(um)')
ylabel('dsk(nm)')
end

