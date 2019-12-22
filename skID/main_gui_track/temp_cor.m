clear
load('fullstat2.mat')
load('theta_cor.mat')
load('r_cor.mat')
reso=4000/512;

sk_size=fullstat2(:,9)*2*reso;
size_ini=sk_size(1);
cutoff=0.15;
s1=size_ini-size_ini*cutoff;
s2=size_ini+size_ini*cutoff;

theta1=180-180*theta_cor/pi;
theta1(theta1>180)=theta1(theta1>180)-360;

%plot(theta1)
ind2=logical((sk_size<=s2).*(sk_size>=s1));
theta2=theta1(ind2);
v2=r_cor*512/(4000e-9);
sk_size2=sk_size(ind2);

X1=fullstat2(1,6:7);
X2=fullstat2(sum(ind2),6:7);
dx=X2(1)-X1(1);
dy=X2(2)-X1(2);
[ftheta,frho] = cart2pol(-dy,-dx);
ftheta=180-180*ftheta/pi;
ftheta(ftheta>180)=ftheta(ftheta>180)-360;
%plot(s2k_size2)

m_size=mean(sk_size2);
m_theta1=mean(theta1);
m_theta2=mean(theta2);
m_r=mean(v2);

[m_theta1,m_theta2,ftheta]