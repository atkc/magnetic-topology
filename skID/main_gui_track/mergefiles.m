function [ output_args ] = mergefiles( totalno )
%MERGEFILES Summary of this function goes here
%   Detailed explanation goes here
r=[]
theta=[]
fs=[]
i2=[]
for f_i=1:totalno
    fullstat2=[];
    r_cor=[];
    theta_cor=[];
    load(strcat('r_cor-',num2str(f_i),'.mat'));
    load(strcat('theta_cor-',num2str(f_i),'.mat'));
    load(strcat('fullstat2-',num2str(f_i),'.mat'));
    load(strcat('i1-',num2str(f_i),'.mat'));
    r=[r,r_cor];
    theta=[theta,theta_cor];
    fs=[fs;fullstat2];
    i2=[i2;i1];
end
r_cor=r;
theta_cor=theta;
fullstat2=fs;
i1=i2;
save(strcat('r_cor-','combine','.mat'),'r_cor');
save(strcat('theta_cor-','combine','.mat'),'theta_cor');
save(strcat('fullstat2-','combine','.mat'),'fullstat2');
save(strcat('i1-','combine','.mat'),'i1');

end

