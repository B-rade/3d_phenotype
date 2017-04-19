addpath('functions');

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

        % process image to extract 2D features
        [hull_2D, biomass_2D] = getfeatures(I, background);
        
        % keep track of data from each angle and for each day
        results_hull_2D(day, theta/36 + 1) = hull_2D;
        results_biomass_2D(day, theta/36 + 1) = biomass_2D;
        
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
    results_biomass_3D(day) = numel(voxels.X) / v;
    results_hull_3D(day) = v;
    
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
plot(1:20, results_hull_3D);
title('Convex Volume vs. Time');
xlabel('Days');
ylabel('Convex Volume');
xlim([0, 20]);

% plot biomass
figure
plot(1:20, results_biomass_3D);
title('Biomass Volume vs. Time');
xlabel('Days');
ylabel('Biomass');
axis([0 20 0 .6])

% set up comparison between 2D data and 3D data
% we need to normalize the data because one is in area and one is in volume
% 
% divide the 2D data by the max values for convex hull and biomass for 
% all views and all days
norm_hull_2D = results_hull_2D / max(results_hull_2D(:));
norm_biomass_2D = results_biomass_2D / max(results_biomass_2D(:));

% divide the 3D data by the max values for convex hull and biomass for 
% all days
norm_hull_3D = results_hull_3D / max(results_hull_3D(:));
norm_biomass_3D = results_biomass_3D / max(results_biomass_3D(:));

figure
plot(1:20,norm_hull_3D,'LineWidth',2);
hold on
for i=1:5
    plot(1:20,norm_hull_2D(:,i));
end
hold off
labels = {'3D Convex Hull', ...
    '2D Convex Hull: 0','2D Convex Hull: 36', ...
    '2D Convex Hull: 72','2D Convex Hull: 108', ...
    '2D Convex Hull: 144'};
legend(labels,'location','best');
title('Normalized Convex Area');
xlabel('Days');
ylabel('Normalized Convex Area');

figure
plot(1:20,norm_biomass_3D,'LineWidth',2);
hold on
for i=1:5
    plot(1:20,norm_biomass_2D(:,i));
end
hold off
labels = {'3D Biomass', ...
    '2D Biomass: 0','2D Biomass: 36', ...
    '2D Biomass: 72','2D Biomass: 108', ...
    '2D Biomass: 144'};
legend(labels,'location','best');
axis([1 20 0 1]);
title('Normalized Plant Biomass');
xlabel('Days');
ylabel('Normalized Plant Biomass');
xlim([0 20]);


figure
scatter3(all_points(:,1),all_points(:,2),all_points(:,3));
hold on
trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','cyan');
alpha 0.2
hold off
axis square
set(gca,'zdir','reverse')
title('Convex Hull');



