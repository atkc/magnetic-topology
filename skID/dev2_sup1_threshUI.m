function [threshlevelo] = dev_sup1_threshUI(im)
    f = figure('Visible','off');
    
    %binarize image based on multithresh algo
    global threshleveli;
    threshleveli = double(multithresh(im))/double(max(max(im)));
    binIm= imquantize(im,max(max(im))*threshleveli);
    
    %show preliminary binarized image
    topph = uipanel('Parent', f,'Title', 'Binarized Image','Position',[0 0.25 1 0.75]);
    axes('Parent', topph, 'Position', [.10, .1 0.8 0.8]);
    imshow(binIm,[0,max(max(binIm))]);
    
    % Create slider for threshvalue
    bottomph = uipanel('Parent', f,'Title','Threshold Level','Position',[0 0 1 .25]);
    sld = uicontrol('Style', 'slider',...
    'Min',0,'Max',1,'Value',threshleveli,...
    'String','Thresh Level',...
    'Position', [200 20 120 20],...
    'Callback',{@threshIt,im}); 

    %Create finished button
    btn = uicontrol('Parent', bottomph,'Style', 'pushbutton',...
    'String','Finish',...
    'Position', [400 20 120 20],...
    'Callback', 'uiresume(gcbf)'); 

    f.Visible = 'on';
   

    function threshIt(source,callbackdata,im)
        threshl = source.Value;
        %i=threshl
        threshleveli=threshl;
        binIm2= imquantize(im,max(max(im))*threshl);
        imshow(binIm2,[0,max(max(binIm2))]);
    end
    
    
    uiwait(gcf);
    close(f);
    threshlevelo=threshleveli;
end

