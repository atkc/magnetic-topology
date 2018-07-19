t_col_list=zeros(1000,3);
i=1;
for imageInd = [1]%[2 3 6 7 10 11 14 15]%2:noOfimages

fullFileName=strcat('test (',int2str(imageInd),')','.png');
im=imread(fullFileName);
col_list=getCol_v2(im);
t_col_list(i:(i-1+length(col_list)),:)=col_list;
i=i+length(col_list);
display(int2str(imageInd));
end
t_col_list=t_col_list(1:i-1,:);

