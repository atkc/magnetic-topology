%%Select Image File
[filename, pathname] = ...
     uigetfile({'*.tiff;*.jpg;*.png;*.csv','Image Files(*.tiff,*.jpg,*.png,*.csv)'},'Select an Image');

%pathname='C:\Users\Anthony\Desktop\test images\'
%filename='11f2k2.tiff'; %file directory 
 
[~,~,ext] = fileparts(filename);

info = imfinfo(strcat(pathname,filename));

if strcmp(ext,'.csv')
    image=csvread(strcat(pathname,filename));
else
    Im=imread(strcat(pathname,filename));
    
    if strcmp(info.ColorType,'grayscale')
        image =double(Im);
    else
        image=rgb2gray(Im);
    end
end

%%Specify Size of Image
sizePrompt = {'Enter image size:'};
dlg_title = 'Size of Image (um)';
num_lines = 1;
defaultans = {'5'};
imSize = inputdlg(sizePrompt,dlg_title,num_lines,defaultans);
imSize= str2double(imSize{1});


%%Select Threshold type
thresholdChoice= questdlg('Select type of threshold','Threshold Choice','Static','Dynamic','Static');

switch thresholdChoice
    case 'Static'
        threshmode=1;
    case 'Dynamic'
        threshmode=2;
end


clearvars -except image pathname filename threshmode imSize

threshlevel=threshUI(image);

gg=1;