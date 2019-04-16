function [xyfit,unfitno]=m2_fit2d_aniso(radius,centroids, dgrayIm, name,maxr,checkInd,imageSize)
%Description:
%This routine takes the centroids mat generated by m1*.m to assists the
%2D guassian fit on the unfiltered image - dgrayIm. It does an
%anisotropic fit. TO optimise the process, the fit is done
%only on a selected area of interest rather than the whole image. Therefore
%the window to fit (ie size and position) dynamically varies with each 
%centroid position. 
warningInd=0;
saveInd=false;
radius=maxr*radius;
%problems:
%#1 the size of window to fit drastically changes the fit -> need to optimised
%this
%#2 need to retrieve te error of fit (ie confidence band etc)

%**************************************************
%*******Options************************************
%Option 1: fit masked by constant noise
%Option 2: fit on constant noise



%**************************************************
%*******data inputs********************************
%**************************************************
cindex=(centroids(:,1)>0)&(centroids(:,2)>0);
centroids=centroids(cindex,:);%Error handling to remove negative values
center=centroids(:,1:2); %retrieve the est center points of skx

%radius=(1.5*max(centroids(:,3))); %retrieve the est radius of skx
im=dgrayIm; %original image to fit on
[m,n]=size(im);

    %fit parameters:
    xyfit =zeros(length(center),7); %store iso fit
    %xi,yi,sigma1,sigma2,theta, noise,amp
    
