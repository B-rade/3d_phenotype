addpath('functions');

% create voxels
voxels = createvoxels(180,180,180);

% read in background
ibackground = 'test images\test_background.png';

background = imread(ibackground);

% process and carve from side views
for theta = 0:36:144
    % load image
    I = imread(strcat('test images\test_',sprintf('%03d',theta),'.png'));
    
    % process image to extract mask
    J = getmask(I, background);
    
    % crop to 1800 pixels, then resize to 180
    J = imcrop(J, [400, 200, 1800-1, 1800-1]);
    J = imresize(J, [180 nan]);
    
    % carve image from voxels
    voxels = carve(voxels, J, theta);
    
    figure
    scatter3(voxels.X, voxels.Y, voxels.Z,'s','MarkerEdgeColor','k','MarkerFaceColor','g');
    axis square
    set(gca,'zdir','reverse')
end

% TODO process and carve from top image

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



