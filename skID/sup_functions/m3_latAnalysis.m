
fileInput=false;
if fileInput
    clear
    filename='C:\Users\Anthony\Documents\MATLAB\magnetic_topology\reconstruct_lattice_40.png'; %file directory
    dgrayIm=imread(filename);
    [py, px] = find(dgrayIm == 0);
    isofit(:,1)=px;
    isofit(:,2)=py;
end
% isofit=centroids;

%%*******************************************
%%determine D-trianglation of set of vertices
%%*******************************************
dt=delaunayTriangulation(isofit(:,1),isofit(:,2));

%%*******************************************
%%pair-wise distance to frequency plot
%%*******************************************
distance=pdist([isofit(:,1),isofit(:,2)]);%%calculation of pair wise distance
%distance=round(distance);
f1=figure; %%overview of plot
h = histogram(distance,1000);
xlabel('Distance (pixel)')
ylabel('Frequency (#)')

f2=figure; %%close up of plot

dindex1=(distance>0);
dindex2=(distance<100);
dindex=dindex1 & dindex2;
d3=distance(dindex);
hh = histogram(d3,50);
xlabel('Distance (pixel)')
ylabel('Frequency (#)')

%%*******************************************
%%D-triangulation plot
%%*******************************************
f3=figure;
triplot(dt);
for i = 1:length(isofit)
        hold on
        plot(isofit(i,1),isofit(i,2),'r.','MarkerSize',10);
end

%%*******************************************
%%NN plot (fold# statistics)
%%*******************************************
foldStat=zeros(length(dt.Points),1);

for i=1:length(dt.Points)
    foldStat(i) = length(cell2mat(vertexAttachments(dt,i)));
end
f4=figure;
hhh =histogram(foldStat);
xlabel('# of neighbours ')
ylabel('Frequency (#)')

%%*******************************************
%%Angle statistics
%%*******************************************
vertices=[dt.Points];
trigID=[dt.ConnectivityList];
anglestat=zeros(length(trigID),3);
for i=1:length(trigID)
  v1=vertices(trigID(i,1),:);
  v2=vertices(trigID(i,2),:);
  v3=vertices(trigID(i,3),:);
  anglestat(i,:)=TRIangles([v1;v2;v3]);
end

f5=figure;
histogram(anglestat(:));
xlabel('Angle in Degrees');
ylabel('Frequency (#)');

%%*******************************************
%%Radial Distribution Function
%%*******************************************
%downloaded file
%test_RDF
%self written RDF
points=isofit(:,1:2);
prepPts;
[clGr,clGr_pbc,clGr2,clGr2_pbc,Gr,histox]=RDF2(point1,dgrayIm,100);
clGr2_pbc(1)=0;
m6_fitRDF

figure
bar(histox,clGr2_pbc);
xlabel('Distance, r (px)');
ylabel('Counts (#)');

