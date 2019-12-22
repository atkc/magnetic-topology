%masterList(skID,ImageInd(pulse no),:)=[skID_min,coor_x,coor_y,size];
%fullstat2(i,:)=[i,imageInd(pulse no),minDist,minDist_x,minDist_y,coor_x,coor_y,skID_min,size];
conv=13000/1080; %estimated nm/px
pulse_range=[6 7 39 40];
%180412-1_fp553_1b_d2_2um_n4k-p750\analysis_750\CTF
%flow:[6 7 39 40]

%180417-1_fp553_1b_d3_2um_n4k-p750\analysis\registered_ctf\skel (p4-34)
%flow:[5 6 7 8 9 10 27 28 29 30 31 32 33 34]%[5 7 9 27 29 31 33]%[6 8 10 28 30 32 34];%;
edgeDat=zeros(1000,7);%dist,dsk1(min),dsk2(max),dsk1*dsk2,dsk1/dsk2,dsk1+dsk2,|dsk1-dsk2|
edgeDati=1;
for pulse_i=1:length(pulse_range)

    sksize=newfullstat2((newfullstat2(:,2)==(pulse_range(pulse_i))),9)*conv;
    xycoor=newfullstat2((newfullstat2(:,2)==(pulse_range(pulse_i))),6:7)*conv;
    
        
    tri = delaunayTriangulation(xycoor(:,1),xycoor(:,2));
    clist=tri.ConnectivityList;%based on skN (temp)
    triplot(tri)
    hold on
    plot(xycoor(:,1),xycoor(:,2),'*')
    E= edges(tri);
    for ei=1:length(E)
      vertex_id1=E(ei,1);
      vertex_id2=E(ei,2);
      sk_sk_dist=sqrt(sum((xycoor(vertex_id1,:)-xycoor(vertex_id2,:)).^2));
      dsk1=min([sksize(vertex_id1),sksize(vertex_id2)]);
      dsk2=max([sksize(vertex_id1),sksize(vertex_id2)]);
      if (dsk1>50)&&(dsk2>60)&&(dsk1<200)&&(dsk2<200)&&(sk_sk_dist<400)
      edgeDat(edgeDati,:)=[sk_sk_dist,dsk1,dsk2,dsk1*dsk2,dsk1/dsk2,dsk1+dsk2,abs(dsk2-dsk1)];
      edgeDati=edgeDati+1;
      end
    end

end
edge_remove=(edgeDat(:,1)==0);
edgeDat(edge_remove,:)=[];
%edgeDat=edgeDat(1:edgeDati-1,:);
figure;
plot(edgeDat(:,1),edgeDat(:,2),'o');
title('dsk1');
xlabel('sk-sk distance (nm)')
ylabel('dsk_min (nm)')

figure;
plot(edgeDat(:,1),edgeDat(:,3),'o');
title('dsk2');
xlabel('sk-sk distance (nm)')
ylabel('dsk_max (nm)')

figure;
plot(edgeDat(:,1),edgeDat(:,4),'o');
title('dsk_1 x dsk_2');
xlabel('sk-sk distance (nm)')
ylabel('(dsk_1 x dsk_2)_{avg} (nm^2)')

binN=10;
binE=linspace(min(edgeDat(:,4)),max(edgeDat(:,4)),binN);
values=edgeDat(:,1);
avg_values=zeros(1,length(binE)-1);
avg_binE=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((edgeDat(:,4)>=binE(el)).*(edgeDat(:,4)<binE(el+1)));
    avg_values(el)= mean(values(hold_i));
    avg_binE(el)=(binE(el)+binE(el+1))/2;
end
figure;
hold on
plot(edgeDat(:,4),edgeDat(:,1),'o');
plot(avg_binE,avg_values,'-*')
title('(dsk_1 x dsk_2)_{avg}');
ylabel('sk-sk_{NN} distance (nm)')
xlabel('(dsk_1 x dsk_2)_{avg} (nm^2)');

edgeDat_4=[avg_binE;avg_values];
% save('edgeDat.mat','edgeDat')
% save('edgeDat_4.mat','edgeDat_4')

binN=10;
binE=linspace(min(edgeDat(:,1)),max(edgeDat(:,1)),binN);
values=edgeDat(:,4);
avg_values=zeros(1,length(binE)-1);
avg_binE=zeros(1,length(binE)-1);
for el=1:length(binE)-1
    hold_i=logical((edgeDat(:,1)>=binE(el)).*(edgeDat(:,1)<binE(el+1)));
    avg_values(el)= mean(values(hold_i));
    avg_binE(el)=(binE(el)+binE(el+1))/2;
end
figure;
hold on
plot(edgeDat(:,1),edgeDat(:,4),'o');
plot(avg_binE,avg_values,'-*')
title('(d_{sk1} x d_{sk2})_{avg} vs sk-sk_{NN}');
xlabel('sk-sk_{NN} distance (nm)')
ylabel('(d_{sk1} x d_{sk2}) (nm^2)');

figure;
plot(edgeDat(:,1),edgeDat(:,5),'o');
title('dsk1/dsk2');
xlabel('sk-sk distance (nm)')
ylabel('dsk1/dsk2')

figure;
plot(edgeDat(:,1),edgeDat(:,6),'o');
title('dsk1+dsk2');
xlabel('sk-sk distance (nm)')
ylabel('dsk1 + dsk2 (nm)')

figure;
plot(edgeDat(:,1),edgeDat(:,7),'o');
title('dsk2-dsk1');
xlabel('sk-sk distance (nm)')
ylabel('dsk1 - dsk2 (nm)')