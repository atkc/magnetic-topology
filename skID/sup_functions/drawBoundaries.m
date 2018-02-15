function  []= drawBoundaries(handles, BW, col, LW ,conn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    cc=bwconncomp( BW,conn);
    graindata = regionprops(cc,'centroid','Area','PerimeterOld','MajorAxisLength','MinorAxisLength');
    centers=zeros(length(graindata),2);
    centers(:,1:2)=cat(1,graindata.Centroid);
    Major=[graindata.MajorAxisLength];
    Minor=[graindata.MinorAxisLength];
    diameters = (Major+Minor)/2;
    radii = diameters/2;

    
    [B,~] = bwboundaries(BW,conn,'noholes');
%    axes(handles.figBox);
%     c=figure;
%     imshow(BW)
    for k=1:length(radii)
        hold on;
        viscircles(centers(k,:),1.4*radii(k),'LineWidth',1,'Color',col);
    end
%     for k = 1:length(B)
%         boundary = B{k};
%         plot(boundary(:,2), boundary(:,1), col, 'LineWidth', LW)
%     end
    
    
end


