[mx,my,mz]=fovf('m000000.ovf');
[bx,by,bz]=fovf('B_demag000000.ovf');

tf_ll=7;%last layer of magnetic material, first layer is 1
%how many thinfilm layers? %32:26aa

step_z=1;
cell_size=10;%nm
%**********Check Magnetization********************
checkM=0;
if checkM
    for al=[1:100]
    mlayer=al;
    figure
    subplot(2,2,1);
    ml=mx(:,:,mlayer);
    imshow(ml,[min(mx(:)),max(mx(:))]);
    title('mx');

    subplot(2,2,2);
    ml=my(:,:,mlayer);
    % imshow(ml);
    imshow(ml,[min(ml(:)),max(ml(:))]);
    title('my');

    subplot(2,2,4);
    ml=mz(:,:,mlayer);
    imshow(ml,[min(my(:)),max(my(:))]);
    title(strcat('m layer:',num2str(al-1)));
    end
end
%**********Check Magnetization********************

writefile=0;
saveStray=0;
plotim=1;
fx=figure;
set(fx, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.7, 0.5]);
title('Bx');xlabel('nm');ylabel('T');
fy=figure;
set(fy, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.7, 0.5]);
title('By');xlabel('nm');ylabel('T');
fz=figure;
set(fz, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.7, 0.5]);
title('Bz');xlabel('nm');ylabel('T');

fnv_y=figure;
set(fnv_y, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.7, 0.5]);
title('Bnv_y');xlabel('nm');ylabel('T');
fnv_x=figure;
set(fnv_x, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.7, 0.5]);
title('Bnv_x');xlabel('nm');ylabel('T');

xrange=126:386;%126:386;
yrange=16;
cm = colormap(autumn(tf_ll+60));
for al=[tf_ll+10:10:100]%first layer is 1

    filename=strcat('Bfield_',num2str((al-tf_ll)*step_z));
    blayer=al;
    bx_l=bx(:,:,blayer);
    by_l=by(:,:,blayer);
    bz_l=bz(:,:,blayer);
    lw=0.5;
    if al==tf_ll+30
        cm_now=[0 0 0];
        lw=2;
    elseif (rem( al-tf_ll, 10 )==0)
        cm_now=[0.3 0.3 0.3];
    else
        cm_now=cm(al,:);
    end
%     figure(fx);hold on;plot(cell_size*xrange,bx_l(xrange,yrange),'Color', cm_now,'LineWidth',lw);
%     figure(fy);hold on;plot(cell_size*xrange,by_l(xrange,yrange),'Color', cm_now,'LineWidth',lw);
%     figure(fz);hold on;plot(cell_size*xrange,bz_l(xrange,yrange),'Color', cm_now,'LineWidth',lw);
%     
%     bnv_x=bx_l(xrange,yrange)*sin(54.7*pi/180)+bz_l(xrange,yrange)*cos(54.7*pi/180);
%     figure(fnv_x);hold on;plot(cell_size*xrange,bnv_x,'Color', cm_now,'LineWidth',lw);
%     bnv_y=by_l(xrange,yrange)*sin(54.7*pi/180)+bz_l(xrange,yrange)*cos(54.7*pi/180);
%     figure(fnv_y);hold on;plot(cell_size*xrange,bnv_y,'Color', cm_now,'LineWidth',lw);
    
    if plotim
        figure
        subplot(2,2,3);
        imshow(flipud(bz_l),[min(bz_l(:)),max(bz_l(:))]);
        title('Bz')
        subplot(2,2,4);
        title(strcat('demag layer:',num2str(al-1)));
        subplot(2,2,1);
        imshow(flipud(bx_l),[min(bx_l(:)),max(bx_l(:))]);
        title('Bx')
        subplot(2,2,2);
        imshow(flipud(by_l),[min(by_l(:)),max(by_l(:))]);
        title('By')
        subplot(2,2,4);
        %figure;
        plot_rgb_vec(bx_l,by_l,bz_l);
        title(strcat('demag layer:',num2str(al-1)));
    end
    if writefile
        dlmwrite(strcat(filename,'_Bz.txt'),bz_l,',')
        dlmwrite(strcat(filename,'_Bx.txt'),bx_l,',')
        dlmwrite(strcat(filename,'_By.txt'),by_l,',')
    end
    if saveStray&&((al-tf_ll)*step_z==30)
        im_rgb=plot_rgb_vec(bx_l,by_l,bz_l);
        imwrite(flipud(im_rgb),strcat('strayfield_',num2str((al-28)*step_z),'.png'))
        f1=figure;
        subplot(1,3,1);plot(bx_l(:,64),'LineWidth',3);title('Bx @ 30nm');
        subplot(1,3,2);plot(by_l(:,64),'LineWidth',3);title('By @ 30nm');
        subplot(1,3,3);plot(bz_l(:,64),'LineWidth',3);title('Bz @ 30nm');
        set(f1, 'Units', 'Normalized', 'OuterPosition', [0.1, 0.1, 0.7, 0.5]);
        saveas(f1,strcat('strayfieldxyz_',num2str((al-28)*step_z),'.png'))
        close(f1);
        im_rgb=plot_rgb_vec(mx(:,:,1),my(:,:,1),mz(:,:,1));
        imwrite(flipud(im_rgb),strcat('mag_',num2str((al-tf_ll)*step_z),'.png'))
    end
    
end
% saveas(fx,strcat('strayfieldx_30-60nm_lift','.png'))
% saveas(fy,strcat('strayfieldy_30-60nm_lift','.png'))
% saveas(fz,strcat('strayfieldz_30-60nm_lift','.png'))
figure
surf((bx_l*sin((54*pi)/180)+bz_l*cos((54*pi)/180)));
view(2)
shading interp


saveas(fnv_y,strcat('strayfieldnv_y_30-60nm_lift','.png'))
saveas(fnv_x,strcat('strayfieldnv_x_30-60nm_lift','.png'))
% bz_l=bx(:,:,68);
% max(bz_l(:))
% for al=[9:1:20]
% blayer=al;
% figure
% bl=bz(:,:,blayer);
% subplot(2,2,1);
% plot((1:256)*80,bl(64,:))
% title(strcat('distance (nm):',num2str((al-8)*20)));
% bl=bx(:,:,blayer);
% subplot(2,2,3);
% plot((1:256)*80,bl(64,:))
% bl=by(:,:,blayer);
% subplot(2,2,4);
% plot((1:256)*80,bl(64,:))
% end
% 
% pts=round(hexagonalGrid([-511,-511,512,512],[0 0],150));
% for ipt=1:length(pts)
%     fprintf('m.setInShape(cylinder(150e-9, 200e-9).transl(%de-9,%de-9,0), a.transl(%de-9,%de-9,0))\n',pts(ipt,1),pts(ipt,2),pts(ipt,1),pts(ipt,2));
% end
% 
% tdemag=(bx.^2+by.^2+bz.^2).^0.5;
% checkA=tdemag(50:70,50:70,:);
% checkm=mz(50:70,50:70,:);
% maxdemag=reshape(max(max(checkA)),[1,lz]);
% plot(((1:lz)-40),maxdemag*10^3)
% xlabel('nm')
% ylabel('mT')