noise = 100/255;
test=rand(512)*noise;
l=length(test);
center=[300 280]%; 300 300; 280 290];
c=10;
a=1;

test=test+ones(length(test)).*noise;
    for i=1:length(center(:,1))
        centroid =center(i,:);
            for x= (int16(centroid(2)-4*c)):int16((centroid(2)+4*c))
                for y= (int16(centroid(1)-4*c)):int16((centroid(1)+4*c))
                    if x>0 && y>0 && x<=l && y<=l
                        d=sqrt(double((x-centroid(2))^2 + (y-centroid(1))^2));
                        if (d<(2*c))
                            n=rand()*noise;
                            f=a*exp((-(d)^2)/(2*c^2))+n;
                            if f>255
                                f=255;
                            end 
                            
                            if test(int16(x),int16(y)) < f
                                test(int16(x),int16(y))=f;
                            end
                        end
                    end
                end
            end
    end
    
    clearvars -except test