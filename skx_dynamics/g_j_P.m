pID=[17:21];%unique(fullstat2(:,2));
%population graph
total_sk=max(fullstat2(:,8));
p=zeros(length(pID),4);
%1. P(#):population in motion
%2. P(%)
%3. P||(#):population in parallel motion to J
%4. P||(% of P)
for i=1:length(pID)
    p(i,1)=sum(fullstat2(:,2)==pID(i));
    p(i,2)=p(i,1)/total_sk;
    p(i,3)=sum(abs(theta_cor(fullstat2(:,2)==pID(i)))<(pi/2));
    p(i,4)=p(i,3)/p(i,1);
end
figure;
plot(abs(i1),p(:,4),'r*');
figure;
plot(abs(i1),p(:,1),'r*');
hold on;
plot(abs(i1),p(:,3),'go');