%**************************************************
%*******fit routine********************************
%**************************************************
%individually fitted
    %r=radius;%est radius of particular skx based in binary image (was radius(i)
    [mx,ny]=size(center)
    for i = 1:mx
       %try
        if (length(radius) > 1)
            %r=2*radius(i);
            r=radius(i);%to handle indiv radius
        else
            %r=2*radius;
            r=radius;%to handle average radius input
        end
        
        %***dynamic mesh routine***
        %***define a bounding box that encloses the skx****
        %*** fit is done in the defined box****
        x1=center(i,1)-r;%(int16(center(i,1)-int16(r)));
        x2=center(i,1)+r;%(int16(center(i,1)+int16(r)));
        y1=center(i,2)-r;%(int16(center(i,2)-int16(r)));
        y2=center(i,2)+r;%(int16(center(i,2)+int16(r)));

        %*****Handle pointers out of matrix range*******
            if x1<1;
                x1=1;
            end
            if x2>n
                x2=n;
            end
            if y1<1;
                y1=1;
            end
            if y2>m
                y2=m;
            end

    [cmask_y,cmask_x]=meshgrid(int64(y1):int64(y2),int64(x1):int64(x2));
    portion=dgrayIm(int64(y1):int64(y2),int64(x1):int64(x2));%portion to be fitted
    
    %***%Circular mask ideally for better fit - not in use at the moment***
    %cmask=(((cmask_x-center(i,1)).^2+(cmask_y-center(i,2)).^2)<=r^2);    
    %portion=portion.*cmask';
    
    %***Smaller area of fit region to retrieve stricter parameter bounds***
    y1Ass=int64(y1+(y2-y1)/4);
    y2Ass=int64(y2-(y2-y1)/4);
    x1Ass=int64(x1+(x2-x1)/4);
    x2Ass=int64(x2-(x2-x1)/4);
    portionAss=dgrayIm(y1Ass:y2Ass,x1Ass:x2Ass);
    
    %%******fit routine********    
    noiselb=min(min(portion));
    noiseub=max(min(portion));%(min(min(portion))+max(max(portion)))/2;
    midx=double(x2-x1)/2;
    midy=double(y2-y1)/2;
    
    %parameters:(xi,yi,sigma1,sigma2,theta, noise,amp)
    x0=[midx,midy,r,r,45,noiselb,max(max(portionAss))];%relative x from x1,relative y from y1, std dev, amplitude
    lb=[midx-0.5*r,midy-0.5*r,0.1*r,0.1*r,0,0.9*noiselb,0.9*max(max(portionAss))]; %parameter lower bound
    ub=[midx+0.5*r,midy+0.5*r,2*r,2*r,180,noiseub,max(max(portionAss))]; %parameter upper bound
    %fit function with weights of a gaussian
    options=optimset('display','off');
    [lx,ly]=size(portion);
    [wx,wy]=meshgrid(1:ly,1:lx);%(((wx-xt(1)).^2+(wy-xt(2)).^2).^-0.5);%1/r weight
    %(Gfun2D(size(portion),xt(1),xt(2),(xt(3)+xt(4))/2,0,xt(7))/(xt(7)));%isogaussian_weight
    %(Gfun2D_aniso(size(portion),xt(1),xt(2),xt(3),xt(4),xt(5),0,xt(7))/(xt(7)));%anisogaussian_weight
    %.*cmask';
    fun=@(xt)(Gfun2D_aniso(size(portion),xt(1),xt(2),xt(3),xt(4),xt(5),xt(6),xt(7))-portion).*(Gfun2D(size(portion),xt(1),xt(2),(xt(3)+xt(4))/2,0,xt(7))/(xt(7)));%isogaussian_weight

    %optimization routine
    [x,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin(fun,double(x0),double(lb),double(ub),options);
    
%     if (x(3)<=1.3*lb(3))
%         fun=@(xt)(Gfun2D(size(portion),xt(1),xt(2),xt(3),xt(4),xt(5))-portion);
%         [x,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin(fun,double(x0),double(lb),double(ub));%,options);
%     end
%     ratio=x(3)/lb(3)
    xo=x(1);
    yo=x(2);
    sigma1=x(3);
    sigma2=x(4);
    theta=x(5);
    b=x(6);
    a=x(7);

    xyfit(i,:) = [xo+double(x1) yo+double(y1) sigma1 sigma2 theta b a];

%     fit(i,1)=int16(fit(i,1)+x1);%the x coor is relative to x1 therfore needs to account
%     fit(i,2)=int16(fit(i,2)+y1);%the y coor is relative to y1 therfore needs to account
%     fit(i,6:7)=ci(1,:);%confidence band 
    
    %%*******end fit routine ************
    
    

if (checkInd)
    %%*****Reconstructing of fitted image**********
    indSk_prop=[xo yo sigma1 sigma2 theta b a imageSize/m];
    save('indSk_prop.mat','indSk_prop');

    rawIm2=portion;

%     fitIm=Gfun2D(size(portion),xo,yo,sigma,b,a);
% %     fitIm=a*exp(-((xi-xo).^2/2/sigma^2 + ...
% %                                    (yi-yo).^2/2/sigma^2)) + b;
    save('rawIm2.mat','rawIm2');
%     save('fitIm.mat','fitIm');
    uiwait(indSk_gui)
end


if (saveInd)
    rawIm2=portion;
    fitIm=Gfun2D_aniso(size(portion),xo,yo,sigma1,sigma2,theta,b,a);
    [~,sy]=size(rawIm2);
    saveInd=false;
    xq=xo;
    yq=1:0.5:sy;
    Vq = interp2(rawIm2,xq,yq);
    Vfitq = interp2(fitIm,xq,yq');
    
    fh=figure;
    plot(yq,Vq,'rx');%fit plot
    hold on;
    plot(yq,Vfitq);%fit plot
    saveas(fh,strcat(name,'_fit.png'));
    close (fh)
end

    msg=sprintf('skyrmion %i fitted',i);
    disp(msg);
%     
    %********cross section plots for visual relief LOL **************
%     if redraw==1
%         mask=Gfun2D(size(im),fiti(i,1),fiti(i,2),fiti(i,3),fiti(i,4),fiti(i,5));
%         
%         %*****boundary for ploting*****
%         a1=int16(fiti(i,1)-3*fiti(i,3));
%         a2=int16(fiti(i,1)+3*fiti(i,3));
%         if a1<1
%             a1=1;
%         end
%         if a2>length(mask)
%             a2=length(mask);
%         end
%         
%         %*****plot figure*****     
%         figure
%         if fiti(i,2)>0 && fiti(i,2)<=length(mask)
%             
%             plot(a1:a2,mask(fiti(i,2),a1:a2));%fit plot
%             hold on;
%             plot(a1:a2,im(fiti(i,2),a1:a2));%actual image plot
% 
%         end
%     end
%     
%        catch ME
%            warning('gg');
%            ME.identifier
%            warningInd=warningInd +1;
%        end
     end
    unfitno=warningInd;
    fprintf('Unable to fit %i of %i skyrmions.\n',warningInd,mx);
%     
%     figure
%     imshow(dgrayIm,[0,max(max(dgrayIm))])
%     for i = 1:length(isofit)
%         hold on
%         plot(isofit(i,1),isofit(i,2),'r.','MarkerSize',10);
%     end
%**************************************************
%*******consoladation********************************
%**************************************************    

%%******** First pass to get approximate mean and sigma***********
%isofit
%     [mu, sigma] = normfit(fit(:,3),10);
% % %     mu=mean(isofit(:,3));
% % %     sigma=std(isofit(:,3));
% % % %     histFig1=figure;
% % % %     histfit(isofit(:,4));
% % %     mu=mean(isofit(:,4));
% % %     sigma=std(isofit(:,4));
% % %     dim = [.2 .3 .3 .3];
% % %     str = strcat('mean FWHM =', num2str(mu),setstr(177),num2str(sigma));
% % %     annotation('textbox',dim,'String',str,'FitBoxToText','on');
%%******** Second pass to remove outliers***********
% % %     fil_Index = ((isofit(:,4)>(mu-1*sigma)).*(isofit(:,4)<(mu+1*sigma)))>0
% % %     fil_Fit=isofit;%isofit(fil_Index,:)
% % %     
% % %     mu=mean(fil_Fit(:,3));
% % %     FWHM=mu*2*(2*log(2))^0.5;
% % %     
% % %     sigma=std(fil_Fit(:,3));
% % %     FWHMer=sigma*2*(2*log(2))^0.5;
    
%%****Plot of figure********
% % % %     histFig=figure;
% % % %     histfit(fil_Fit(:,4));
% % % %     title('Histogram of skyrmion sizes (FWHM) in px')
% % % %     dim = [.2 .3 .3 .3];
% % % %     str = strcat('mean FWHM =', num2str(FWHM),setstr(177),num2str(FWHMer));
% % % %     annotation('textbox',dim,'String',str,'FitBoxToText','on');
% % % %     saveas(histFig,strcat(name,'_histfit.png'));
% % % %     close (histFig)

%     
%     figure
%     imshow(dgrayIm,[0,max(max(dgrayIm))])
    
% %%drawing and saving the image
% [m,n]=size(binIm);
% whiteImage = 255 * ones(m, n, 'uint8');
% for i = 1:length(isofit)
%     
%     whiteImage(round(isofit(i,1)),round(isofit(i,2)))=false;
% end
% 
% whiteImage=logical(whiteImage);
% imwrite(whiteImage,'white.png','png');
% 
% % gh=figure;
% % imshow(whiteImage)
% % 
% %     
% f=getframe(gca);
% [X, map] = frame2im(f);
% imwrite(X,'white.png','png');
%     

