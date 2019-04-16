function [p ] = Peri_noob( gg,siz )
%PERI_NOOB Summary of this function goes here
%   Detailed explanation goes here

no_grains= length(gg.PixelIdxList);
p=zeros(1,no_grains);
for i = 1: no_grains
    ind=gg.PixelIdxList{i};
    [x,y]=ind2sub(siz,ind);
    p(i)=4*length(x);
    for ii = 1: length(x)
%         if ((x==siz(1))||(x==0))
%             p=p-1;
%         end
%         
%         if ((y==siz(2))||(y==0))
%             p=p-1;
%         end
        
        x1=x(ii)+1;
        x2=x(ii)-1;
        y1=y(ii)+1;
        y2=y(ii)-1;
        if ismember([x(ii),y1],[x,y],'rows')
            p(i)=p(i)-1;
        end
        if ismember([x(ii),y2],[x,y],'rows')
            p(i)=p(i)-1;
        end
        if ismember([x1,y(ii)],[x,y],'rows')
            p(i)=p(i)-1;
        end
        if ismember([x2,y(ii)],[x,y],'rows')
            p(i)=p(i)-1;
        end
    end
end



end

