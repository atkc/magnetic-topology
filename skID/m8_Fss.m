points=isofit(:,1:2);
n=length(points);

ForceMap=zeros(n,2); %Fx Fy
PinMap=zeros(n,2);
pcb=false;
imReso=256;
imSize=5*10^-6;%m

J=12*10^-12; %Exchange interaction (J/m)
D=1.65*10^-3; %Dzyaloshinskki Moriya interaction strength (J/m^2)
d=70*10^-9; %thickness of film (m)

Ha=(900*10^3/(4*pi));%/(D^2/J); (A/m)

B=2*Ha*J/D^2;
eee=sqrt(2/B);
ee=(D/sqrt(Ha*J));
rr=zeros(1,1000000);
rri=1;
for pointA=1:(length(points)-1)%round(length(points)/2):(round(length(points)/2)+10)
    for pointB=pointA+1:length(points)
        dr = points(pointA,:) - points(pointB,:);
        if pcb
            dr = distPBC2D(dr,imReso,imReso);
        end
        r = sqrt(sum(dot(dr,dr))); %distance
        rv=dr/r; %normalized vector pointing from B to A
        
        rd=(r*(imSize/imReso))/(J/D);
        rr(rri)=rd;
        rri=rri+1;
        Fss=(J/d)*besselk(1,(rd/ee));
        ForceMap(pointA,:)=ForceMap(pointA,:)+rv*Fss;
        ForceMap(pointB,:)=ForceMap(pointB,:)-rv*Fss;
        PinMap(pointA,:)=PinMap(pointA,:)-rv*Fss;
        PinMap(pointB,:)=PinMap(pointB,:)+rv*Fss;
    end
end
rr=rr(1:rri-1);

% figure
% quiver(points(:,1),points(:,2),ForceMap(:,1),ForceMap(:,2))
% hold on
% plot(points(:,1),points(:,2),'o')
% axis equal
% 
figure
quiver(points(:,1),points(:,2),PinMap(:,1),PinMap(:,2))
hold on
plot(points(:,1),points(:,2),'o')
axis equal

ForceInt=sqrt(ForceMap(:,1).^2+ForceMap(:,2).^2);
F = scatteredInterpolant(points(:,1),points(:,2),ForceInt);
[Xq,Yq] = meshgrid(1:0.25:imReso);
Vq=F(Xq,Yq);
figure
pcolor(Xq*imSize/imReso,Yq*imSize/imReso,Vq);
shading flat
%mesh(Xq*imSize/imReso,Yq*imSize/imReso,Vq);
axis equal
c=colorbar;
c.Label.String = '| Pinning Force (N/m) |';
% hold on
% quiver(points(:,1)*imSize/imReso,points(:,2)*imSize/imReso,PinMap(:,1),PinMap(:,2))
hold on
plot(points(:,1)*imSize/imReso,points(:,2)*imSize/imReso,'ro')
xlabel('Length (m)');
ylabel('Length (m)');
caxis([0 9.1118e-17]);

% J=10;
% fx=(3:11);
% D=(fx.^-1)*J;
% Ha=0.45;
% ee=sqrt(D/sqrt(Ha*J));
% fy=besselk(1,fx./ee);
% figure
% plot(fx,log(fy));
imwrite(Vq/(max(max(Vq))-min(min(Vq))),'pin_map_2.png','png');