function genIm(full_len,len,reso,sk_FWHM, sk_sk_dist)

%reso=256;
%len=2000; %um
conv=full_len/reso; %um/px
lenpx=floor(len/conv);
fullim=zeros(reso,reso);
% sk_FWHM=140; %nm (FWHM)
% sk_sk_dist=6; %in std


c=sk_FWHM/(2*sqrt((2*log(2))));
cut_d1=2*c/conv; %at least 2 std from edge
cut_d2=lenpx-2*c/conv;

pts=genGrid([1 1 lenpx lenpx], [lenpx/2,lenpx/2], sk_sk_dist*c/conv);
px=pts(:,1);
py=pts(:,2);

py=py((px>cut_d1)&(px<cut_d2));
px=px((px>cut_d1)&(px<cut_d2));

px=px((py>cut_d1)&(py<cut_d2));
py=py((py>cut_d1)&(py<cut_d2));
%plot(pts(:,1),pts(:,2),'.')

im=zeros(lenpx,lenpx);
[xgrid,ygrid]=meshgrid(1:lenpx,1:lenpx);

for pti=1:length(px)
    imadd=exp(-((((xgrid-px(pti))/(sqrt(2)*c/conv)).^2)+(((ygrid-py(pti))/(sqrt(2)*c/conv)).^2)));
    im=max(im,imadd);
end

id_start=floor(reso/2-lenpx/2);
fullim(id_start:(id_start+lenpx-1),id_start:(id_start+lenpx-1))=im;

filename=strcat('skyrmion_',int2str(reso),'px_',int2str(sk_FWHM),'nm_',int2str(sk_sk_dist),'std_',int2str(len),'_',num2str(conv),'.png');
imwrite(fullim,filename);
imshow(fullim)
end