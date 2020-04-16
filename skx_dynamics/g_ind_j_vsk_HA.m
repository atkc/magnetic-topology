
i2=abs(i1);
i_u=unique(i2);
minDist=1080/256;%min pixel size
for nedge=30
[~,edges] = histcounts(r_cor,nedge);
for i_check=i_u'%(end); %current to probe
pID=fullstat2(:,2);
upID=unique(pID);
p_check=upID(i2==i_check);
fil_ind=ismember(pID,p_check);


figure;
r=r_cor(fil_ind);
theta=theta_cor(fil_ind);
[N,edges] = histcounts(r,edges);
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
end

fig=subplot(2,1,1);
errorbar(avg_v,avg_theta,std_theta);
ylim([-50 30])
xlabel('speed(|m/s^2|)')
ylabel('Theta(o)')
title(strcat('j=',num2str(round(i_check*1e-11,2,'decimal')),'E11','| No of Bins: ',num2str(nedge)));

subplot(2,1,2)
binC=edges(1:end-1)+mean(diff(edges))/2;
bar(binC,N);
xlabel('speed(|m/s^2|)')
ylabel('No of Skyrmions (#)')

saveas(fig,strcat('j=',num2str(round(i_check*1e-11,2,'decimal')),'E11','.png'))

end
end