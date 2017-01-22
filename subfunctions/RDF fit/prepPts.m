%points=isofit(:,1:2);

len=120;
imagelen=512;

dgrayIm=zeros(len);

numImage=4;
if imagelen>2*len
    xmidpt=[imagelen/2+len/2,imagelen/2+len/2,imagelen/2-len/2,imagelen/2-len/2];
    ymidpt=[imagelen/2+len/2,imagelen/2-len/2,imagelen/2+len/2,imagelen/2-len/2];
elseif imagelen>len
    xmidpt=[len/2,len/2,imagelen-len/2,imagelen-len/2];
    ymidpt=[len/2,imagelen-len/2,len/2,imagelen-len/2];
else
    xmidpt=[imagelen/2,0,0,0];
    ymidpt=[imagelen/2,0,0,0];
    numImage=1;
end
point1=[];
point2=[];
point3=[];
point4=[];

Npoint=zeros(1,numImage);
for i=1:numImage
    midptx=xmidpt(i);
    midpty=ymidpt(i);
    xlb=(points(:,1)>(midptx-len/2));
    xhb=(points(:,1)<(midptx+len/2));
    ylb=(points(:,2)>(midpty-len/2));
    yhb=(points(:,2)<(midpty+len/2));

    b=logical(xlb.*ylb.*xhb.*yhb);
    Npoint(i)=sum(b);
    point_tempx=points(b',1)-(midptx-len/2);
    point_tempy=points(b',2)-(midpty-len/2);
    if isempty(point1)
        point1=[point_tempx,point_tempy];
    elseif isempty(point2)
        point2=[point_tempx,point_tempy];
    elseif isempty(point3)
        point3=[point_tempx,point_tempy];
    else 
        point4=[point_tempx,point_tempy];
    end
                            

    clear point_tempx point_tempy b xlb xhb ylb yhb
end
Npoint
clear i imagelen len xmidpt ymidpt midptx midpty 