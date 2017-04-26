
filename1='m00';
filename3='.bmp';
mT=1400;
l=length(mT);
meanstd=zeros(l,2);

for i=1:l
%     try
    f=mT(i);
    filename2=int2str(f);
    filename=strcat(strcat(filename1,filename2,filename3));
    [~,name,ext] = fileparts(filename);
    rawIm=imread(filename);
    [dgrayIm, ~, ~, centroids]=m1_binarize(rawIm, 1,0,20,0,0,0,0,4.0000);
    radius=centroids(:,3);
    radius =1.5* max(centroids(:,3));
    [isofit]=m2_fit2d(radius,centroids,dgrayIm,name);
    
    fileID = fopen(strcat(name,'_skyrmion_x_y_sigma_FWHM.txt'),'wt');
    fprintf(fileID,'%.2d %.2d %.2d %.2d\n',isofit(:,1:4)');
    fclose(fileID);
    
    
    mu=mean(isofit(:,3));
    FWHM=mu*2*(2*log(2))^0.5;
    sdev=std(isofit(:,3));
    FWHMer=sdev*2*(2*log(2))^0.5;
    meanstd(i,:)=[centroids(1),centroids(2)];
    
%     end
    
end

    fileID = fopen(('mean_values.txt'),'wt');
    fprintf(fileID,'%.2d %.2d\n',meanstd(:,1:2)');
    fclose(fileID);