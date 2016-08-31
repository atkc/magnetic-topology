function vec = distPBC2D(vec,Lx,Ly)
    % calculate vec in periodic boundary conditions

    % Calculate the half box size in each direction
    hLx = Lx/2.0;
    hLy = Ly/2.0;
    
    % Distance vector should be in the range -hLx -> hLx and -hLy -> hLy
    % Therefore, we need to apply the following changes if it's not in this range: 
    
    if vec(1) > hLx
        vec(1) = vec(1) - Lx;
    elseif vec(1) < -hLx
        vec(1) = vec(1) + Lx;
    end
    
    if vec(2) > hLy
        vec(2) = vec(2) - Ly;
    elseif vec(2) < -hLy
        vec(2) = vec(2) + Ly;
    end
    
end
    