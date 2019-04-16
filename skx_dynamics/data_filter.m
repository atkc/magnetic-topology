function [vsk_hold,theta_hold2,sksize_hold,p_no_hold] = data_filter(r_cor,theta_cor,sksize,p_no,fil_para)
%Speed analysis using fullstat2 velocity (position identified via user,
%hence not fitted)

sel_p=fil_para.sel_p;
vcutoff=fil_para.vcutoff;
vpct1=fil_para.vpct1;
vpct2=fil_para.vpct2;
dsk1=fil_para.dsk1 ;
dsk2=fil_para.dsk2;
HAoffset=fil_para.HAoffset;
HA1=fil_para.HA1;
HA2=fil_para.HA2;
proj=fil_para.proj;
HApct1=fil_para.HApct1;
HApct2=fil_para.HApct2;
%pulse
p_para=ismember(p_no,sel_p);
vsk_hold=r_cor(p_para);
sksize_hold=sksize(p_para);
theta_hold1=theta_cor(p_para)*180/pi;
p_no_hold=p_no(p_para);

%sksize
sksize_para=logical((sksize_hold>dsk1).*(sksize_hold<dsk2));
vsk_hold=vsk_hold(sksize_para);
sksize_hold=sksize_hold(sksize_para);
theta_hold1=theta_hold1(sksize_para);
p_no_hold=p_no_hold(sksize_para);
%Vsk
vsk_para1=logical(vsk_hold>vcutoff);
vsk_hold=vsk_hold(vsk_para1);
sksize_hold=sksize_hold(vsk_para1);
theta_hold1=theta_hold1(vsk_para1);
p_no_hold=p_no_hold(vsk_para1);

vsk_para2=logical((vsk_hold>prctile(vsk_hold,vpct1)).*(vsk_hold<prctile(vsk_hold,vpct2)));
vsk_hold=vsk_hold(vsk_para2);
sksize_hold=sksize_hold(vsk_para2);
theta_hold1=theta_hold1(vsk_para2);
p_no_hold=p_no_hold(vsk_para2);

%HA
theta_hold2=theta_hold1-HAoffset;
theta_hold2=wrapTo180(theta_hold2);
if proj==2
    theta_hold2=theta_hold2+(theta_hold2<-90)*180;
    theta_hold2=theta_hold2-(theta_hold2>90)*180;
    theta_hold2=abs(theta_hold2);
elseif proj==1
    theta_hold2=theta_hold2+(theta_hold2<-90)*180;
    theta_hold2=theta_hold2-(theta_hold2>90)*180;
end

if logical(isnan(HA1).*isnan(HA2))
    HA1=prctile(theta_hold2,HApct1);
    HA2=prctile(theta_hold2,HApct2);
end
HA_para=logical((theta_hold2>HA1).*(theta_hold2<HA2));
vsk_hold=vsk_hold(HA_para);
sksize_hold=sksize_hold(HA_para);
theta_hold2=theta_hold2(HA_para)+HAoffset;
p_no_hold=p_no_hold(HA_para);
end

