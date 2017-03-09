% declare variables
all_points = [];
gen_images = 0;

% read in background image
background = imread('images/test_background.png');

% read in images
for theta = 0:36:144
    I = imread(strcat('images\test_',sprintf('%03d',theta),'.png'));
    
    % subtract background
    I_subtract = imsubtract(background,I);
    
    % convert to gray
    I_gray = rgb2gray(I_subtract);
    
    % binarize
    I_bw = imbinarize(I_gray,.45);
    
    % dilate to compensate for thin leaves
    se = strel('disk',7);
    I_dilate = imdilate(I_bw,se);
    
    % compute region props
    stats = regionprops(I_dilate,'ConvexArea','ConvexHull');
    
    % find largest convex area region (this is the plant)
    % b/c some images have artifacts at the edges
    [temp,plant_index] = max( [stats.ConvexArea] );
    
    % find convex hull
    convex_hull = cat(1, stats(plant_index).ConvexHull);
    
    % rotations to get convex-hull in 3d coordinates
    % data comes as x-y points, (0,0) is in the top-left corner of the image
    % y-coordinate (height) stays the same,
    % as the x-coordinate is transferred to the x-z plane based on
    % the rotation angle.
    % 
    % also plant rotates around the center of the bucket @ 1300 x-pixel
    % and flip y-coordinate so it displays in the proper orientation
    x = convex_hull(:,1) - 1300;
    y = -convex_hull(:,2);
    z = zeros(size(x));
    
    theta_rad = deg2rad(theta);
    
    rot = [cos(theta_rad), sin(theta_rad); -sin(theta_rad), cos(theta_rad)]; 
    
    xz = [x, z] * rot;
    
    x = xz(:,1);
    z = xz(:,2);
    
    % swap coordinates to traditional xyz coordinates where z is
    % the height
    all_points = [all_points; x -z y];
    
    % show images for debugging purposes
    if gen_images
        figure, imshow(I_subtract,'initialMagnification',30);
        figure, imshow(I_bw,'initialMagnification',30);
        figure, imshow(I_dilate,'initialMagnification',30);
        
        % plot convex hull to verify accuracy
        figure, imshow(I,'initialMagnification',30);
        title(strcat('Angle ',sprintf('%d',theta)));
        hold on
        plot(convex_hull(:,1),convex_hull(:,2),'color','y','LineWidth', 2);
        hold off    
        
        figure
        scatter3(all_points(:,1),all_points(:,2),all_points(:,3));
    end
    
    

    
end

% compute the 3d convex-hull by makes a delaunay Triangulation
% and then using matlabs convexhull function
DT = delaunayTriangulation(all_points);
[K,v] = convexHull(DT);

figure
scatter3(all_points(:,1),all_points(:,2),all_points(:,3));
hold on
trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3),'FaceColor','cyan');
alpha 0.2
axis square
hold off