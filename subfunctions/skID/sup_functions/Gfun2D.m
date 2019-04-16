function mask = Gfun2D(s,xi,yi,c,noise,a)

mask= zeros(s); %(rows,cols)
centroid =[xi yi];


for x= 1:s(2)%cols
    for y= 1:s(1) %rows
        d=sqrt(double(x-centroid(1))^2 + double(y-centroid(2))^2);
        f=(a-noise)*exp((-(d)^2)/(2*c^2))+noise;
        mask(int16(y),int16(x))=f;%rows,cols = y x
    end
end

