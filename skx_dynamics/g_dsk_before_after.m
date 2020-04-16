%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
conv=13000/1080; %estimated nm/px
[~,pl,~]=size(newMasterList);

dsk_raw=newMasterList(:,:,4);

%to weed out errors in fitting/outliers
dsk_fil=dsk_raw;
dsk_fil(dsk_fil>=(dsk_mean+4*dsk_std))=0;
dsk_fil(dsk_fil<=(dsk_mean-4*dsk_std))=0;
dsk_nan=dsk_fil;
dsk_nan(dsk_fil==0)=NaN;
dsk_mean=nanmean(dsk_nan(:));
dsk_std=nanstd(dsk_nan(:));

dDsk=diff(dsk_fil,1,2);
dDsk(dsk_fil(:,1:pl-1)==0)=NaN;%remove if before dsk=0nm (sk was not there initially)
dDsk(dsk_fil(:,2:pl)==0)=NaN;%remove if after dsk=0nm (sk got annihilated)

dDsk_percent_mean=nanmean((dDsk)./dsk_fil(:,1:pl-1));
dDsk_percent_std=nanstd((dDsk)./dsk_fil(:,1:pl-1));
dDsk_percent_mean_abs=nanmean(abs(dDsk)./dsk_fil(:,1:pl-1));
dDsk_percent_std_abs=nanstd(abs(dDsk)./dsk_fil(:,1:pl-1));

dDsk_mean=nanmean((dDsk));
dDsk_std=nanstd((dDsk));
dDsk_mean_abs=nanmean(abs(dDsk));
dDsk_std_abs=nanstd(abs(dDsk));

%%Change in dsk stats
figure;
errorbar(1:length(dDsk_mean),dDsk_mean*conv,dDsk_std*conv);
ylabel('d dsk(nm)')
xlabel('Pulse No (#)')
title('Average Change in dsk(nm) after pulsing');

figure;
errorbar(1:length(dDsk_mean),dDsk_percent_mean*100,dDsk_percent_std*100);
ylabel('d dsk(%)')
xlabel('Pulse No (#)')
title('Average Change in dsk(%) after pulsing');

%% Absolute change in dsk stats
figure;
errorbar(1:length(dDsk_mean_abs),dDsk_mean_abs*conv,dDsk_std_abs*conv);
ylabel('d dsk(nm)')
xlabel('Pulse No (#)')
title('Average Absolute Change in dsk(nm) after pulsing');

figure;
errorbar(1:length(dDsk_mean_abs),dDsk_percent_mean_abs*100,dDsk_percent_std_abs*100);
ylabel('d dsk(%)')
xlabel('Pulse No (#)')
title('Average Absolute Change in dsk(%) after pulsing');
%% Histogram of dsk
%%Histogram of dsk
dsk_plot=dsk_fil;
dsk_plot(dsk_fil==0)=NaN;

figure;
histogram(dsk_nan*conv);
ylabel('Counts(#)')
xlabel('d_{sk}(nm)')
title('Histogram of d_{sk}');
%imaster=[current]*conv=-3.8095e+11%for 180412-1_fp553_1b_d2_2um_n4k-p750
%pmaster is the pulse number as in newmasterlist



%% Change in dsk wrt first dsk (calculations)
p1=5;
dsk_p1=dsk_fil(:,p1);%initial dsk
dDsk_p1=dsk_fil-dsk_fil(:,p1);
dDsk_p1(dsk_p1(:,1)==0,:)=NaN;%remove if p1 size is 0 (empty)
dDsk_p1(dsk_fil==0)=NaN;%remove if before dsk=0nm (sk was not there initially, or filtered)

dDsk_p1_percent_mean=nanmean((dDsk_p1)./dsk_p1);
dDsk_p1_percent_std=nanstd((dDsk_p1)./dsk_p1);
dDsk_p1_percent_mean_abs=nanmean(abs(dDsk_p1)./dsk_p1);
dDsk_p1_percent_std_abs=nanstd(abs(dDsk_p1)./dsk_p1);

dDsk_p1_mean=nanmean((dDsk_p1));
dDsk_p1_std=nanstd((dDsk_p1));
dDsk_p1_mean_abs=nanmean(abs(dDsk_p1));
dDsk_p1_std_abs=nanstd(abs(dDsk_p1));

%% Change in dsk wrt p1
figure;
errorbar(1:length(dDsk_p1_mean),dDsk_p1_mean*conv,dDsk_p1_std*conv);
ylabel('d dsk(nm)')
xlabel('Pulse No (#)')
title('Average Change in dsk(nm) wrt p1 after pulsing');

figure;
errorbar(1:length(dDsk_p1_mean),dDsk_p1_percent_mean*100,dDsk_p1_percent_std*100);
ylabel('d dsk(%)')
xlabel('Pulse No (#)')
title('Average Change in dsk(%) wrt p1 after pulsing');

%% Absolute change in dsk wrt p1
figure;
errorbar(1:length(dDsk_p1_mean_abs),dDsk_p1_mean_abs*conv,dDsk_p1_std_abs*conv);
ylabel('d dsk(nm)')
xlabel('Pulse No (#)')
title('Average Absolute Change in dsk(nm) wrt p1 after pulsing');

figure;
errorbar(1:length(dDsk_p1_mean_abs),dDsk_p1_percent_mean_abs*100,dDsk_p1_percent_std_abs*100);
ylabel('d dsk(%)')
xlabel('Pulse No (#)')
title('Average Absolute Change in dsk(%) wrt p1 after pulsing');

save('dsk_change.mat','pmaster','imaster','dsk_raw','dsk_fil','dDsk',...
    'dDsk_percent_mean','dDsk_percent_std','dDsk_mean','dDsk_std',...
    'dDsk_percent_mean_abs','dDsk_percent_std_abs','dDsk_mean_abs',...
    'dDsk_std_abs','p1','dsk_p1','dDsk_p1','dDsk_p1_percent_mean',...
    'dDsk_p1_percent_std','dDsk_p1_percent_mean_abs',...
    'dDsk_p1_percent_std_abs','dDsk_p1_mean','dDsk_p1_std',...
    'dDsk_p1_mean_abs','dDsk_p1_std_abs');