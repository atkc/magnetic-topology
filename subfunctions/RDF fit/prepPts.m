

len=100;
midpt=256/2;
dgrayIm=zeros(len);
xlb=(points(:,1)>(midpt-len/2));
xhb=(points(:,1)<(midpt+len/2));
ylb=(points(:,2)>(midpt-len/2));
yhb=(points(:,2)<(midpt+len/2));

b=logical(xlb.*ylb.*xhb.*yhb);
sum(b)
point_tempx=points(b',1)-(midpt-len/2);
point_tempy=points(b',2)-(midpt-len/2);
point1=[point_tempx,point_tempy];


% coorN=(2/738)*p12((2*p12/738)>4);
% rN=histox((2*p12/738)>4);
% for i=1:length(rN)
%     if coorN(i)<=6
%         coorN(i)=6;
%     elseif coorN(i)<=12
%         coorN(i)=12;
%     else
%         coorN(i)=18;
%     end
%     
% end