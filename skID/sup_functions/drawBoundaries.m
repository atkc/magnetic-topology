function  []= drawBoundaries(handles, BW, col, LW ,conn)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    [B,~] = bwboundaries(BW,conn,'noholes');
    axes(handles.figBox);
    hold on;
    for k = 1:length(B)
        boundary = B{k};
        plot(boundary(:,2), boundary(:,1), col, 'LineWidth', LW)
    end
    
    
end


