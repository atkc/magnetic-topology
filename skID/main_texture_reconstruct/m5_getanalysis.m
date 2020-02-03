
mz_l=imread('Mz_3.png');
yrange=183:197;
xrange=107:135;
ylrange=183:197;
xlrange=120;
gg=0;
stepgg=5;
f1=figure;
f2=figure;
for al=[30 60 93 147 342]%33%(85-12)%[(tf_ll+1):10:128]%first layer is 1
    filename=strcat('Bfield_',num2str(al));
    blayer=al;
    bx_l=load(strcat(filename,'nm_Bx.txt'));
    by_l=load(strcat(filename,'nm_By.txt'));
    bz_l=load(strcat(filename,'nm_Bz.txt'));
    
    bx_lr=bx_l(xrange,yrange);
    by_lr=by_l(xrange,yrange);
    bz_lr=bz_l(xrange,yrange);
    
    bx_line=bx_l(xlrange,ylrange);
    by_line=by_l(xlrange,ylrange);
    bz_line=bz_l(xlrange,ylrange);
    
%     figure;
%     plot_rgb_vec(bx_l,by_l,bz_l);
%     title(strcat('height:',num2str(al),'nm'));
%     figure;
%     plot_rgb_vec(bx_lr,by_lr,bz_lr);
%     title(strcat('height:',num2str(al),'nm'));
    figure(f1)
    hold on
    quiver(ylrange,gg*stepgg*ones(size(ylrange)),bx_line,bz_line);   
    gg=(gg+1);
    figure(f2)
    subplot(4,1,2)
    hold on
    plot(ylrange,(bx_line.^2+bz_line.^2).^0.5+0*gg);   
    
    subplot(4,1,3);
    hold on
    plot(ylrange,(bx_line*sin(54.7*pi/180)+bz_line*cos(54.7*pi/180))+0*gg);  
    
    subplot(4,1,4);
    hold on
    plot(ylrange,(abs(bx_line*sin(54.7*pi/180)+bz_line*cos(54.7*pi/180)))+0*gg);   
    
end
    figure(f2);
    subplot(4,1,1);
    plot(ylrange,mz_l(xlrange,ylrange));
    title('Magnetization');
    subplot(4,1,2);
    title('Stray Field Magnitude(T)');
    subplot(4,1,3);
    title('Stray Field Projection to NV axis(T)')
    subplot(4,1,4);
    title('Abs Stray Field Projection to NV axis(T)')