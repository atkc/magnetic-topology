gR=struct;
NumOfBins=1000;
Lx=1024;
Ly=1024;
gR = radialDistribution2D(0,gR,points',Lx,Ly,NumOfBins);
gR = radialDistribution2D(1,gR,points',Lx,Ly,NumOfBins);
gR = radialDistribution2D(2,gR,points',Lx,Ly,NumOfBins);
figure
gR = radialDistribution2D(3,gR,points',Lx,Ly,NumOfBins);

x=gR.values;
y=gR.histo;

bar(x(1:length(x)/4),y(1:length(y)/4))
