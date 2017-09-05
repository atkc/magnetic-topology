function [ rim ] = average_rec( rawim, xy )
%AVERAGE_REC Summary of this function goes here
%   Detailed explanation goes here
x=xy(:,1);
y=xy(:,2);

while (~isempty(x))
    imtemp=zeros(length(rawim));

    for i = 1:length(x)
        imtemp(y(i),x(i))=1;
    end

    [fx,fy]=find(bwperim(imtemp));


    for i = 1:length(fx)
        totals=0;
        sumz=int64(0);
        if ((sum(y == (fx(i)+1) & x == (fy(i))))==0)
            totals=totals+1;
            rawim(fx(i)+1,fy(i))
            sumz=sumz+int64(rawim(fx(i)+1,fy(i)));
        end
        if ((sum(y == (fx(i)-1) & x == (fy(i))))==0)
            totals=totals+1;
            rawim(fx(i)-1,fy(i))
            sumz=sumz+int64(rawim(fx(i)-1,fy(i)));
        end
        if ((sum(y == (fx(i)) & x == (fy(i)+1)))==0)
            totals=totals+1;
            rawim(fx(i),fy(i)+1)
            sumz=sumz+int64(rawim(fx(i),fy(i)+1));
        end
        if ((sum(y == (fx(i)) & x == (fy(i)-1)))==0)
            totals=totals+1;
            rawim(fx(i),fy(i)-1)
            sumz=sumz+int64(rawim(fx(i),fy(i)-1));
        end
        avg_sum=(sumz/int64(totals))
        avg_sum_16=uint16(avg_sum)
        rawim(fx(i),fy(i))=(avg_sum_16);
    end
    C = setdiff([y,x],[fx,fy],'rows');
    y=C(:,1);
    x=C(:,2);
    length(x);
    
end

rim=rawim;
end

