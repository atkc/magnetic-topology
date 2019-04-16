function [ bw3 ] = chopIT( bw )
%CHOPIT Summary of this function goes here
%   Detailed explanation goes here
D = -bwdist(~bw);
%imshow(D,[])
Ld = watershed(D);
bw2 = bw;
bw2(Ld == 0) = 0;

mask = imextendedmin(D,2);
D2 = imimposemin(D,mask);
Ld2 = watershed(D2);
bw3 = bw;
bw3(Ld2 == 0) = 0;
%imshow(bw2)
end

