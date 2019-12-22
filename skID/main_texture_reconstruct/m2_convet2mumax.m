ovf_filename='34e_2048x2048nm_leftneel_50nm.ovf';
sim_size=256;
sim_height=256;
mag_mat=zeros([sim_size*sim_size*sim_height,3]);

getl=256;
[mn,mm]=size(imz);
magx=imx;%(floor(mn/2-getl/2):floor(mn/2+getl/2),floor(mm/2-getl/2):floor(mm/2+getl/2));
magy=imy;%(floor(mn/2-getl/2):floor(mn/2+getl/2),floor(mm/2-getl/2):floor(mm/2+getl/2));
magz=imz;%(floor(mn/2-getl/2):floor(mn/2+getl/2),floor(mm/2-getl/2):floor(mm/2+getl/2));

magx = imresize(magx,[sim_size,sim_size]);
magy = imresize(magy,[sim_size,sim_size]);
magz = imresize(magz,[sim_size,sim_size]);

act_mat=[reshape(rot90(fliplr(magx)),sim_size*sim_size,1),reshape(rot90(fliplr(magy)),sim_size*sim_size,1),reshape(rot90(fliplr(magz)),sim_size*sim_size,1)];
act_mat_l=sim_size*sim_size;
for coli=0:3:9
    mag_mat((coli)*act_mat_l+1:((coli)*act_mat_l+act_mat_l),:)=act_mat;
end

%dlmwrite('mag_mat.txt',mag_mat,' ')

ovfhead=["#"    "OOMMF:"               "rectangular"               "mesh"    "v1.0"    ""...
    "#"    "Segment"              "count:"                    "1"       ""        "" ...
    "#"    "Begin:"               "Segment"                   ""        ""        "" ...
    "#"    "Begin:"               "Header"                    ""        ""        "" ...
    "#"    "Desc:"                "Time"                      "(s)"     ":"       "0"...
    "#"    "Title:"               "m"                         ""        ""        "" ...
    "#"    "meshtype:"            "rectangular"               ""        ""        "" ...
    "#"    "meshunit:"            "m"                         ""        ""        "" ...
    "#"    "xbase:"               "4e-09"                     ""        ""        "" ...
    "#"    "ybase:"               "4e-09"                     ""        ""        "" ...
    "#"    "zbase:"               "5e-10"                     ""        ""        "" ...
    "#"    "xstepsize:"           "8e-08"                     ""        ""        "" ...
    "#"    "ystepsize:"           "8e-08"                     ""        ""        "" ...
    "#"    "zstepsize:"           "1e-09"                     ""        ""        "" ...
    "#"    "xmin:"                "0"                         ""        ""        "" ...
    "#"    "ymin:"                "0"                         ""        ""        "" ...
    "#"    "zmin:"                "0"                         ""        ""        "" ...
    "#"    "xmax:"                "2.048e-06"                 ""        ""        "" ...
    "#"    "ymax:"                "2.048e-06"                 ""        ""        "" ...
    "#"    "zmax:"                "1.000e-07"                 ""        ""        "" ...
    "#"    "xnodes:"              "256"                       ""        ""        "" ...
    "#"    "ynodes:"              "256"                       ""        ""        "" ...
    "#"    "znodes:"              "100"                       ""        ""        "" ...
    "#"    "ValueRangeMinMag:"    "1e-08"                     ""        ""        "" ...
    "#"    "ValueRangeMaxMag:"    "1"                         ""        ""        "" ...
    "#"    "valueunit:"           ""                          ""        ""        "" ...
    "#"    "valuemultiplier:"     "1"                         ""        ""        "" ...
    "#"    "End:"                 "Header"                    ""        ""        "" ...
    "#"    "Begin:"               "Data"                      "Text"    ""        "" ];

ovftail=["#" "End:" "Data Text"...
"#" "End:" "Segment"];

fileID = fopen(ovf_filename,'w+');
fprintf(fileID,'%s %s %s %s %s%s\n',ovfhead);
fprintf(fileID,'%.2f %.2f %.2f\n',mag_mat');
fprintf(fileID,'%s %s %s \n%s %s %s\n',ovftail);
fclose('all')