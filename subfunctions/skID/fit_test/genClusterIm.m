
reso=256;
len=3000;%um
full_len=13000;
sk_size_all=70:10:160;
sk_std_all=4:2:10;

for sk_size = sk_size_all
    for sk_std=sk_std_all
        genIm(full_len,len,reso,sk_size, sk_std)
    end
end