holdi=zeros(200,1);
asd=fullstat2(:,8);
for i=1:200
    holdi(i)=sum(asd==i);
    [c,skno]=max(holdi);
end

filename='pulse (';
id_track_list=43;%sort(round((rand(20,1)*194)));
for ijk=1:length(id_track_list)
    id_track=id_track_list(ijk);
for imageInd = 3:4%[2 3 6 7 10 11 14 15]%2:noOfimages

    fprintf('Printing image %i\n',imageInd);
    fullFileName=strcat(filename,int2str(imageInd),')','.png');
    im=imread(fullFileName);

    sID=[MasterList(:,imageInd,1)];
    px=[MasterList(:,imageInd,2)];
    py=[MasterList(:,imageInd,3)];
    x=px(sID==id_track);
    y=py(sID==id_track);
    RGB = insertShape(im,'circle',[x y 6],'LineWidth',2,'Color','red');
%     figure
%     imshow(RGB);
    imwrite(RGB,strcat('sk-',num2str(id_track),filename,int2str(imageInd),')','.png'));
end
[m,n]=size(fullstat2);
fullstat3=zeros(m,n+1);
fullstat3(:,1:n)=fullstat2;
end
% for i=1:length(fullstat2)
%     fullstat3(i,end)=sksz(fullstat2(i,end));
% end