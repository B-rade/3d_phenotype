addpath('functions');

% create voxels
voxels = createvoxels(180,180,180);

% read in background
ibackground = 'images\day_01\Vis_SV_0\0_0_0.png';

background = imread(ibackground);

for day = 1:20
  
    % create voxels
    voxels = createvoxels(180,180,180);
    
    % process and carve from side views
    for theta = 0:36:144
        % load image
        I = imread(strcat('images\day_',sprintf('%02d',day),'\Vis_SV_',sprintf('%d',theta),'\0_0_0.png'));

        % process image to extract mask
        J = getmask(I, background);
        
        % crop to 1800 pixels, then resize to 180
        J = imcrop(J, [1120, 1500, 360-1, 360-1]);
        J = imresize(J, [180 nan]);
        
        % carve image from voxels
        voxels = carve(voxels, J, theta);

%         figure
%         scatter3(voxels.X, voxels.Y, voxels.Z,'s','MarkerEdgeColor','k','MarkerFaceColor','g');
%         t = strcat('Volume after ',sprintf('%d',theta/36+1),' carvings');
%         title(t);
%         axis square
%         set(gca,'zdir','reverse')
    end

    % combine voxel data into point cloud
    all_points = cat(2, voxels.X, voxels.Y, voxels.Z);

    % compute convex hull
    if numel(all_points) > 0
        DT = delaunayTriangulation(all_points);
        [K,v] = convexHull(DT);
    else
        v = 0;
    end
    
    % keep track of biomass and convex volume
    biomass(day) = numel(voxels.X);
    convex_volume(day) = v;
    
    % plot the 3D scatter plot
    figure
    scatter3(voxels.X, voxels.Y, voxels.Z,'s','MarkerEdgeColor','k','MarkerFaceColor','g');
    t = strcat('Day ',sprintf('%d',day),' voxels');
    title(t);
    axis square
    set(gca,'zdir','reverse')
    
end

% plot convex volume
figure
plot(1:20, convex_volume);
title('Convex Volume vs. Time');
xlabel('Days');
ylabel('Convex Volume');

% plot biomass
figure
plot(1:20, biomass);
title('Biomass Volume vs. Time');
xlabel('Days');
ylabel('Biomass');

% figure
% scatter3(all_points(:,1),all_points(:,2),all_points(:,3));
% hold on
% trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','cyan');
% alpha 0.2
% hold off
% axis square
% set(gca,'zdir','reverse')



