function [x1bin,x1edge,x2bin,x2edge,ymat,ystdmat,countmat]=bin3D(x1,x2,y,n1,n2) 
if length(n1)==1
    [i_x1,edge1]=discretize(x1,n1);
    binn1=n1;
else
    i_x1=discretize(x1,n1);
    binn1=length(n1)-1;
    edge1=n1;
end

if length(n2)==1
    binn2=n2;
else
    binn2=length(n2)-1;
end
% x1bin=zeros([n1,1]);
% x1edge=zeros([n1+1,1]);
x2bin=zeros([binn1,binn2]);
x2edge=zeros([binn1,binn2+1]);
ymat=zeros([binn1,binn2]);
ystdmat=zeros([binn1,binn2]);
countmat=zeros([binn1,binn2]);
for binv1=1:n1
    x2_partial1=x2(i_x1==binv1);
    y_partial1=y(i_x1==binv1);
    
    if length(n2)==1
        [i_x2,edge2]=discretize(x2_partial1,n2);
        binn2=n2;
    else
        i_x2=discretize(x2_partial1,n2);
        binn2=length(n2)-1;
        edge2=n2;
    end
    
    for binv2=1:binn2       
        y_partial2=y_partial1(i_x2==binv2);
        y_mean=mean(y_partial2);
        y_std=std(y_partial2);
        ymat(binv1,binv2)=y_mean;
        ystdmat(binv1,binv2)=y_std;
        countmat(binv1,binv2)=length(y_partial2);
    end
    x2edge(binv1,:)=edge2;
    x2bin(binv1,:)=edge2(1:binn2)+(mean(diff(edge2))/2);
end

x1edge=edge1;
x1bin=edge1(1:n1)+(mean(diff(edge1))/2);
end