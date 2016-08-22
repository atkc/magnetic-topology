nAmp1=50;
nAmp2=0;
noise1 = nAmp1/255;
noise2 = (rand(512)*nAmp2/255)-nAmp2/(2*255);


center=[320 100; 320 140;320 180;320 220; 320 260;280 120; 280 160;280 200;280 240; 280 280];
gSD=10;
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