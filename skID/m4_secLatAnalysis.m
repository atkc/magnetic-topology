%%**********save info******************
saveIt=false;

%%***********load info*****************
cd('C:\Users\Anthony\Documents\MATLAB\fit_skyrmion\constructed lattice');
isofitM.i=load('isofit_ideal.mat');
imSizeM.i=0;

isofitM.a=load('isofit_11a_3.mat');
imSizeM.a=2;

isofitM.b=load('isofit_11b.mat');
imSizeM.b=8;

isofitM.c=load('isofit_11c.mat');
imSizeM.c=3;

isofitM.d=load('isofit_11d.mat');
imSizeM.d=5;

isofitM.e=load('isofit_11e.mat');
imSizeM.e=2;

isofitM.f=load('isofit_11f.mat');
imSizeM.f=2;

isofitM.o=load('isofit_11o.mat');
imSizeM.o=2;

isofitM.p=load('isofit_11p.mat');
imSizeM.p=5;

fieldname='d';%['b';'a';'p';'c';'o';'e';'d';'f'];%['a';'b';'p';'c';'o';'e';'d';'f'];%['f';'d';'e';'o';'c';'p';'b';'a'];%['a';'b';'c';'d';'e';'f';'o';'p';'i';];
mul1=1;
mul2=1;
bar3nn=zeros(mul1*8,12);
bar3angle=zeros(mul2*8,30);
qfact=zeros(8,2);
meanIt=zeros(8,4);
length(qfact)

%%**********generate matrix to hold data**************
latDat=zeros(length(fieldname),6);% mean angle, std dev, 95% cf, mean nn, std dev, 95% cf

for fieldID=1:length(fieldname)
    isofit=struct2cell(isofitM.(fieldname(fieldID)));
    isofit=cell2mat(isofit);
    isofit=im2double(isofit);
    %%*******************************************
    %%determine D-trianglation of set of vertices
    %%*******************************************
    dt=delaunayTriangulation(isofit(:,1),isofit(:,2));
    
    %%*******************************************
    %%Normalized Angle statistics
    %%*******************************************
    vertices=[dt.Points];
    trigID=[dt.ConnectivityList];
    anglestat=zeros(length(trigID),3);
    for i=1:length(trigID)
      v1=vertices(trigID(i,1),:);
      v2=vertices(trigID(i,2),:);
      v3=vertices(trigID(i,3),:);
      anglestat(i,:)=TRIangles([v1;v2;v3]);
    end
    
    anglestat=anglestat(:);
    aindex1=(anglestat>20);
    aindex2=(anglestat<100);
    aindex=aindex1 & aindex2;
    anglestat2=anglestat(aindex);
    figure;
    [freq,ang]=hist(anglestat2,30);
    freq=freq/length(anglestat2);
    bar3angle(mul1*fieldID,:)=freq;
    bar(ang,freq); 
    axis([0,180,0,0.12]);
    xlabel('Angle in Degrees');
    ylabel('Norm. Frequency (#)');
    
    %%****fit routine*****
    x=ang;
    y=freq;
    startPt=[1,60,20,0];
    gaussEqn ='a*exp(-((x-b)/c)^2)+d';
    angleF=fit(x',y',gaussEqn,'start',startPt,'Exclude',x<20,'Exclude',x>100);
    
    %%****extract guassian fit data*****
    meanAng=angleF.b;
    meanAngStd=angleF.c;
    height=angleF.a;
    cf=confint(angleF);
    meanAngCF=(meanAng-cf(3));
    Qfactor=1000*(height/(2*(meanAngStd)))/(abs(meanAng-60));
    qfact(fieldID,1)=Qfactor;
    meanIt(fieldID,1:2)=[meanAng,meanAngStd];
    title(strcat('xci11',fieldname(fieldID),' Orientation Statistics, Q-Factor: ',num2str(Qfactor)));
    if saveIt
        print(strcat('xci11',fieldname(fieldID),' Orientation Statistics (norm)'),'-dpng');
    end
    
    latDat(fieldID,1)=meanAng;%mean angle, mean() does not work -> TOO BIG
    latDat(fieldID,2)=meanAngStd;%mean angle std dev
    latDat(fieldID,3)=meanAngCF;%mean angle CF
    %%*******************************************
    %%Normalized NN statistics
    %%*******************************************
    foldStat=zeros(length(dt.Points),1);

    for i=1:length(dt.Points)
        foldStat(i) = length(cell2mat(vertexAttachments(dt,i)));
    end
    
    figure;
    NNBinCenter=(1:12);
    [NNfreq,NN]=hist(foldStat,NNBinCenter);
    NNfreq=NNfreq/length(foldStat);
    bar((0.5:11.5),NNfreq,'histc'); 
    bar3nn(mul2*fieldID,:)=NNfreq;
    bar(NN,NNfreq); 
    axis([0,12,0,0.6]);
    xlabel('# of neighbours ')
    ylabel('Norm. Frequency (#)')

    %%****fit routine*****
    NNx=NN;
    NNy=NNfreq;
    NNstartPt=[1,6,2,0];
    NNgaussEqn ='a*exp(-((x-b)/c)^2)+d';
    NNF=fit(NNx',NNy',NNgaussEqn,'start',NNstartPt);

    %%****extract guassian fit data*****
    meanNN=NNF.b;
    meanNNStd=NNF.c;
    heightNN=NNF.a;
    cfNN=confint(NNF);
    meanNNCF=(meanNN-cfNN(3));
    QfactorNN=(heightNN/(2*(meanNNStd)))/(abs(meanNN-6));
    qfact(fieldID,2)=QfactorNN;
    meanIt(fieldID,3:4)=[meanNN,meanNNStd];
    
    title(strcat('xci11',fieldname(fieldID),' NN Statistics, Q-Factor: ',num2str(QfactorNN)));
    if saveIt
        print(strcat('xci11',fieldname(fieldID),' NN Statistics (norm)'),'-dpng');
    end

    latDat(fieldID,4)=meanNN;%mean NN
    latDat(fieldID,5)=meanNNStd;%mean NN std dev
    latDat(fieldID,6)=meanNNCF;%mean NN 95%CF

    %%*******************************************
    %%pair-wise distance to frequency plot
    %%*******************************************
    
    distStat=pdist([isofit(:,1),isofit(:,2)]);%%calculation of pair wise distance
    distStat=round(distStat);
    imSize=(imSizeM.(fieldname(fieldID)));


    figure; %%overview of plot
    [Dfreq,dist]=hist(distStat,50);
    xlabel('Distance (pixel)')
    ylabel('Frequency (#)')
    Dfreq=Dfreq./dist.^2;
    bar(dist,Dfreq); 
    xlabel('Distance (pixel)')
    ylabel('Frequency (#)')
    
    f2=figure; %%close up of plot

    dindex1=(distStat>0);
    dindex2=(distStat<100);
    dindex=dindex1 & dindex2;
    distStat2=distStat(dindex);
    [Dfreq2,dist2]=hist(distStat2,60);
    Dfreq2=Dfreq2./dist2.^2;
    bar(dist2,Dfreq2); 
    xlabel('Distance (pixel)')
    ylabel('Frequency (#)')
    xlim([0,60]);
    
    title(strcat('xci11',fieldname(fieldID),' Compensated Pair-wise Distance Statistics') );
    if saveIt
        print(strcat('xci11',fieldname(fieldID),' Compensated Pair-wise Distance Statistics'),'-dpng');
    end
    
