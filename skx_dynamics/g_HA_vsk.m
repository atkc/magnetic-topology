%Speed vs Hall angle plot
op=0;%op: 0(all currents),1(negative j),2(positive j)
Nlim=5;%plot points with at # of sk > Nlim

[fullstat2_fil,r_cor_fil,theta_cor_fil]=minDist_filter(fullstat2,r_cor,theta_cor);
pID1=unique(fullstat2(:,2));
pID2=unique(fullstat2_fil(:,2));

[~,ia,~]=intersect(pID1,pID2);
i1_fil=i1(ia);

index=fwbw_filter(i1_fil,fullstat2_fil,op);%1:neg current, 2: pos current
col_plot=1;%0:off, 1:on
for nedge=23
HAedge=-92.5:5:92.5; 
HAaxis=-90:5:90;
im=zeros(length(HAaxis),nedge);
im_norm=zeros(length(HAaxis),nedge);
im_norm_norm=zeros(length(HAaxis),nedge);
figure;
r=r_cor_fil(index)%(pID<p_lim);
theta=theta_cor_fil(index)%(pID<p_lim);
[N,edges] = histcounts(r,nedge);
avg_v=zeros(1,length(N));
avg_theta=zeros(1,length(N));
std_theta=zeros(1,length(N));
for el=1:length(edges)-1
    hold_i=logical((r>=edges(el)).*(r<edges(el+1)));
    hold_theta=(180/pi)*theta(hold_i);
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    avg_theta(el)= (mean(hold_theta));
    std_theta(el)= (std(hold_theta));
    avg_v(el)=(edges(el)+edges(el+1))/2;
    for HAi=1:length(HAaxis)
        im(HAi,el)=sum((hold_theta>HAedge(HAi)).*(hold_theta<HAedge(HAi+1)));
        im_norm(HAi,el)=sum((hold_theta>HAedge(HAi)).*(hold_theta<HAedge(HAi+1)))/length(hold_theta);        
    end
    
    im_norm_norm(:,el)=im_norm(:,el)/max(im_norm(:,el));
end
data=[avg_v;N;avg_theta;std_theta]'
errorbar(avg_v(N>Nlim),avg_theta(N>Nlim),std_theta(N>Nlim));
ylim([-10 30])
xlabel('speed(|m/s^2|)')
ylabel('Theta(o)')

if (col_plot==1)

im(isnan(im)) = 0;
im_norm(isnan(im_norm)) = 0;
im_norm_norm(isnan(im_norm_norm)) = 0;

figure
surf(avg_v, HAaxis, im, 'EdgeColor', 'interp')
colormap('jet');
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');

% figure;
% surf(avg_v, HAaxis, im_norm, 'EdgeColor', 'interp')
% colormap('jet');
% caxis([0 0.5])
% view([0,90]);
% xlabel('V_sk (m/s)')
% ylabel('Hall Angle (^o)')
% c = colorbar;
% ylabel(c,'Normalized Sk counts');

% figure;
% surf(avg_v, HAaxis, im_norm_norm, 'EdgeColor', 'interp')
% colormap('autumn');
% caxis([0 1])
% view([0,90]);
% xlabel('V_sk (m/s)')
% ylabel('Hall Angle (^o)')
% c = colorbar;
% ylabel(c,'Normalized Sk counts amplified to 1');
% 
H = fspecial('average',2);
%imfil = imfilter(im,H);
imfil = imgaussfilt(im,1);
figure;
surf(avg_v, HAaxis, imfil, 'EdgeColor', 'interp')
colormap('jet');
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');
% 
% figure;
% contour(avg_v, HAaxis, imfil,8)
% colormap('jet');
% view([0,90]);
% xlabel('V_sk (m/s)')
% ylabel('Hall Angle (^o)')
% c = colorbar;
% ylabel(c,'Sk Counts');

% H = fspecial('average',3);
% imfil = imfilter(im_norm,H);
% imfil = imgaussfilt(im_norm);
% figure;
% surf(avg_v, HAaxis, imfil, 'EdgeColor', 'interp')
% colormap('jet');
% view([0,90]);
% xlabel('V_sk (m/s)')
% ylabel('Hall Angle (^o)')
% c = colorbar;
% ylabel(c,'Sk Counts');
% 
% figure;
% contour(avg_v, HAaxis, imfil,8)
% colormap('jet');
% view([0,90]);
% xlabel('V_sk (m/s)')
% ylabel('Hall Angle (^o)')
% c = colorbar;
% ylabel(c,'Sk Counts');
end
end