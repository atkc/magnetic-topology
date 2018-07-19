pulse_start=16;
fileList = dir('*.png');
fileList={fileList.name};

for file_i=1:length(fileList)
    filename1=fileList{file_i};
    no= str2double(regexp(filename1, '\d+', 'match', 'once'))
    filename2=strcat('pulse (',num2str(pulse_start+no-1),').png');
    disp(strcat(filename1,'-->',filename2))
    movefile(filename1,filename2);
end
