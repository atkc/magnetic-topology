function [ mask ] = Gfun2D_aniso(s,xi,yi,sigma1,sigma2,theta, noise,a)
theta=theta*pi/180;
mask= zeros(s); %(rows,cols)

for x= 1:s(2)%cols
    for y= 1:s(1) %rows
        d1=(double(x)-xi)*cos(theta)-(double(y)-yi)*sin(theta);
        d2=(double(x)-xi)*sin(theta)+(double(y)-yi)*cos(theta);
        
        f=(a-noise)*(exp(((-(d1)^2)/(2*sigma1^2))+((-(d2)^2)/(2*sigma2^2))))+noise;
        mask(int16(y),int16(x))=f;%rows,cols = y x
    end
end

