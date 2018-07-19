noBins=20; % number of bins
op=1; %flow criteria 1: flow current, 2: flow speed, 3: both
flowi=5.38e11;%get flow current(polarity matters!)
flow_pol=1;%polarity mode: 1: single, 2 : both
flowv=0;
mode=1;%1: flow dynamics, -1: creep+stochastic
conv=13000/1080;

pID=unique(fullstat2(:,2));

if (op==1)
    if flow_pol==1
        if flowi>0
            flowp=pID((((i1)>0).*((mode*(i1))>(mode*flowi)))==1);
        else
            flowp=pID((((i1)<0).*((mode*(i1))<(mode*flowi)))==1);
        end
    else
        flowi=abs(flowi);
        flowp=pID((mode*abs(i1))>(mode*flowi));
    end
    fil_para=ismember(fullstat2(:,2),flowp);

elseif (op==2)
    fil_para=abs(r_cor')>flowv;
else
    if flow_pol==1
        if flowi>0
            flowp=pID((((i1)>0).*((mode*(i1))>(mode*flowi)))==1);
        else
            flowp=pID((((i1)<0).*((mode*(i1))<(mode*flowi)))==1);
        end
    else
        flowi=abs(flowi);
        flowp=pID((mode*abs(i1))>(mode*flowi));
    end
    fil_para=ismember(fullstat2(:,2),flowp);
    fil_para=logical(fil_para.*(abs(r_cor')>flowv));
end

x_coor=fullstat2(:,6);
x_coor=x_coor(fil_para);
theta_cor_edge=theta_cor(fil_para);
r_cor_edge=r_cor(fil_para);
x1=min(x_coor);
x2=max(x_coor);


for binN=noBins
    figure;
    binE=linspace(x1,x2,binN);
    avg_binE=zeros(1,length(binE)-1);
    std_theta=zeros(1,length(binE)-1);
    avg_theta=zeros(1,length(binE)-1);
    std_v=zeros(1,length(binE)-1);
    avg_v=zeros(1,length(binE)-1);
    for el=1:length(binE)-1
        %angular deflection analysis
        hold_i=logical((x_coor>=binE(el)).*(x_coor<binE(el+1)));
        hold_theta=(180/pi)*theta_cor_edge(hold_i);
        hold_theta=hold_theta+(hold_theta<-90)*180;
        hold_theta=hold_theta-(hold_theta>90)*180;
        avg_theta(el)= (mean(hold_theta));
        std_theta(el)= (std(hold_theta));
        avg_binE(el)=(binE(el)+binE(el+1))/2;
        %Speed velocity
        hold_v=r_cor_edge(hold_i);
        avg_v(el)=mean(hold_v);
        std_v(el)=std(hold_v);
    end
%     figure
%     subplot(2,1,1)
%     binC=(avg_binE-x1)*conv;
%     errorbar(binC,avg_theta,std_theta);
%     ylim([-40 40])
%     xlabel('edge(um)')
%     ylabel('Theta(o)')
%     title(strcat('No of Bins: ',num2str(binN)));
%     
%     [N,~]=histcounts(x_coor,binE);
%     subplot(2,1,2)
%     bar(binC,N);
%     xlabel('edge(um)')
%     ylabel('No of Skyrmions (#)')
%     figure
    subplot(2,1,1)
    binC=(avg_binE-x1)*conv;
    errorbar(binC,avg_v,std_v);
    ylim([0 15])
    xlabel('edge(um)')
    ylabel('speed(m/s)')
    title(strcat('No of Bins: ',num2str(binN)));
    
    [N,~]=histcounts(x_coor,binE);
    subplot(2,1,2)
    bar(binC,N);
    xlabel('edge(um)')
    ylabel('No of Skyrmions (#)')
end
data2=[(avg_binE-x1)*13000/(1000*1080);N;avg_v;std_v]';
data1=[(avg_binE-x1)*13000/(1000*1080);N;avg_theta;std_theta]';