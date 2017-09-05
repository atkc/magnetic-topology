
spacing =0.05
[xq,yq]=meshgrid(0:spacing:1);
zf_hr_q=0:spacing:1;
zf_sigma_q=interp1(zf_hr,zf_sigma,zf_hr_q');

if_h_q=0:spacing:1;
if_sigma_q=interp1(if_h,if_sigma,if_h_q');

h=[zeros(length(zf_hr_q),1);if_h_q'];
hr=[zf_hr_q';if_h_q'];
sigma_h=[zf_sigma_q;if_sigma_q];
F = scatteredInterpolant(h,hr,sigma_h);
sig_int=F(xq,yq);
surf(xq,yq,sig_int.*(xq<=yq));

