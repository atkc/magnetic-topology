
pulseId=5:22;
foldername='C:\Users\Anthony\Dropbox\Shared_MFM\Data\Nanostructures\fp553_nanostructures\180417-1_fp553_1b_d3_2um_n4k-p750\analysis\registered_ctf\';
filename='Reg_180417_fp553_1b_d3_2um_p';
imageSize=13;%um
saveInd = 0;  
%maxr=1.25:0.25:1.75;
approx_r_real=80;%nm
edges=50:10:200;
skz=80:10:160;
skstd=4:2:8;
maxr=0.95:0.25:4.95;

fit1_mat=zeros([length(skz),length(skstd),length(maxr)]); %weighted G fit
fit2_mat=fit1_mat; %weighted G fit * circular mask
fit3_mat=fit1_mat; %Normal G fit 
fit4_mat=fit1_mat; %Normal G fit * circular mask
nfit1_mat=fit1_mat;
nfit2_mat=fit1_mat;
nfit3_mat=fit1_mat;
nfit4_mat=fit1_mat;
std1_mat=fit1_mat;
std2_mat=fit1_mat;
std3_mat=fit1_mat;
std4_mat=fit1_mat;
er1_mat=fit1_mat;
er2_mat=fit1_mat;
er3_mat=fit1_mat;
er4_mat=fit1_mat;

for skz_i=1:length(skz)
    for skstd_i=1:length(skstd)
    try
    halfFileName=strcat('skyrmion_256px_',int2str(skz(skz_i)),'nm_');
    fullFileName1=strcat(halfFileName,int2str(skstd(skstd_i)),'std_3000_50.7813.png');%strcat(foldername,halfFileName);
    im_fit=imread(fullFileName1);
    im_fit=double(im_fit);%imresize(im_fit,4,'nearest');
    [im_fit_size,~]=size(im_fit);
    approx_r=approx_r_real*im_fit_size/(imageSize*1000);
    fit_resize=im_fit_size/1080;
    im_fit = imresize(im_fit,1/fit_resize,'bicubic');
    dgrayIm=im_fit*255/max(max(im_fit));
    
    [dgrayIm, ~,binIm1,~,~, centroids_fit,threshVal]=m1_binarize(dgrayIm, 1,0,15,0,0,0,30,200,0.6,1.75,13,4);

    radius=mean(centroids_fit(:,3));
    binIm= filIT( binIm1,30,200,0.6,1.75,13,4,1);
%     imshow(binIm1)
    cc=bwconncomp(binIm,4);
    graindata = regionprops(cc,'centroid','Area','PerimeterOld','MajorAxisLength','MinorAxisLength');
    centroids_fit=zeros(length(graindata),5);
    if (length(graindata)>1)
        centroids_fit(:,1:2)=cat(1,graindata.Centroid);
        centroids_fit(:,3)=sqrt([graindata.Area]/pi());
        centroids_fit(:,4)=[graindata.PerimeterOld];

        area=[graindata.Area];
        perimeter=[graindata.PerimeterOld]; 
        roundness = 4*pi*area./perimeter.^2;
        centroids_fit(:,5)=roundness;
    end
% %     [ml,~,~]=size(MasterList);
% %     centroids_fit=reshape(MasterList(:,pulseId(p_i),2:3),[ml,2]);
    centroids_fit_adj=[centroids_fit(:,1),centroids_fit(:,2)];
    [sk_l,~]=size(centroids_fit);
