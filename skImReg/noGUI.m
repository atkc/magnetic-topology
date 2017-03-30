
filename1='P';
filename3='mT.bmp';
mT=148:2:2768;
l=length(mT);
meanstd=zeros(l,2);
for i=1:l
    f=mT(i);
    filename2=int2str(f);
    filename=strcat(strcat(filename1,filename2,filename3));
    [~,name,ext] = fileparts(filename);
    rawIm=imread(filename);
    
    [dgrayIm, ~, ~, centroids]=m1_binarize(rawIm, 1,0,15,0,0,0,0.1000,2.0000);
    [isofit]=m2_fit2d(centroids,dgrayIm,name);
    
    fileID = fopen(strcat(name,'_skyrmion_x_y_sigma_FWHM.txt'),'wt');
    fprintf(fileID,'%.2d %.2d %.2d %.2d\n',isofit(:,1:4)');
    fclose(fileID);
    
    mu=mean(isofit(:,3));
    FWHM=mu*2*(2*log(2))^0.5;
    sdev=std(isofit(:,3));
    FWHMer=sdev*2*(2*log(2))^0.5;
    meanstd(i,:)=[FWHM,FWHMer];
    
    
    
end
    fileID = fopen(('mean_values.txt'),'wt');
    fprintf(fileID,'%.2d %.2d\n',meanstd(:,1:2));
    fclose(fileID);