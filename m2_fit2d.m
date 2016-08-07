%**************************************************
%*******Options************************************
%Option 1: fit masked by constant noise
%Option 2: fit on constant noise

fitOp=2;

redraw=0; %0: no figure to compare x-section 1: yes
drawMask=1;


%**************************************************
%*******data inputs********************************
%**************************************************

center=centroids(:,1:2); %retrieve the center points of skx
radius=centroids(:,3); %retrieve the radius of skx
im=dgrayIm; %original image to fit on
[m,n]=size(im);

    %fit parameters:
    fiti = zeros(length(center),7); %xi,yi,c,a,noise,residue,jacobian
    xyfit = zeros(length(center),7);
    isofit =zeros(length(center),7);
    result = zeros (length(center),2);

    %fit option:
    if fitOp==1
        noiseub=0;
        noiselb=0;
    else
        noiseub=255;
        noiselb=0;    
    end
    
%**************************************************
%*******fit routine********************************
%**************************************************
%individually fitted

    for i = 1:length(center)
        r=radius(i);%radius of particular skx based in binary image
        
        %***define a bounding box that encloses the skx****
        %*** fit is done in the defined box****
        x1=(int16(center(i,1)-r));
        x2=(int16(center(i,1)+r));

        y1=(int16(center(i,2)-r));
        y2=(int16(center(i,2)+r));
        
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
    
    %Portion of image to be fitted based on bounding box
    portion=dgrayIm(y1:y2,x1:x2);%portion to be fitted
%     figure
%     imshow(portion,[0,max(max(portion))])

%%******fit routine 1********
    opts_iso.iso=true;
    opts_tilted.tilted=false;
    zi=portion;
    [yf,xf]=size(portion);
    [xi,yi] = meshgrid(-((xf-1)/2):((xf-1)/2),-((yf-1)/2):((yf-1)/2));
    tmpiso= autoGaussianSurf(xi,yi,zi,opts_iso);
    tmpxy = autoGaussianSurf(xi,yi,zi,opts_tilted);
    xyfit(i,1:5) = [tmpxy.x0+double(center(i,1)) tmpxy.y0+double(center(i,2)) tmpxy.sigmax tmpxy.sigmay tmpxy.sigmax/tmpxy.sigmay];
    isofit(i,1:4) = [tmpiso.x0+double(center(i,1)) tmpiso.y0+double(center(i,2)) tmpiso.sigma sqrt((tmpiso.x0)^2 + (tmpiso.y0)^2)];
    
    msg=sprintf('skyrmion %i fitted',i);
    disp(msg);
% %     %%******fit routine 2********    
% %     x0=[double(x2-x1+1)/2,double(y2-y1+1)/2,r/2,noiselb,max(max(portion))];%relative x from x1,relative y from y1, std dev, amplitude
% %     
% %     lb=[1,1,0.2*r,noiselb,0]; %parameter lower bound
% %     ub=[double(x2-x1+1),double(y2-y1+1),2*r,noiseub,255]; %parameter upper bound
% %     
% %     %fit function
% %     fun=@(x)Gfun2D(size(portion),x(1),x(2),x(3),x(4),x(5))-portion;
% %     
% %     %optimization routine
% %     [x,resnorm,residual,exitflag,output,lambda,jacobian]=lsqnonlin(fun,x0,lb,ub);%,options);
% %     
% %     ci = nlparci(x,residual,'jacobian',jacobian);%confidence band
% %     
% %     fit(i,1:5)=x;% x is the optimised paramters
% %     fit(i,1)=int16(fit(i,1)+x1);%the x coor is relative to x1 therfore needs to account
% %     fit(i,2)=int16(fit(i,2)+y1);%the y coor is relative to y1 therfore needs to account
% %     fit(i,6:7)=ci(1,:);%confidence band 
% %     
% %     %%*******end fit routine 2************
    
    %********cross section plots for visual relief LOL **************
    if redraw==1
        mask=Gfun2D(size(im),fiti(i,1),fiti(i,2),fiti(i,3),fiti(i,4),fiti(i,5));
        
        %*****boundary for ploting*****
        a1=int16(fiti(i,1)-3*fiti(i,3));
        a2=int16(fiti(i,1)+3*fiti(i,3));
        if a1<1
            a1=1;
        end
        if a2>length(mask)
            a2=length(mask);
        end
        
        %*****plot figure*****     
        figure
        if fiti(i,2)>0 && fiti(i,2)<=length(mask)
            
            plot(a1:a2,mask(fiti(i,2),a1:a2));%fit plot
            hold on;
            plot(a1:a2,im(fiti(i,2),a1:a2));%actual image plot

        end
    end
    
    
    end
    
    figure
    imshow(dgrayIm,[0,max(max(dgrayIm))])
    for i = 1:length(isofit)
        hold on
        plot(isofit(i,1),isofit(i,2),'r.','MarkerSize',10);
    end
%**************************************************
%*******consoladation********************************
%**************************************************    
    figure
    histfit(isofit(:,3)*2.3548*5/1024);
    %[mu, sigma] = normfit(fit(:,3),10);
    mu=mean(isofit(:,3));
    sigma=std(isofit(:,3));
    
    filteredIndex = ((isofit(:,3)>(mu-sigma)).*(isofit(:,3)<(mu+sigma)))>0;
    filteredFit=isofit(filteredIndex,3);
    
    figure
    histfit(filteredFit*2.3548*5/1024);
    FWHM=mu*2*(2*log(2))^0.5;
    FWHMer=sigma*2*(2*log(2))^0.5;
    
    figure
    imshow(dgrayIm,[0,max(max(dgrayIm))])
    
%%drawing and saving the image
[m,n]=size(binIm);
whiteImage = 255 * ones(m, n, 'uint8');
for i = 1:length(isofit)
    
    whiteImage(round(isofit(i,1)),round(isofit(i,2)))=false;
end

whiteImage=logical(whiteImage);
imwrite(whiteImage,'white.png','png');

% gh=figure;
% imshow(whiteImage)
% 
%     
f=getframe(gca);
[X, map] = frame2im(f);
imwrite(X,'white.png','png');
    