function [ col_map ] = plot_col_centers( handles, centroids ,col_map,op,skN,zmode_sub)
%LOT_CENTERS Summary of this function goes here
%   Detailed explanation goes here
%op: 1:get new col maps, 2: add new col to newly added point/return same
%col_map if no new sk added
s=1;
if zmode_sub>1
    s=2;
end
[noOfCentriods,~]=size(centroids);
l_col_map=sum(any(col_map,2));
col_val=[0.01,0.01,0.01,0.33,0.33,0.33,0.66,0.66,0.66,1,1,1];
C=permn(col_val,3);
C=unique(C,'rows');
[~, i_remove]=ismember([0.33,0.33,0.33],C,'rows');
C(i_remove,:)=[];
[~, i_remove]=ismember([0.66,0.66,0.66],C,'rows');
C(i_remove,:)=[];
if (op==1)
    c_i=mod(11*(1:noOfCentriods),length(C));
    col_map(1:noOfCentriods,:)=C(c_i(1:noOfCentriods)+1,:);
elseif (op==2)
    c_i=mod(11*(1:noOfCentriods),length(C));    
end

axes(handles.figBox);
for i = 1:noOfCentriods
    hold on
    if (centroids(i,1)>0)%if x,y =0 means skyrmion is out of the current frame
        if i>l_col_map;%skyrmions added -> giving col to the added sk
            col_map(i,:)=C(c_i(i)+1,:);
            plot(centroids(i,1),centroids(i,2),'.','MarkerSize',9,'color',col_map(i,:))
        else
            if (i==skN)%to tag selected sk in move mode differently
                plot(centroids(i,1),centroids(i,2),'o','MarkerSize',s*4,'linewidth',s*1,'color',col_map(i,:));
            else
                plot(centroids(i,1),centroids(i,2),'.','MarkerSize',s*9,'color',col_map(i,:));
            end
        end
    end
end


end