% %     match=zeros([sk_l,3]);
% % %     figure
%     imshow(dgrayIm,[0,255])
%     hold on;
%     plot(centroids_fit_adj(:,1),centroids_fit_adj(:,2),'g*')
    fit_1=zeros([sk_l,length(maxr)]);
    fit_2=zeros([sk_l,length(maxr)]);
    fit_3=zeros([sk_l,length(maxr)]);
    fit_4=zeros([sk_l,length(maxr)]);
    
    er_1=zeros([sk_l,length(maxr)]);
    er_2=zeros([sk_l,length(maxr)]);
    er_3=zeros([sk_l,length(maxr)]);
    er_4=zeros([sk_l,length(maxr)]);
    
    for sk_i=1:sk_l
        
        if (~all(centroids_fit(sk_i,:)==0)) 
            maxri=1;
            
            
            display(strcat('sk  ',int2str(sk_i),' fit 1'));
            [isofit,~,ex1]=m2_fit2d((approx_r/fit_resize), centroids_fit_adj(sk_i,:),dgrayIm,fullFileName1,1.5,0,imageSize,0);
            new_xy=(isofit(1:2));
            FWHM=isofit(4);
            fit_1(sk_i)=FWHM;
            %2.3548sigma
            for maxri=1:length(maxr)
            %MasterList(sk_i,pulseId(p_i),2:4)=[new_xy-1,FWHM];
            display(strcat('sk  ',int2str(sk_i),' fit 2'));
            
            [isofit1,~,~,res1]=m2_fit2d(isofit(4)/2, new_xy-1,dgrayIm,fullFileName1,maxr(maxri),saveInd,imageSize,0);
            [isofit2,~,~,res2]=m2_fit2d(isofit(4)/2, new_xy-1,dgrayIm,fullFileName1,maxr(maxri),saveInd,imageSize,1);
            [isofit3,~,~,res3]=m2_fit2d_2nd(isofit(4)/2, new_xy-1,dgrayIm,fullFileName1,maxr(maxri),saveInd,imageSize,0);
            [isofit4,~,~,res4]=m2_fit2d_2nd(isofit(4)/2, new_xy-1,dgrayIm,fullFileName1,maxr(maxri),saveInd,imageSize,1);

            fit_1(sk_i,maxri)=isofit1(4)*13000/1080;
            er_1(sk_i,maxri)=res1;
            fit_2(sk_i,maxri)=isofit2(4)*13000/1080;
            er_2(sk_i,maxri)=res2;
            fit_3(sk_i,maxri)=isofit3(4)*13000/1080;
            er_3(sk_i,maxri)=res3;
            fit_4(sk_i,maxri)=isofit4(4)*13000/1080;
            er_4(sk_i,maxri)=res4;
            
       
            
            end
        end
       
      
    end
    figure('pos',[10 10 900 600])
    subplot(2,4,1)
    errorbar(maxr,mean(fit_1),std(fit_1))
    title('Weighted G')
    subplot(2,4,2)
    errorbar(maxr,mean(fit_2),std(fit_2))
    title('Weighted G + Mask')
    subplot(2,4,3)
    errorbar(maxr,mean(fit_3),std(fit_3))
    title('G')
    subplot(2,4,4)
    errorbar(maxr,mean(fit_4),std(fit_4))
    title('G + Mask')
    fit1_mat(skz_i,skstd_i,:)=mean(fit_1);
    fit2_mat(skz_i,skstd_i,:)=mean(fit_2);
    fit3_mat(skz_i,skstd_i,:)=mean(fit_3);
    fit4_mat(skz_i,skstd_i,:)=mean(fit_4);

    nfit1_mat(skz_i,skstd_i,:)=mean(fit_1)./skz(skz_i);
    nfit2_mat(skz_i,skstd_i,:)=mean(fit_2)./skz(skz_i);
    nfit3_mat(skz_i,skstd_i,:)=mean(fit_3)./skz(skz_i);
    nfit4_mat(skz_i,skstd_i,:)=mean(fit_4)./skz(skz_i);
    
    std1_mat(skz_i,skstd_i,:)=std(fit_1);
    std2_mat(skz_i,skstd_i,:)=std(fit_2);
    std3_mat(skz_i,skstd_i,:)=std(fit_3);
    std4_mat(skz_i,skstd_i,:)=std(fit_4);    
    
    subplot(2,4,5)
    plot(maxr,mean(er_1))
    title(strcat(int2str(skz(skz_i)),'nm ',int2str(skstd(skstd_i)),'std'));
    subplot(2,4,6)
    plot(maxr,mean(er_2))
    subplot(2,4,7)
    plot(maxr,mean(er_3))
    subplot(2,4,8)
    plot(maxr,mean(er_4))
    er1_mat(skz_i,skstd_i,:)=mean(er_1);
    er2_mat(skz_i,skstd_i,:)=mean(er_2);
    er3_mat(skz_i,skstd_i,:)=mean(er_3);
    er4_mat(skz_i,skstd_i,:)=mean(er_4);
    
    
    print(strcat(int2str(skz(skz_i)),'_',int2str(skstd(skstd_i))),'-dpng')
    close all
    %catch
    %end
