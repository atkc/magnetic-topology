function varargout = s1_GenHexImage( Psize, dist, dvar )
%     dvar (%)
%     m=Psize(1);
%     n=Psize(2);
    dvardist=dvar*dist;
    [m,n]=size(Psize);
    [hexPTs,~]=hexagonalGrid([0 0 m n],[m/2 n/2],dist);
    whiteImage = 255 * ones(m, n, 'uint8');
    size(hexPTs)
    
    for i = 1:length(hexPTs)
        hexPTs(i,1)=round(hexPTs(i,1)-dvardist+2*dvardist*rand);
        hexPTs(i,2)=round(hexPTs(i,2)-dvardist+2*dvardist*rand);
        if (hexPTs(i,1)>0)&&(hexPTs(i,2)>0)&&(hexPTs(i,1)<m)&&(hexPTs(i,2)<n)
            whiteImage(hexPTs(i,1),hexPTs(i,2))=false;
        end
        
    end
    
    whiteImageLog=logical(whiteImage);
    imshow(whiteImageLog);
    
    imwrite(whiteImageLog,strcat('reconstruct_lattice_',int2str(dvar*100),'.png'),'png');
    %save('isofit_ideal.mat','hexPTs');
    
    if nargout>0
    varargout{1} = hexPTs;
    
        if nargout>1
            varargout{2} = whiteImageLog;
        end
    end
    
end

