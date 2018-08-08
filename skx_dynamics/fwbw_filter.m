function [ index ] = fwbw_filter(i_a,fs,op)
%FWBW_FILTER Summary of this function goes here
%   Detailed explanation goes here
pID=unique(fs(:,2));
p_negi=pID(i_a<0);
p_posi=pID(i_a>0);
index=zeros(size(fs(:,2)));
if op==1 %negative current
    for p=p_negi'
        index=(index+(fs(:,2)==p));

    end
elseif op==2%positive current
    for p=p_posi' 
        index=(index+(fs(:,2)==p));

    end
else
    index=ones(size(fs(:,2)));
end

index=index>0;

end

