function [  ] = plot_centers( handles, centroids )
%LOT_CENTERS Summary of this function goes here
%   Detailed explanation goes here
    [noOfCentriods,~]=size(centroids);
    axes(handles.figBox);
    for i = 1:noOfCentriods
        hold on
        plot(centroids(i,1),centroids(i,2),'bs','MarkerSize',7,'LineWidth',2);
    end
    
    
end

