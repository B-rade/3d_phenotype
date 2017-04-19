imtool(imread('images\day_20\Vis_SV_0\0_0_0.png'));

imtool(imread('images\day_20\Vis_SV_72\0_0_0.png'));

addpath('functions');
voxels = createvoxels(180,180,180);


figure
scatter3(voxels.X, voxels.Y, voxels.Z,'s','MarkerEdgeColor','k','MarkerFaceColor','g');
axis square

zoom(.5)