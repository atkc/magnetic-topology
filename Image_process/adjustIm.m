saveit=1;
Files=dir('*.*');
filFile='';
% imsub=imread('crop_fil_170615_20j-F_0089.tiff');
% imsub=im2double(imsub);
% imsub_bg=imgaussfilt(imsub,20);
% imsub=imsub./imsub_bg;


Files= dir(fullfile('*.tiff'));
Files= {Files.name};
%imshow(imMask);
for i=46:length(Files)
    %im=imread(strcat(dirName,'\',Files{i}));
    imfil2=im2double(imread(Files{i}));
    imfil2=imadjust(imfil2);
    imshow(imfil2);
    if (saveit)
        t=Tiff(strcat('adjust_',Files{i}),'w');
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

