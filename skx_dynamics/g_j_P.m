%%*****Different pulse*****
pID=unique(fullstat2(:,2));
minDist=1080/256;
[fullstat2_fil,r_cor_fil,theta_cor_fil]=minDist_filter(fullstat2,r_cor,theta_cor,minDist);
%population graph
total_sk=max(fullstat2(:,8));
p=zeros(length(pID),4);
%1. P(#):population in motion
%2. P(%)
%3. P||(#):population in parallel motion to J
%4. P||(% of P)
for p_i=1:length(pID)
    p(p_i,1)=sum(fullstat2_fil(:,2)==pID(p_i));
    p(p_i,2)=p(p_i,1)/total_sk;
    p(p_i,3)=sum(abs(theta_cor_fil(fullstat2_fil(:,2)==pID(p_i)))<(pi/2));
    p(p_i,4)=p(p_i,3)/p(p_i,1);
end
figure;
plot(abs(i1),p(:,4),'r*');
figure;
plot(abs(i1),p(:,1),'r*');
hold on;
plot(abs(i1),p(:,3),'go');

%%
%%*****Different current densities*****
pID=unique(fullstat2(:,2));
j_uni=unique(abs(i1));

minDist=1080/256;
[fullstat2_fil,r_cor_fil,theta_cor_fil]=minDist_filter(fullstat2,r_cor,theta_cor,minDist);
%population graph
total_sk=max(fullstat2(:,8));
p2=zeros(length(j_uni),4);
%1. P(#):population in motion
%2. P(%)
%3. P||(#):population in parallel motion to J
%4. P||(% of P)
for j_i=1:length(j_uni)   
    p_i=pID(abs(i1)==j_uni(j_i));    
    p2(j_i,1)=sum(ismember(fullstat2_fil(:,2),p_i))/length(p_i);%needs to normalized by number of pulses
    p2(j_i,2)=p2(j_i,1)/total_sk;
    p2(j_i,3)=sum(abs(theta_cor_fil(ismember(fullstat2_fil(:,2),p_i)))<(pi/2))/length(p_i);
    p2(j_i,4)=p2(j_i,3)/p2(j_i,1);
end

figure;
plot(j_uni,p2(:,4),'r*');
figure;
plot(j_uni,p2(:,1),'r*');
hold on;
plot(j_uni,p2(:,3),'go');