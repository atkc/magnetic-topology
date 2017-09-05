Files= dir(fullfile('*.tif'));
Files= {Files.name};
%imshow(imMask);
cropi=0;
saveit=1;
for i=27:length(Files)
    cropi=cropi+1;
    im=imread(strcat(Files{i}));
    imshow(im,[min(min(im)),max(max(im))]);
    im_crop=imcrop(im,[cropxy(cropi,1)-110,cropxy(cropi,2)-110,220,220]);
    
    
    if (saveit)
        t=Tiff(strcat('crop_',Files{i},'f'),'w');
        tagstruct.ImageLength     = size(im_crop,1);
        tagstruct.ImageWidth      = size(im_crop,2);
        tagstruct.Photometric     = Tiff.Photometric.MinIsBlack;
        tagstruct.BitsPerSample   = 16;
        tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
        tagstruct.Software        = 'MATLAB';

        t.setTag(tagstruct)
        t.write(uint16((im_crop-min(min(im_crop)))*65535/(max(max(im_crop))-min(min(im_crop)))));
        t.close();
        fprintf(strcat('Processing files:',Files{i},'\n'));
    end
end