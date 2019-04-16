
% % filename1='m00';
% % filename3='.bmp';
% % mT=1400;
% % l=length(mT);

s=dir('*.tiff*');
flist={s.name};
l=length(flist);
meanstd=zeros(l,3);

for i=16:l

%     f=mT(i);
%     filename2=int2str(f);
%     filename=strcat(strcat(filename1,filename2,filename3));
    filename=cell2mat(flist(i));
    [~,name,ext] = fileparts(filename);
%     rawIm=imread(filename);
    rawIm=imread(filename);
    %rawIm=imcomplement(rawIm);
% % name='170308_fp226_1b_2_d2_n4k-p1k_p23_MFM';
% %     rawIm=imread('170308_fp226_1b_2_d2_n4k-p1k_p23_MFM.tiff');
    [dgrayIm, ~, ~, centroids]=m1_binarize(rawIm, 1,0,15,0,0,0,0,1.5);
%     imshow(dgrayIm,[0,255]);
    %dgrayIm=im2double(rawIm(:,:,1))*155;
    radius=centroids(:,3);
%     radius =2* max(centroids(:,3));
%     radius=4.5;
    %centroids=[MasterList(:,27,2),MasterList(:,27,3)];
    centroids=centroids(centroids(:,1)~=0,:);
% global dgrayIm
% global radius
% global centroids
% name='fit_nogui';
    [isofit]=m2_fit2d(radius,centroids,dgrayIm,name,2,1,100);

    fileID = fopen(strcat(name,'_skyrmion_x_y_pos.txt'),'wt');
    fprintf(fileID,'%.2d %.2d %.2d %.2d\n',isofit(:,1:4)');
    fclose(fileID);
    
    [noSk,~]=size(isofit);
    mu=mean(isofit(:,3));
    FWHM=mu*2*(2*log(2))^0.5;
    sdev=std(isofit(:,3));
    FWHMer=sdev*2*(2*log(2))^0.5;
    meanstd(i,:)=[FWHM,FWHMer,noSk];
    

end
    fileID = fopen(('mean_values.txt'),'wt');
    fprintf(fileID,'%d %d %d\n',meanstd(:,:)');
    fclose(fileID);
    
    
figure
plot((1:length(meanstd))*0.005,meanstd(:,3))
title('if density (no avg)')
xlabel('Hr(T)')
ylabel('Skyrmion #')
figure
wind=5;
fil=filter((1/wind)*ones(1,wind),1,meanstd(:,3))
plot((1:length(meanstd))*0.005,fil)
xlabel('Hr(T)')
ylabel('Skyrmion #')
title('if density (moving avg window = 5)')