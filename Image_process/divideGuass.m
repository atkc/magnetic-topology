dirName= 'C:\Users\Anthony\Dropbox\Shared_MFM\1706_MTXM-Data\Processed images\170615_20j-HSwp-nHs';
files= dir(fullfile(dirName,'*.tif'));
files={files.name};
saveit=true;
for i=1:length(files)
    im=imread(strcat(dirName,'\',files{i}));
    imbg = imgaussfilt(im,30);

    imfil1=im./imbg;
%     imfil2=im-imbg;    
%     figure
%     imshow(im,[min(min(im)),max(max(im))]);
%     figure
%     imshow(imfil1,[min(min(imfil1)),max(max(imfil1))]);
%     figure
%     imshow(imfil2,[min(min(imfil2)),max(max(imfil2))]);
    
    %imwrite(imfil1,strcat(dirName,'\fil_',files{i},'f'));%cant savee 32
    %bit as Tiff using this method
    if (saveit)
        t=Tiff(strcat(dirName,'\fil_',files{i},'f'),'w');
        tagstruct.ImageLength     = size(imfil1,1);
        tagstruct.ImageWidth      = size(imfil1,2);
        tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
        tagstruct.BitsPerSample   = 16;
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
        tagstruct.Software        = 'MATLAB';

        t.setTag(tagstruct)
        t.write(uint16((imfil1-min(min(imfil1)))*65535/(max(max(imfil1))-min(min(imfil1)))));
        t.close();
        fprintf(strcat('Processing files:',files{i},'\n'));
    end
end

fprintf('Completed\n');