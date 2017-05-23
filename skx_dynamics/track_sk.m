holdi=zeros(200,1);
asd=fullstat2(:,8);
for i=1:200
    holdi(i)=sum(asd==i);
    [c,skno]=max(holdi);
end

filename='170421_15k_1b_2um_d2_n4k-p1100_p (';
abcd=c;
for imageInd = 1:28%[2 3 6 7 10 11 14 15]%2:noOfimages

    fprintf('Printing image %i\n',imageInd);
    fullFileName=strcat(filename,int2str(imageInd),')','.png');
    im=imread(fullFileName);

    sID=[MasterList(:,imageInd+1,1)];
    px=[MasterList(:,imageInd+1,2)];
    py=[MasterList(:,imageInd+1,3)];
    x=px(sID==abcd);
    y=py(sID==abcd);
    RGB = insertShape(im,'circle',[x y 6],'LineWidth',2,'Color','red');
    %figure
    %imshow(RGB);
    imwrite(RGB,strcat('sk-',num2str(abcd),filename,int2str(imageInd),')','.png'));
end
[m,n]=size(fullstat2);
fullstat3=zeros(m,n+1);
fullstat3(:,1:n)=fullstat2;
for i=1:length(fullstat2)
    fullstat3(i,end)=sksz(fullstat2(i,end));
end