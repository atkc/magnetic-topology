function [colm] = colormixer(colmap,m)

[Ncol,~]=size(colmap);


seg_l=round(m/(Ncol-1));
colm=zeros([m,3]);
    for colind=2:(Ncol)
        r_seg=linspace(colmap(colind-1,1),colmap(colind,1),seg_l);
        g_seg=linspace(colmap(colind-1,2),colmap(colind,2),seg_l);
        b_seg=linspace(colmap(colind-1,3),colmap(colind,3),seg_l);
        rgb_seg=[r_seg',g_seg',b_seg'];
        colm((colind-2)*seg_l+1:(colind-1)*seg_l,:)=rgb_seg;
    end

colm=colm/256;

end

