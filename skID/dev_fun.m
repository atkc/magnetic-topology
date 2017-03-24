function dev_fun

filename='C:\Users\Anthony\Dropbox\Shared_MFM\Lattice Proj\x11o\x11o 900\160617_x11o_n4k-p900_sss (2)_processed.tiff'; %file directory

    im=imread(filename);
    %grayIm = rgb2gray(im);
    grayIm = im(:,:,1); %BGR chanels, grayIm will be based on the red intensity of the original image
    dgrayIm= double(grayIm); %matrix with double precision
    
    %resize image to 0-255 intensity, why? cos i like =D
    %dgrayIm=(dgrayIm-ones(size(dgrayIm))*min(min(dgrayIm)))*255/((max(max(dgrayIm)))-min(min(dgrayIm)));
    dgrayIm=dgrayIm*255/max(max(dgrayIm));
     S.fH = figure('menubar','none');
     imshow( dgrayIm,[0,255] ); hold on

 
 X = [];
 Y = [];
 
 set(S.fH,'WindowButtonDownFcn',@startDragFcn)
 set(S.fH,'WindowButtonUpFcn',@stopDragFcn)
 
 
    function startDragFcn(varargin)
          set( S.fH, 'WindowButtonMotionFcn', @draggingFcn );
          pt = get(S.fH, 'CurrentPoint');
          x = pt(1,1);
          y = pt(1,2);
          X = x;
          Y = y;
    end

    function draggingFcn(varargin)
        pt = get(S.fH, 'CurrentPoint');
        x = pt(1,1);
        y = pt(1,2);
        X = x
        Y = y
    end

    function stopDragFcn(varargin)
        disp('hi')
        set(S.fH, 'WindowButtonMotionFcn',[])
    end


end
 