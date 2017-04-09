function voxels = carve(voxels, mask, theta)
    
    % define the transformation matrix
    T = [cosd(theta) sind(theta); -sind(theta) cosd(theta)];
    
    % project the World coordinates to the image coordinates
    % World X -> Image u
    % World Z -> Image v
    % World Y -> lost to the great abyss
    xy = [voxels.X voxels.Y] * T;
    x = xy(:,1);
    z = voxels.Z;
    
    RA = imref2d(size(mask), [-90 90], [-90 90]);
    [u, v] = worldToSubscript(RA, x, z);
    
    % Clear any that are out of the image (below 160 is the pot) 
    [h,w,~] = size(mask); % #ok<NASGU>
    keep = find( (v>=1) & (v<=180) & (u<=160) );
    u = u(keep);
    v = v(keep);
    
    % Now clear any that are not inside the silhouette
    ind = sub2ind( [h,w], u, v);
    keep = keep(mask(ind) >= 1);
    
    voxels.X = voxels.X(keep);
    voxels.Y = voxels.Y(keep);
    voxels.Z = voxels.Z(keep);
    voxels.Value = voxels.Value(keep);

end

