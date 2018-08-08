function [ ML,l2 ] = cleanML( MasterList)
%CLEANML Summary of this function goes here
%   Detailed explanation goes here
ML=zeros(size(MasterList));
[l1,~,~]=size(MasterList);

del_sk=zeros(l1,1)==0;
for sk_j=1:l1
    del_sk(sk_j)=~any(MasterList(sk_j,:,2));
end

MasterList(del_sk,:,:)=[];
[l2,~,~]=size(MasterList);

p_no=find(any(MasterList(:,:,2)));

for p_no_i=1:length(p_no)
    MasterList(:,p_no(p_no_i),1)=1:l2;
end

ML(1:l2,:,:)=MasterList;

end

