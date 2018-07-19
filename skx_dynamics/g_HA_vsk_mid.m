%Speed vs Hall angle plot
%only process skyrmions 1um away from the edges
col_plot=0;%0:off, 1:on
xpos=fullstat2(:,6);
ypos=fullstat2(:,7);
xmin=min(xpos);
xmax=max(xpos);
xmid=mean([xmin,xmax]);
x_right=xmid+(0.5*1080/13);
x_left=xmid-(0.5*1080/13);
fil_index=(((xpos>x_left).*(xpos<x_right))==1);

figure
plot(xpos,ypos,'.b')
axis equal

figure
plot(xpos(fil_index),ypos(fil_index),'or')
hold on
plot(xpos(~fil_index),ypos(~fil_index),'.b')
axis equal

for nedge=24
HAedge=-92.5:5:92.5; 
HAaxis=-90:5:90;
im=zeros(length(HAaxis),nedge);
im_norm=zeros(length(HAaxis),nedge);
im_norm_norm=zeros(length(HAaxis),nedge);
figure;
r=r_cor(fil_index);%(pID<p_lim)
theta=theta_cor(fil_index);%(pID<p_lim);
[N,edges] = histcounts(r,nedge);
avg_v=zeros(1,length(N));
avg_theta=zeros(1,length(N));
std_theta=zeros(1,length(N));
for el=1:length(edges)-1
    hold_i=logical((r>=edges(el)).*(r<edges(el+1)));
    hold_theta=(180/pi)*theta(hold_i);
    hold_theta=hold_theta+(hold_theta<-90)*180;
    hold_theta=hold_theta-(hold_theta>90)*180;
    avg_theta(el)= (mean(hold_theta))
    std_theta(el)= (std(hold_theta));
    avg_v(el)=(edges(el)+edges(el+1))/2;
    for HAi=1:length(HAaxis)
        im(HAi,el)=sum((hold_theta>HAedge(HAi)).*(hold_theta<HAedge(HAi+1)));
        im_norm(HAi,el)=sum((hold_theta>HAedge(HAi)).*(hold_theta<HAedge(HAi+1)))/length(hold_theta);        
    end
    
    im_norm_norm(:,el)=im_norm(:,el)/max(im_norm(:,el));
end

errorbar(avg_v,avg_theta,std_theta);
data=[avg_v;N;avg_theta;std_theta]';
ylim([-50 50])
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

figure;
surf(avg_v, HAaxis, im_norm, 'EdgeColor', 'interp')
colormap('jet');
caxis([0 0.5])
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Normalized Sk counts');

figure;
surf(avg_v, HAaxis, im_norm_norm, 'EdgeColor', 'interp')
colormap('autumn');
caxis([0 1])
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Normalized Sk counts amplified to 1');

H = fspecial('average',3);
imfil = imfilter(im,H);
figure;
surf(avg_v, HAaxis, imfil, 'EdgeColor', 'interp')
colormap('jet');
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');

figure;
contour(avg_v, HAaxis, imfil,8)
colormap('jet');
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');

H = fspecial('average',3);
imfil = imfilter(im_norm,H);
figure;
surf(avg_v, HAaxis, imfil, 'EdgeColor', 'interp')
colormap('jet');
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');

figure;
contour(avg_v, HAaxis, imfil,8)
colormap('jet');
view([0,90]);
xlabel('V_sk (m/s)')
ylabel('Hall Angle (^o)')
c = colorbar;
ylabel(c,'Sk Counts');
end
end