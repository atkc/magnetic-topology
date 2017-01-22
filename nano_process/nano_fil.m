filename='11f_500_400_300_200nm-4.3kOe_300Oe_3.0x3.0 (1) measure column 1 row 1.tiff';
extname='C:\Users\Anthony\Desktop\Anibal stuff\skymion size in nanodot\'; %file directory

%*************************************************************************
%*****************************Reading image file**************************
%*************************************************************************

    im=imread(strcat(extname,filename));
    %grayIm = rgb2gray(im);
    grayIm = im(:,:,1); %BGR chanels, grayIm will be based on the red intensity of the original image
    dgrayIm= double(grayIm); %matrix with double precision
    
    %resize image to 0-255 intensity, why? cos i like =D
    %dgrayIm=(dgrayIm-ones(size(dgrayIm))*min(min(dgrayIm)))*255/((max(max(dgrayIm)))-min(min(dgrayIm)));
    dgrayIm=dgrayIm*255/max(max(dgrayIm));
Dim=reshape(dgrayIm, numel(dgrayIm),1);
%histogram(Dim,100);
figure
histfit(Dim,100);
[meanI,sigmaI] = normfit(Dim,100);
maxI=meanI+2*sigmaI;
minI=meanI-2*sigmaI;
filIm=dgrayIm;
figure
imshow(filIm,[min(min(filIm)),max(max(filIm))]);
for i=1:numel(filIm)
    if (filIm(i)<minI)
    %if (filIm(i)>maxI)||(filIm(i)<minI)
        filIm(i)=uint8(minI);
    end
    
    if(filIm(i)>maxI)
        filIm(i)=uint8(maxI);
    end
end
filIm=uint8((filIm-min(min(filIm)))*255/(max(max(filIm))-min(min(filIm))));
figure
imshow(filIm,[min(min(filIm)),max(max(filIm))]);
cd('C:\Users\Anthony\Desktop\Anibal stuff\skymion size in nanodot')
imwrite(filIm,strcat('processed',filename),'png');
cd('C:\Users\Anthony\Documents\Matlab')