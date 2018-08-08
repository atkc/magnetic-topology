%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
conv=13000/1080; %estimated nm/px
pulse_range=16;
storage=zeros(1000,4);
store_i=1;
for pulse_i=1:length(pulse_range)
    skN=MasterList(:,pulse_range(pulse_i),1);
    skN_max= max(skN);
    
    checkSkList=1:skN_max;
    movingSkList=sort(fullstat2((fullstat2(:,2)==(pulse_range(pulse_i)+1)),8));
    checkSkList(movingSkList)=[];%based on skN (full) 
    
    
    m_vx=fullstat2((fullstat2(:,2)==(pulse_range(pulse_i)+1)),4);
    m_vy=fullstat2((fullstat2(:,2)==(pulse_range(pulse_i)+1)),5);
    m_x=fullstat2((fullstat2(:,2)==(pulse_range(pulse_i)+1)),6);
    m_y=fullstat2((fullstat2(:,2)==(pulse_range(pulse_i)+1)),7);
    
    x= MasterList(:,pulse_range(pulse_i),2);
    y = MasterList(:,pulse_range(pulse_i),3);
    %remove 0s
    y(x==0)=[];
    skN(x==0)=[];
    x(x==0)=[];
    
    tri = delaunayTriangulation(x,y);
    clist=tri.ConnectivityList;%based on skN (temp)
    

    
    sk_temp=1:length(skN);
    for sk_id=checkSkList;
        sk_id_temp=sk_temp(skN==sk_id);
        if ~isempty(sk_id_temp)
        [r,c] = find(clist==sk_id_temp);%based on skN (temp)
        nn_id_temp=unique(reshape(clist(r,:),1,[]));%based on skN (temp)
        sum(nn_id_temp==sk_id_temp)%must be true
        nn_id_temp(nn_id_temp==sk_id_temp)=[];%based on skN (temp)
        nn_id=skN(nn_id_temp);%based on skN (full)
        for skj=nn_id'
            if ~isempty(find(movingSkList==skj,1))
                dx=m_x(find(movingSkList==skj,1))-x(sk_id_temp);
                dy=m_y(find(movingSkList==skj,1))-y(sk_id_temp);
                if ((dx==0)&&(dy==0))
                    display('asdas')
                end
                vx=m_vx(find(movingSkList==skj,1));
                vy=m_vy(find(movingSkList==skj,1));
                storage(store_i,:)=[dx,dy,vx,vy];
                store_i=store_i+1;
            end
        end
        end
    end
end
% plot(storage(1:store_i-1,1),storage(1:store_i-1,2),'o')
% axis equal


figure
plot(storage(1:store_i-1,1)*conv,-storage(1:store_i-1,2)*conv,'o')
hold on
q=quiver(storage(1:store_i-1,1)*conv,-storage(1:store_i-1,2)*conv,storage(1:store_i-1,3)*conv,-storage(1:store_i-1,4)*conv)
q.AutoScale='off'
q.LineWidth=1;
q.Color = 'black';
axis equal
xlim([-40*conv,40*conv]);
ylim([-40*conv,40*conv]);
xlabel('x (nm)')
ylabel('y (nm)')
legend('NN position (nm)','NN motion vector')