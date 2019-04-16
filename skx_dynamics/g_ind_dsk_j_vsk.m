%Speed (**********only sk in motion does not include one at 0m/s) vs J
%plot and dsk

conv=13000/1080;
%[theta_cor,r_cor_fil]=cart2pol(vy_cor,-vx_cor);
p_unfil=unique(newfullstat2(:,2));

%[newfullstat2_fil,r_cor_fil,theta_cor_fil]=minDist_filter(newfullstat2,r_cor,theta_cor,fullstat2);
newfullstat2_fil=newfullstat2;
r_cor_fil=r_cor;

p=unique(newfullstat2_fil(:,2));
i1_fil=i1(ismember(p_unfil,p));
i_un=unique(abs(i1_fil));
avg_v=zeros(length(i_un),1);%zeros(floor(size(frame_list)/2));
std_v=zeros(length(i_un),1);%zeros(floor(size(frame_list)/2));


dsk_nedge=6;
dskedge=linspace(60,200,dsk_nedge);
dsk=newfullstat2_fil(:,9).*conv;
dskmid=dskedge(1:end-1)+mean(diff(dskedge))/2;

for i=1:length(i_un)
    pid_list=p(abs(i1_fil)==i_un(i));
    checki=i1_fil(abs(i1_fil)==i_un(i))
    hold_j=zeros(size(newfullstat2_fil(:,2)));
    for pid=pid_list'
        hold_j=hold_j+((newfullstat2_fil(:,2)==pid));
        sum(hold_j)
    end
    hold_j=logical(hold_j);
    for dsk_i=1:dsk_nedge-1
        hold_dsk=logical((dsk>=dskedge(dsk_i)).*(dsk<dskedge(dsk_i+1)));
        hold_all=logical(hold_dsk.*hold_j);
        avg_v(i,dsk_i)= (mean(r_cor_fil(hold_all)));
        std_v(i,dsk_i)= (std(r_cor_fil(hold_all)));
    end
    
end

F = @(x)exp(x(1)) + x(2);
figure;
hold on
for dsk_i=1:length(dskmid)
    legend_txt=num2str(dskmid(dsk_i),'%.0f nm');
    plot(i_un,avg_v(:,dsk_i),'*','DisplayName',legend_txt);
    %errorbar((i_un),(avg_v(:,dsk_i)),(std_v(:,dsk_i)),'DisplayName',legend_txt);
    
end
hold off
legend('Location','northwest');
save('g_ind_dsk_j_vsk.mat','avg_v','i_un','dskmid','dskedge')
title('d3 @ 750G (only moving skyrmions)')
xlabel('j (A/m^2)')
ylabel('v_{sk} (m/s)')
xlim([0,6e11]);
ylim([2,16]);
% i2=(abs(i1_fil));
% errorbar(i2(1:length(avg_v)),avg_v,std_v,'*r')
% xlabel('j(|A/m^2|)')
% ylabel('speed(|m/s^2|)')