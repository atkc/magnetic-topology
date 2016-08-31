gR=struct;
NumOfBins=500;
gR = radialDistribution2D(0,gR,points',Lx,Ly,NumOfBins);
gR = radialDistribution2D(1,gR,points',Lx,Ly,NumOfBins);
gR = radialDistribution2D(2,gR,points',Lx,Ly,NumOfBins);
gR = radialDistribution2D(3,gR,points',Lx,Ly,NumOfBins);

x=gR.values;
y=gR.histo;

bar(x(1:length(x)/4),y(1:length(y)/4))
