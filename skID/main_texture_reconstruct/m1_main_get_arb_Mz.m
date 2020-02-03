sim_xy_size=10000;%nm
grid_xy_size=256;

sim_z_size=128*3;%nm
grd_z_size=128;
eff_z=14;%how many layers are magnetized?

Dshape=2;%1:periodic stripe 2:isolated/periodic circle 3:dipolar closure periodic stripe
domain_wall=0;
%domain_period=2000;%nm
%domain_width=800;%nm

for domain_width=[250 500]
domain_period=2*domain_width;

cellsize=sim_xy_size/grid_xy_size;
period_size=round(domain_period/cellsize);%approx px size
domain_size=round(domain_width/cellsize);%approx px size
domainw_size=round(domain_wall/cellsize);%approx px size

imxBi=zeros(grid_xy_size,grid_xy_size);
imyBi=zeros(grid_xy_size,grid_xy_size);
imzBi=ones(grid_xy_size,grid_xy_size)*-1;

imzBi=imzBi(1:grid_xy_size,1:grid_xy_size);
imyBi=imyBi(1:grid_xy_size,1:grid_xy_size);
imxBi=imxBi(1:grid_xy_size,1:grid_xy_size);

if Dshape==1
    for ix=1:period_size:grid_xy_size
        imzBi(ix:(ix+domain_size),:)=1;
    end
elseif Dshape==2 
    hexpts=(hexagonalGrid([-grid_xy_size/2,-grid_xy_size/2,grid_xy_size/2-1,grid_xy_size/2-1], [0,0], period_size));
    [a,b]=size(hexpts);
    [vecx,vecy]=meshgrid(-grid_xy_size/2:grid_xy_size/2-1);
    for ip=1:a
    dx=hexpts(ip,1);
    dy=hexpts(ip,2);
    vecxi=vecx+dx;
    vecyi=vecy+dy;
    vecr=(vecxi.^2+vecyi.^2).^0.5;    
    imzBi(vecr<=(domain_size/2+domainw_size))=0;
    imzBi(vecr<=domain_size/2)=1;
    vecxi_nom=vecxi./vecr;imxBi(vecr<=(domain_size/2+domainw_size))=vecxi_nom(vecr<=(domain_size/2+domainw_size));imxBi(vecr<=domain_size/2)=0;
    vecyi_nom=vecyi./vecr;imyBi(vecr<=(domain_size/2+domainw_size))=vecyi_nom(vecr<=(domain_size/2+domainw_size));imyBi(vecr<=domain_size/2)=0;
    end

else
    for ix=1:period_size:grid_xy_size
        imzBi(ix:(ix+domain_size),:)=1;
        imzBi(ix:(ix+domainw_size),:)=0;
        imyBi(ix:(ix+domainw_size),:)=1;
        
        imzBi(ix+domain_size:(ix+domain_size+domainw_size),:)=0;
        imyBi(ix+domain_size:(ix+domain_size+domainw_size),:)=-1;
    end
end


figure
plot_rgb_vec(imxBi,imyBi,imzBi);

if Dshape==1
    ovf_filename=strcat('stripe_p',num2str(domain_period),'nm_w',num2str(domain_width),'nm_updown.ovf');
elseif Dshape==2
    %ovf_filename=strcat('isocircle_r',num2str(domain_width/2),'nm_updown.ovf');
    %ovf_filename=strcat('circle_p',num2str(domain_period),'nm_w',num2str(domain_width),'nm_dw',num2str(domain_wall),'nm_updown_dipolar.ovf');
    ovf_filename=strcat('circle_p',num2str(domain_period),'nm_w',num2str(domain_width),'nm.ovf');
else
    ovf_filename=strcat('stripe_p',num2str(domain_period),'nm_w',num2str(domain_width),'nm_dipolar_updown.ovf');
end

m2_convet2mumax(ovf_filename,grid_xy_size,grd_z_size,eff_z,imxBi,imyBi,imzBi,0,0,0);
end