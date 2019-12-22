[bx,by,bz]=fovf('B_demag000000.ovf');
[mx,my,mz]=fovf('m000000.ovf');
tf_ll=2;%last layer of magnetic material, first layer is 1
%how many thinfilm layers? %32:26aa

step_z=20;%nm
cell_size=20;%nm


[xrange,yrange,zrange]=size(mx);

cm = colormap(autumn(zrange));

Bz_h=zeros([1,zrange-tf_ll]);
Bx_h=zeros([1,zrange-tf_ll]);
By_h=zeros([1,zrange-tf_ll]);

liftheight=(1:zrange-tf_ll)*step_z;
for al=(tf_ll+1):zrange%first layer is 1
    Bz_h(al-tf_ll)=bz(xrange/2,yrange/2,al);
    Bx_h(al-tf_ll)=bx(xrange/2,yrange/2,al);
    By_h(al-tf_ll)=by(xrange/2,yrange/2,al);
end

xlim1=100;
xlim2=200;
figure;plot(liftheight,Bx_h*10^3);title('Bx in middle of skyrmion');xlabel('Height (nm)');ylabel('Bx (mT)');xlim([xlim1,xlim2]);
figure;plot(liftheight,By_h*10^3);title('By in middle of skyrmion');xlabel('Height (nm)');ylabel('By (mT)');xlim([xlim1,xlim2]);
figure;plot(liftheight,Bz_h*10^3);title('Bz in middle of skyrmion');xlabel('Height (nm)');ylabel('Bz (mT)');xlim([xlim1,xlim2]); 

y_raw=abs(Bz_h(liftheight<200));
x_raw=liftheight(liftheight<200);

x0=[1,1,2];
lb=[1e-9,0,1e-9];
ub=[1e9,100,10];
fun = @(x,xdata)((x(1)./((x(2)+xdata).^x(3))));
options = optimoptions('lsqcurvefit');
options.MaxFunctionEvaluations=1000;
xfit=lsqcurvefit(fun,x0,x_raw,y_raw,lb,ub,options);

Bz_h_fit = fun(xfit,x_raw);
figure;plot(x_raw,Bz_h_fit);hold on; plot(x_raw,y_raw,'o');

