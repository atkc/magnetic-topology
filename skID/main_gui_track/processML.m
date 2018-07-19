function [ fullstat2 ] = processML( MasterList, p_no )
%PROCESSML Summary of this function goes here
%   Detailed explanation goes here
%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
p_no=sort(p_no);
fullstat2=zeros(10000,8);%[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
fs_i=1;
skN_max=max(max(max(MasterList(:,:,1))));
%skN=(1:skN_max)';
for p=p_no
    p_before=p-1;
    if ismember(p_before,p_no)
        ml_now=reshape(MasterList(1:skN_max,p+1,:),[skN_max,4]);
        ml_before=reshape(MasterList(1:skN_max,p_before+1,:),[skN_max,4]);
        ml_now=sortrows(ml_now,1);
        ml_before=sortrows(ml_before,1);
        centroids=ml_now(:,2:3);
        centroids_before=ml_before(:,2:3);
        skID_now=ml_now(:,1);
        skID_before=ml_before(:,1);
        for skN_i=1:skN_max
            skN_index=skID_before==skID_now(skN_i);
            xy_now=centroids(skID_now(skN_i),:);
            xy_before=centroids_before(skN_index,:);
            dx=xy_now(1)-xy_before(1);
            dy=xy_now(2)-xy_before(2);
            dist1=sqrt(dx.^2+dy.^2);
            sel_index=((dist1>0)&&~ismember(xy_now,[0,0],'rows')&&~ismember(xy_before,[0,0],'rows'));
            if sel_index
                data=[fs_i,p,dist1,dx,dy,xy_before,skID_now(skN_i)];
                fullstat2(fs_i,:)=data;
                fs_i=fs_i+1;
            end
        end
    end
end

end

