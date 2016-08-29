nAmp1=50;
nAmp2=50;
noise1 = nAmp1/255;
noise2 = (rand(512)*nAmp2/255)-nAmp2/(2*255);


center=[310 100; 310 140;310 180;310 220; 310 260;...
    280 120;280 160;280 200;280 240; 280 280;...
    250 100; 250 140;250 180;250 220; 250 260];
gSD=13;
gAmp=(255-nAmp1-nAmp2)/255;
gSize=10*gSD;
test=zeros(512);
l=length(test);
    for i=1:length(center(:,1))
        centroid =center(i,:);
            for x= (int16(centroid(2)-gSize)):int16((centroid(2)+gSize))
                for y= (int16(centroid(1)-gSize)):int16((centroid(1)+gSize))
                    if x>0 && y>0 && x<=l && y<=l
                        d=sqrt(double((x-centroid(2))^2 + (y-centroid(1))^2));
                        if (d<(gSize))                           
                            f=gAmp*exp((-(d)^2)/(2*gSD^2));
                            test(int16(x),int16(y))=f+test(int16(x),int16(y));
                        end
                    end
                end
            end
    end
    testIm=ones(512)*noise1+noise2+test;
    clearvars -except testIm