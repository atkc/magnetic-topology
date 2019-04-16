
% % filename1='m00';
% % filename3='.bmp';
% % mT=1400;
% % l=length(mT);
conv=13000/256;%/px
len=3000;%um
reso=256;
sk_size_all=70:10:160;
sk_std_all=4:2:10;

fit_data=zeros(length(sk_size_all),length(sk_std_all));
fit_data_er=fit_data;
fit_data_max=fit_data;
fit_data_min=fit_data;
indx=0;
for sk_size = sk_size_all
    indx=indx+1;
    indy=0;
    for sk_std=sk_std_all
        indy=indy+1;
        filename=strcat('skyrmion_',int2str(reso),'px_',int2str(sk_size),'nm_',int2str(sk_std),'std_',int2str(len),'_',num2str(conv),'.png')
        rawIm=imread(filename);
        rawIm = imresize(rawIm,1024/length(rawIm),'bicubic');
        [dgrayIm, ~,binIm1,~,~, centroids,threshVal]=m1_binarize(rawIm, 1,0,15,0,0,0,30,200,0.6,1.75,13,4);
        
        radius=mean(centroids(:,3));
        binIm= filIT( binIm1,30,200,0.6,1.75,13,4,1);
        imshow(binIm1)
        cc=bwconncomp(binIm,4);
        graindata = regionprops(cc,'centroid','Area','PerimeterOld','MajorAxisLength','MinorAxisLength');
        centroids=zeros(length(graindata),5);
        if (length(graindata)>1)
            centroids(:,1:2)=cat(1,graindata.Centroid);
            centroids(:,3)=sqrt([graindata.Area]/pi());
            centroids(:,4)=[graindata.PerimeterOld];

            area=[graindata.Area];
            perimeter=[graindata.PerimeterOld]; 
            roundness = 4*pi*area./perimeter.^2;
            centroids(:,5)=roundness;
        end
        [isofit,unfitno]=m2_fit2d(radius,centroids,dgrayIm,filename,1.25,0,13);  
        if isempty(isofit)
        fit_data(indx,indy)=nan;
        fit_data_er(indx,indy)=nan;
        fit_data_max(indx,indy)=nan;
        fit_data_min(indx,indy)=nan;
        else
        mu=mean(isofit(:,3));
        FWHM=mu*2*(2*log(2))^0.5;
        sdev=std(isofit(:,3));
        FWHMer=sdev*2*(2*log(2))^0.5;
        fit_data(indx,indy)=FWHM;
        fit_data_er(indx,indy)=FWHMer;
        fit_data_max(indx,indy)=max(isofit(:,3))*2*(2*log(2))^0.5;
        fit_data_min(indx,indy)=min(isofit(:,3))*2*(2*log(2))^0.5;
        end
    end
end

fit_data_real=fit_data*13000/1024;
fit_data_er_real=fit_data_er*13000/1024;
impt=300./((70:10:160)./(2*(2*log(2))^0.5));
cm=prism;
figure;
hold on
est_size=zeros(size(sk_size_all));
dmin=zeros(size(fit_data_min));
dmax=zeros(size(fit_data_min));
est_er=est_size;
for ix=1:length(sk_size_all)
    errorbar(sk_std_all,fit_data_real(ix,:),fit_data_er_real(ix,:),'o-','Color',cm(ix,:),'LineWidth',2)
    plot(sk_std_all,ones(length(sk_std_all))*sk_size_all(ix),'--','Color',cm(ix,:))
    plot(impt(ix),sk_size_all(ix),'dr','MarkerSize',10,'LineWidth',3)
    est_size(ix)=interp1(sk_std_all,fit_data_real(ix,:),impt(ix));
    est_er=(est_size-sk_size_all)./sk_size_all;
    dmin(ix,:)=abs(fit_data_min(ix,:).*13000/1024-sk_size_all(ix));
    dmax(ix,:)=abs(fit_data_max(ix,:).*13000/1024-sk_size_all(ix));
end
ylabel('Skyrmion Size (um)')
xlabel('Skyrmion-Skyrmion Distance (Std Dev)')