
% create voxels
voxels = createvoxels(180,180,180);

% read in background
background = imread('images\test_background.png');

% process and carve from side views
for theta = 0:36:144
    % load image
    I = imread(strcat('images\test_',sprintf('%03d',theta),'.png'));
    
    % process image to extract mask
    J = getmask(I, background);
    
    % crop to 1800 pixels, then resize to 180
    J = imcrop(J, [400, 200, 1800-1, 1800-1]);
    J = imresize(J, [180 nan]);
    
    % carve image from voxels
    voxels = carve(voxels, J, theta);
    
    figure
    scatter3(voxels.X, voxels.Y, voxels.Z);
    axis square
    set(gca,'zdir','reverse')
end


% process and carve from top image

all_points = cat(2, voxels.X, voxels.Y, voxels.Z);

DT = delaunayTriangulation(all_points);
[K,v] = convexHull(DT);

figure
scatter3(all_points(:,1),all_points(:,2),all_points(:,3));
hold on
trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','cyan');
alpha 0.2
hold off
axis square
set(gca,'zdir','reverse')

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

function mask = getmask(I, background)
    
    % subtract background
    I_subtract = imsubtract(background,I);
    
    % convert to gray
    I_gray = rgb2gray(I_subtract);
    
    % binarize
    I_bw = imbinarize(I_gray,.40);
    
    % dilate to compensate for thin leaves
    se = strel('disk',4);
    I_dilate = imdilate(I_bw,se);
    
    mask = I_dilate;
    
end