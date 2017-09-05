saveit=1;
Files=dir('*.*');
filFile='';
fftind=0;
% imsub=imread('crop_fil_170615_20j-F_0089.tiff');
% imsub=im2double(imsub);
% imsub_bg=imgaussfilt(imsub,20);
% imsub=imsub./imsub_bg;


for  k=1:length(Files)
%    FileNames=Files(k).name
   if ~isempty(strfind(Files(k).name,'filter'))
       filFile=Files(k).name;
       fftind=1;
   end
end
%fft bandpass filter mask
if fftind
    imMask=mat2gray(imread(filFile));
end

Files= dir(fullfile('*.tiff'));
Files= {Files.name};
%imshow(imMask);
for i=29:length(Files)
    %im=imread(strcat(dirName,'\',Files{i}));
    im=im2double(imread(Files{i}));
    
    if fftind
        imMask=imresize(imMask,size(im));
        imMask=double(imMask)/double(max(max(imMask)));
        %Gaussian blur to remove ringing effects
        imMask=imgaussfilt(imMask,2);
        imfft=fft2(im);
        %imshow(abs(imfft))
        % imfft=imfft.*imMask;
        F=(fftshift(imfft)).*imMask;
        F_show=20*log(abs(F));
        %imshow(F_show,[min(min(F_show)),max(max(F_show))])

        imfil=fftshift(ifftshift(ifft2(F)));
        imfil=abs(imfil);
    else
        imfil=im;
    end
    
    h = fspecial('disk', 2);
    imfil1=imfilter(imfil,h,'replicate');
    
    imfil2=imfil1;
    for r=1:1
    imbg=imgaussfilt(imfil2,20);
    imfil2=imfil2./(imbg).^(1/(r+1));
    [X,Y]=size(imfil2);
    [x,y]=meshgrid(1:X,1:Y);
    p=polyFit2D(x,y,imfil2,11);
    imbg=polyVal2D(x,y,p);
    imfil2=imfil2./(imbg).^(1/(r+1));

%     figure
%     subplot(2,2,1)
%     imshow(imadjust(im));
%     subplot(2,2,2)
%     imshow(imadjust(abs(imbg)));
%     subplot(2,2,3)
%     imshow(imadjust(imfil1));

    end

    
    
    figure
    subplot(2,2,1)
    imshow(imadjust(im));
    subplot(2,2,2)
    imshow(imadjust(abs(imbg)));
    subplot(2,2,3)
    imshow(imadjust(uint16((imfil1-min(min(imfil1)))*65535/(max(max(imfil1))-min(min(imfil1))))));
    subplot(2,2,4)
    imshow(imadjust(uint16((imfil2-min(min(imfil2)))*65535/(max(max(imfil2))-min(min(imfil2))))));

    if (saveit)
        t=Tiff(strcat('fil3_',Files{i}),'w');
        tagstruct.ImageLength     = size(imfil2,1);
        tagstruct.ImageWidth      = size(imfil2,2);
        tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
        tagstruct.BitsPerSample   = 16;
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
        tagstruct.Software        = 'MATLAB';

        t.setTag(tagstruct)
        t.write(uint16((imfil2-min(min(imfil2)))*65535/(max(max(imfil2))-min(min(imfil2)))));
        t.close();
        fprintf(strcat('Processing files:',Files{i},'\n'));
    end
end

