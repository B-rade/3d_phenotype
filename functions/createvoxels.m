% TODO use the sizes to generate dynamically
function voxels = createvoxels(xsize, ysize, zsize)
    
    x = -90:1:90;
    y = -90:1:90;
    z = -90:1:90;

    [X,Y,Z] = meshgrid( x, y, z );
    voxels.X = X(:);
    voxels.Y = Y(:);
    voxels.Z = Z(:);
    voxels.Value = ones(numel(X),1);

end
