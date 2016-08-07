function m_sup1_GenHexImage( Psize, dist )

    m=Psize(1);
    n=Psize(2);
    hexPTs=hexagonalGrid([0 0 m n],[m/2 n/2],dist);
    whiteImage = 255 * ones(m, n, 'uint8');
    size(hexPTs)
    for i = 1:length(hexPTs)
        whiteImage(round(hexPTs(i,1)),round(hexPTs(i,2)))=false;
    end
    
    whiteImageLog=logical(whiteImage);
    imshow(whiteImageLog);
    imwrite(whiteImageLog,'reconstruct_original_ideal.png','png');
    save('isofit_ideal.mat','hexPTs');
end

