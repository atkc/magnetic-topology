points=isofit(:,1:2);
n=length(points);

ForceMap=zeros(n,2); %Fx Fy
PinMap=zeros(n,2);
pcb=false;
imReso=1024;
imSize=5*10^-6;%m

J=12*10^-12;
D=1.85*10^-3;

Ha=(1600*10^3/(4*pi));%/(D^2/J);

B=2*Ha*J/D^2;
eee=sqrt(2/B);
ee=(D/sqrt(Ha*J));

for pointA=1:(length(points)-1)%round(length(points)/2):(round(length(points)/2)+10)
    for pointB=pointA+1:length(points)
        dr = points(pointA,:) - points(pointB,:);
        if pcb
            dr = distPBC2D(dr,imReso,imReso);
        end
        r = sqrt(sum(dot(dr,dr))); %distance
        rv=dr/r; %normalized vector pointing from B to A
        
        rd=(r*(imSize/imReso))/(J/D);
        Fss=besselk(1,(rd/ee));
        ForceMap(pointA,:)=ForceMap(pointA,:)+rv*Fss;
        ForceMap(pointB,:)=ForceMap(pointB,:)-rv*Fss;
        PinMap(pointA,:)=PinMap(pointA,:)-rv*Fss;
        PinMap(pointB,:)=PinMap(pointB,:)+rv*Fss;
    end
end
figure
quiver(points(:,1),points(:,2),ForceMap(:,1),ForceMap(:,2))
hold on
plot(points(:,1),points(:,2),'o')
axis equal

figure
quiver(points(:,1),points(:,2),PinMap(:,1),PinMap(:,2))
hold on
plot(points(:,1),points(:,2),'o')
axis equal
% J=10;
% fx=(3:11);
% D=(fx.^-1)*J;
% Ha=0.45;
% ee=sqrt(D/sqrt(Ha*J));
% fy=besselk(1,fx./ee);
% figure
% plot(fx,log(fy));