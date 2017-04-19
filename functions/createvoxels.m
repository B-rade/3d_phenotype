function voxels = createvoxels(xsize, ysize, zsize)
    
    x = -xsize/2:1:xsize/2;
    y = -ysize/2:1:ysize/2;
    z = -zsize/2:1:zsize/2;

    [X,Y,Z] = meshgrid( x, y, z );
    voxels.X = X(:);
    voxels.Y = Y(:);
    voxels.Z = Z(:);
    voxels.Value = ones(numel(X),1);

end