%     mat=reshape(MasterList(:,pulseId(p_i),:),[ml,4]);
%     mat=mat(mat(:,4)~=0,:);
%     figure;
%     imshow(dgrayIm,[0,255])
%     hold on;
%     plot(mat(:,2)-420,mat(:,3),'b*');
%     figure;
%     sksize=mat(:,4);
%     figure
%     histogram(fit_1(((fit_1(:,3)~=0).*(fit_1(:,4)==0))==1,3)*13000/1080,edges)
%     figure
%     histogram(fit_2(((fit_2(:,3)~=0).*(fit_1(:,4)==0))==1,3)*13000/1080,edges)
% %     title(halfFileName)
    
    end
end
% figure
% bb=fit_2;
% bb(bb>16.6154)=0;
% for l=1:length(bb)
%     hold on
%     aa=bb(l,:)*13000/1080%/max(bb(l,:));
%     plot(1.25:0.25:5,aa);
end
save fit_data_256.mat fit1_mat fit2_mat fit3_mat fit4_mat nfit1_mat nfit2_mat nfit3_mat nfit4_mat std1_mat std2_mat std3_mat std4_mat er1_mat er2_mat er3_mat er4_mat

score1=abs(nfit1_mat-1).^2;
score2=abs(nfit2_mat-1).^2;
score3=abs(nfit3_mat-1).^2;
score4=abs(nfit4_mat-1).^2;

score1=nanmean(score1,1);
score1=nanmean(score1,2);
score2=nanmean(score2,1);
score2=nanmean(score2,2);
score3=nanmean(score3,1);
score3=nanmean(score3,2);
score4=nanmean(score4,1);
score4=nanmean(score4,2);

figure;
plot(maxr,score1(:))
hold on;
plot(maxr,score2(:))
hold on;
plot(maxr,score3(:))
hold on;
plot(maxr,score4(:))
legend({'weighted G','weighted G + Mask','Normal G','Normal G + Mask'})
title('Average error for fit of 80-160 nm size and 2-6 std dev sk-sk distance')
ylim([0,0.015])
xlabel('window size (std)')
ylabel('Mean error (abs(fit-d_s_k)/d_s_k)^2')

score1=abs(nfit1_mat-1).^2;
score2=abs(nfit2_mat-1).^2;
score3=abs(nfit3_mat-1).^2;
score4=abs(nfit4_mat-1).^2;

score1=max(score1,[],1);
score1=max(score1,[],2);
score2=max(score2,[],1);
score2=max(score2,[],2);
score3=max(score3,[],1);
score3=max(score3,[],2);
score4=max(score4,[],1);
score4=max(score4,[],2);

figure;
plot(maxr,score1(:))
hold on;
plot(maxr,score2(:))
hold on;
plot(maxr,score3(:))
hold on;
plot(maxr,score4(:))

ylim([0,0.1])
legend({'weighted G','weighted G + Mask','Normal G','Normal G + Mask'})
title('Max error for fit of 80-160 nm size and 2-6 std dev sk-sk distance')
legend({'weighted G','weighted G + Mask','Normal G','Normal G + Mask'})
xlabel('window size (std)')
ylabel('Max error (abs(fit-d_s_k)/d_s_k)^2')