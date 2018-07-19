%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
conv=13000*10^-3/1080; %estimated um/px
pulse_range=29:31;
for pulse_i=1:length(pulse_range)
    x = MasterList(:,pulse_range(pulse_i),2)*conv;
    y = MasterList(:,pulse_range(pulse_i),3)*conv;
    %remove 0s
    y(x==0)=[];
    x(x==0)=[];

    tri = delaunayTriangulation(x,y);
    triplot(tri);
    axis equal;
    Clist=tri.ConnectivityList;
    areas = polyarea(x(Clist),y(Clist),2); %um2
    areas_fil=areas;
    mean1=0;
    std1=0;
    mean2=1000;
    std2=0;
    change_mean=100;
    i=0;
    while (change_mean>5)
        i=1+1
        mean2=mean1;
        std2=std1;
        m_area=mean(areas_fil);
        std_area=std(areas_fil);
        areas_fil=(areas_fil(((areas_fil<m_area+std_area).*(areas_fil>m_area-std_area))==1));
        mean1=mean(areas_fil)
        std1=std(areas_fil)
        change_mean=abs(mean1-mean2)*100/mean2
        figure
        histfit(areas_fil)
    end

    mean_area(pulse_i)=mean2;
    std_area(pulse_i)=std2;
end
figure
plot(pulse_range,mean_area)
marea=mean(mean_area)
marea_std=std(mean_area)
dens=mean(1./(mean_area))
dens_std=std(1./(mean_area))
[marea,marea_std,dens,dens_std]
dens_info=[pulse_range;mean_area;std_area]';