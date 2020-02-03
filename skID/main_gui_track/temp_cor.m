clear
load('fullstat2.mat')
load('theta_cor.mat')
load('r_cor.mat')
load('MasterList.mat')
reso=4000/512;

frame_ini=reshape(MasterList(:,1,:),[300,4]);
size_ini=frame_ini(1,4)*2*reso;

sk_size=fullstat2(:,9)*2*reso;
cutoff=0.15;
s1=size_ini-size_ini*cutoff;
s2=size_ini+size_ini*cutoff;

theta1=180-180*theta_cor/pi;
theta1(theta1>180)=theta1(theta1>180)-360;

%plot(theta1)
ind2=logical((sk_size<=s2).*(sk_size>=s1));
theta2=theta1(ind2);
v2=r_cor(ind2)*512/(4000e-9);
sk_size2=sk_size(ind2);

frame_last=reshape(MasterList(:,sum(ind2)+1,:),[300,4]);
X1=frame_ini(1,2:3);
X2=frame_last(1,2:3);
% X1=fullstat2(1,6:7);
% X2=fullstat2(sum(ind4),6:7);

dx=X2(1)-X1(1);
dy=X2(2)-X1(2);
[ftheta,frho] = cart2pol(-dy,-dx);
ftheta=180-180*ftheta/pi;
ftheta(ftheta>180)=ftheta(ftheta>180)-360;
%plot(s2k_size2)
m_size=mean(sk_size);
m_size2=mean(sk_size2);
m_theta1=mean(theta1);
m_theta2=mean(theta2);
m_r=mean(v2);
f_rho=frho/length(v2);
[m_size,m_size2,size_ini,m_r,f_rho,m_theta1,m_theta2,ftheta]

%**************************************************%

clear
load('fullstat2.mat')
load('theta_cor.mat')
load('r_cor.mat')
load('MasterList.mat')
reso=4000/512;

sk_size=fullstat2(:,9)*2*reso;
frame_ini=reshape(MasterList(:,1,:),[300,4]);
size_ini=frame_ini(1,4)*2*reso;

cutoff=0.15;
s1=size_ini-size_ini*cutoff;
s2=size_ini+size_ini*cutoff;

theta1=180-180*theta_cor/pi;
theta1(theta1>180)=theta1(theta1>180)-360;

%plot(theta1)
ind2=logical((sk_size<=s2).*(sk_size>=s1));
ind3=logical((theta1<=90).*(theta1>=-90));
ind4=logical(ind2'.*ind3);

theta2=theta1(ind4);
v2=r_cor(ind4)*512/(4000e-9);
sk_size2=sk_size(ind4);

frame_last=reshape(MasterList(:,sum(ind4)+1,:),[300,4]);
X1=frame_ini(1,2:3);
X2=frame_last(1,2:3);
% X1=fullstat2(1,6:7);
% X2=fullstat2(sum(ind4),6:7);

dx=X2(1)-X1(1);
dy=X2(2)-X1(2);
[ftheta,frho] = cart2pol(-dy,-dx);
ftheta=180-180*ftheta/pi;
ftheta(ftheta>180)=ftheta(ftheta>180)-360;
%plot(s2k_size2)
m_size=mean(sk_size);
m_size2=mean(sk_size2);
m_theta1=mean(theta1);
m_theta2=mean(theta2);
m_r=mean(v2);
f_rho=frho/length(v2);
normtheta=sum(theta2.*v2)/sum(v2);
[m_size,m_size2,size_ini,m_r,f_rho,m_theta1,m_theta2,ftheta,normtheta]