%     %%*******************************************
%     %%pair-wise distance to frequency plot for extract 1st 4 NN
%     %%*******************************************
%     distStat=round(distStat);
%     dindex3=(distStat>0);
%     dindex4=(distStat<20);
%     dindex=dindex3 & dindex4;
%     distStat4=distStat(dindex);
%     [Dfreq4,dist4]=hist(distStat4,15);
%     figure
%     bar(dist4,Dfreq4); 
%     [~,nn1d]=max(Dfreq4);
%     nn2d=round(sqrt(2)*nn1d);
%     nn3d=round(2*nn1d);
%     Dfreq3=zeros(1,length(Dfreq4));
%     
%     Dfreq3(nn1d)=Dfreq4(nn1d);
%     Dfreq3(nn2d)=Dfreq4(nn2d);
%     Dfreq3(nn3d)=Dfreq4(nn3d);
% 
%     
%     f3=figure;
%     bar(dist4,Dfreq3); 
%     xlabel('Distance (pixel)')
%     ylabel('Frequency (#)')
% 
%     title(strcat('xci11',fieldname(fieldID),' 1st - 3rd NN Statistics (based on NN)') );
%     if saveIt
%         print(strcat('xci11',fieldname(fieldID),' 1st - 3rd NN Statistics'),'-dpng');
%     end
end

% figure
% bar3((bar3angle(1:mul1*8,:))');
% figure
% for i=1:length(fieldname)
%     clear data
%     hold on
%     plot(ang,(bar3angle(mul1*i,:))+i*0.05);
%     angq=20:1:100;
%     data(:,1)=ang;%angq;
%     data(:,2)=bar3angle(mul1*i,:);%interp1(ang,(bar3angle(mul1*i,:))',angq);
%     fileN=strcat('norm orientation statistics_','xci11',fieldname(i),'.mat');
%     save(fileN,'data');
% end
% xlabel('Orientation (Degree)')
% ylabel('Norm. Frequency (#)')
% % figure
% % bar3((bar3nn(1:mul2*8,2:9))');
% figure
% for i=1:length(fieldname)
%     clear data2
%     hold on
%     plot(NN,(bar3nn(mul2*i,:))+i*0.2);
%     NNq=1:0.1:12;
%     
%     data2(:,1)=NN;%NNq;
%     data2(:,2)=bar3nn(mul2*i,:);%interp1(NN,(bar3nn(mul2*i,:))',NNq);
%     fileN=strcat('norm NN statistics_','xci11',fieldname(i),'.mat');
%     save(fileN,'data2');
% end
% xlabel('# of NN')
% ylabel('Norm. Frequency (#)')
% 
%     outDat.('sample')=fieldname;
%     outDat.('mAng')=latDat(:,1);
%     outDat.('mAngStd')=latDat(:,2);
%     outDat.('mNN')=latDat(:,3);
%     outDat.('mNNstd')=latDat(:,4);
%    
%     save('outDat.mat','-struct','outDat')%save data of mean angle and NN for origin plot lol