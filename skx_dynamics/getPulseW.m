
maxj=max(dat2(:));
minj=min(dat2(:));
vprobe=0.85*maxj;
i1=min(find(dat2>vprobe));
i2=max(find(dat2>vprobe));
%plot(dat(:,1),dat2(:,1))
hold on
plot(dat(i1:i2,1),vprobe*ones(size(i1:i2)));
w=sum(dat2>vprobe)*mean(diff(dat(:,1)))