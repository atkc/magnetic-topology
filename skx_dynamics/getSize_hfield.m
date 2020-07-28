hrange=[750 1050 1370 1650];
h_file{1}='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180412-1_fp553_1b_d2_2um_n4k-p750\analysis_750\CTF';
h_file{2}='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180411-1a_fp553_1b_d2_2um_n4k-p1050\analysis_1050\TF';
h_file{3}='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180408-3_fp553_1b_d2_2um_n4k-p1370\analysis\CTF';
h_file{4}='C:\Users\ant_t\Dropbox\shared_mfm\Data\Nanostructures\fp553_nanostructures\180410-4_fp553_1b_d2_2um_n4k-p1650\CTF\registered';

loadmode=[1,1,2,2];

conv=13000/1080; %estimated nm/px
p_width=20;
c1=conv*10^-9/(p_width*10^-9);%m/s

avgsize=zeros(size(hrange));
stdsize=zeros(size(hrange));

for h_i=1:length(hrange)
    folder= h_file{h_i};
    cd(folder)

    if loadmode(h_i)==1
        load('fullstat2-size-combine.mat');
        sksize=newfullstat2(:,9)*conv;
    else
        load('newMasterList.mat');
        sksize=newMasterList(:,:,4);
        sksize=sksize(:);
        sksize(sksize==0)=[];
        sksize=sksize*conv;
    end
    sksize(sksize<60)=[];
    sksize(sksize>200)=[];
    avgsize(h_i)=mean(sksize);
    stdsize(h_i)=std(sksize);
end

errorbar(hrange,avgsize,stdsize)