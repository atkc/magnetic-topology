
% fileInput=false;
% if fileInput
%     
%     filename='C:\Users\Anthony\Documents\MATLAB\fit_skyrmion\constructed lattice\white.png'; %file directory
%     im=imread(filename);
%     [py, px] = find(im == 0);
%     isofit(:,1)=px;
%     isofit(:,2)=py;
% end

points=isofit(:,1:2);
%%*******************************************
%%determine D-trianglation of set of vertices
%%*******************************************
dt=delaunayTriangulation(isofit(:,1),isofit(:,2));
[m,~]=size(dt);
vect=zeros(m*3,2);
thetaRho=zeros(m*3,2);
for i=1:m
    v1=points(dt(i,1),:)-points(dt(i,2),:);
    v2=points(dt(i,2),:)-points(dt(i,3),:);
    v3=points(dt(i,3),:)-points(dt(i,1),:);
    
    vect((i-1)*3+1,:)=v1;
    vect((i-1)*3+2,:)=v2;
    vect((i-1)*3+3,:)=v3;
    
end
figure
plot(vect(:,1),vect(:,2),'.r','MarkerSize',10)
hold on
plot(-vect(:,1),-vect(:,2),'.r','MarkerSize',10)
axis equal
