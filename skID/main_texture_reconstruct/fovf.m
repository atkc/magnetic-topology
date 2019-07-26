function [ mx my mz ] = fovf( filename)
fileA=fopen(filename,'r');

linea=fgetl(fileA);
%Input Info:
%1. filename - -Input ovf file
%   Input ovf file - usually specified with headers at the top and 3
%   columns of magnetization components. 

%Output info:
% 1. magMat(gridx,gridy,layer,component) returns the gridx x gridy grid of a 
% particular layer and magnetization component of entire stack.
% 2. key returns a unique key that indicatges if information from file is
% processed correctly. The file is correctly process only if unique key
% retutns 1234567

%Output(Input) arguments:
% 1. gridx(y) - grid size in x (y) direction. 
%   grid size in x(y) specified as an integer. gridx (y) ranges from 1 to
%   the number of xnodes (ynodes)
% 2. layer - Layer number
%   Layer number specified as an integer. Layer number ranges from 1 to the
%   maximum number of znodes of ovf
% 3. Component - Magnetization component
%   Magnetization component specified as an integer. 1 - Mx, 2 - My, 3 - Mz


%%%%%%%%%%%%Getting the necessary header info on ovf file%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while isempty(strfind(linea,'# Begin: Data Text'))&&isempty(strfind(linea,'# Begin: Data Binary 4'))
    %The headers ends when the line # Begin: Data Text appears    
    %isempty(strfind(linea,'# Begin: Data Text'))||isempty(strfind(linea,'# Begin: Data Binary 4'))
    %%%%%%%%%%%%%%%%%%%%%%%% Each one of these is going to look for some
    %%%%%%%%%%%%%%%%%%%%%%%% information on the header. This one for the
    %%%%%%%%%%%%%%%%%%%%%%%% applied field
    if isempty(strfind(linea,'# Desc: Applied field (T):'))~=1        
        remain = linea;
        while true
            [str, remain] = strtok(remain);
            if strcmp(str,'(T):')==1
                [str, remain] = strtok(remain);
                data.field(1)=  str2num(str);
                [str, remain] = strtok(remain);
                data.field(2)=  str2num(str);
                [str, remain] = strtok(remain);
                data.field(3)=  str2num(str);
            end
            if isempty(str),  break;  end            
        end        
    end
    %%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%This one is for the simulation grid,
    %%%%%%%%%%%%%%%%%%%%%%%%for the number of nodes on x
    if isempty(strfind(linea,'# xnodes'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.xnodes=  str2num(str);       
    end    
    %%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%Number of nodes on y
    if isempty(strfind(linea,'# ynodes'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.ynodes=  str2num(str);        
    end    
    %%%%%%%%%%%%%%%%%%    
    
    %%%%%%%%%%%%%%%%%%%%%%%%Number of nodes on z
    if isempty(strfind(linea,'# znodes'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.znodes=  str2num(str);        
    end    
    %%%%%%%%%%%%%%%%%%    
    
    %%%%%%%%%%%%%%%%%%%%%%%%Now the min and maximum values of x y and z
    if isempty(strfind(linea,'# xmin:'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.xmin=  str2num(str);        
    end    
    %%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(strfind(linea,'# ymin:'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.ymin=  str2num(str);
    end    
    %%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(strfind(linea,'# zmin:'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.zmin=  str2num(str);       
    end    
    %%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(strfind(linea,'# xmax:'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);        
        data.xmax=  str2num(str);         
    end    
    %%%%%%%%%%%%%%%%%%   
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(strfind(linea,'# ymax:'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.ymax=  str2num(str);        
    end    
    %%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%
    if isempty(strfind(linea,'# zmax:'))~=1        
        remain = linea;        
        [~, remain] = strtok(remain);
        [~, remain] = strtok(remain);
        [str, ~] = strtok(remain);
        data.zmax=  str2num(str);        
    end    
    %%%%%%Identifyer to line after header info%%%%%%%%%%%%%%    
    linea=fgetl(fileA);
end

bin4=true;

if isempty(strfind(linea,'# Begin: Data Binary 4'))
    bin4=false;
end
%%%%%%%%%%%%Read remaining data as Binary 4%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%Assumes file type is binary 4 type%%%%%%%%%%%%%%%%%%%

% linea=fgetl(fileA);
% B=fread(fileA,'char');


gridsizey=data.ynodes;
gridsizex=data.xnodes;
gridsizez=data.znodes;
magMat=zeros(gridsizex,gridsizey,gridsizez);

% [mag,~] = vec2mat(data,600);
if bin4
    B=fread(fileA,'float');
%     z=B{3};
%     mz=reshape(z,gridsizex,gridsizey,gridsizez);
    key=B(1);
    datam=B(2:gridsizex*gridsizey*gridsizez*3+2);
    %disp(gridsizex*gridsizey*gridsizez*3+3);
    for z=1:gridsizez
        for y=1:gridsizey
            for x=1:gridsizex
                %disp(strcat(int2str(x),',',int2str(y),',',int2str(z)));
                %magMat(x,y,z,1)=datam(uint64((x-1)*gridsizey*gridsizex*3+200*3*(z-1)+3*(y-1)+1));
                %magMat(x,y,z,2)=datam(uint64((x-1)*gridsizey*gridsizex*3+200*3*(z-1)+3*(y-1)+2));
                %magMat(x,y,z,3)=datam(uint64((x-1)*gridsizey*gridsizex*3+200*3*(z-1)+3*(y-1)+3));
                %disp(uint64((z-1)*gridsizey*gridsizex*3+200*3*(x-1)+3*(y-1)+3));
                magMatX(x,y,z)=datam(uint64((z-1)*gridsizey*gridsizex*3+3*(x-1)+3*gridsizex*(y-1)+1));
                magMatY(x,y,z)=datam(uint64((z-1)*gridsizey*gridsizex*3+3*(x-1)+3*gridsizex*(y-1)+2));
                magMatZ(x,y,z)=datam(uint64((z-1)*gridsizey*gridsizex*3+3*(x-1)+3*gridsizex*(y-1)+3));
                %endi=uint64((l-1)*3*gridsizey*gridsizex+200*3*(i-1)+3*(j-1)+3);
                
            end
        end
    end
    mz=magMatZ;
    mx=magMatX;
    my=magMatY;
    
else %%for data text
    %disp('textscan')
    s=textscan(fileA,'%n %n %n');
    x=s{1};
    y=s{2};
    z=s{3};
    size(z);
    mz=reshape(z,gridsizex,gridsizey,gridsizez);
    mx=reshape(x,gridsizex,gridsizey,gridsizez);
    my=reshape(y,gridsizex,gridsizey,gridsizez);
    mz=fliplr(rot90((mz),3));
    mx=fliplr(rot90((mx),3));
    my=fliplr(rot90((my),3));
end
%imshow(magMat(:,:,1,3));% ,[min(min(magMat(:,:,1,1))),max(max(magMat(:,:,1,1)))])
%endi
fclose(fileA);


%%plotting
% [X,Y]=meshgrid(1:gridsizex,1:gridsizey);
% Z=zeros(gridsizex,gridsizey);
% magD=magMat;
% figure
% magD=(magD-min(min(min(min(magD)))))/(max(max(max(max(magD))))-min(min(min(min(magD)))));
% for l=1:gridsizez;
% U=magD(:,:,l,1);
% V=magD(:,:,l,2);
% W=magD(:,:,l,3);
% subplot(5,5,l)
% imshow(W);
% colormap('jet');
% title(strcat('layer',int2str(l)));


end
