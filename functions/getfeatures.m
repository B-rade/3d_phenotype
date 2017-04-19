function [hull2D, biomass2D] = getfeatures(I, background)
    
    % subtract background
    I_subtract = imsubtract(background,I);
    
    % convert to gray
    I_gray = rgb2gray(I_subtract);
    
    % binarize
    I_bw = imbinarize(I_gray,.3);
    
    % cut off at pot
    I_bw(1808:end,:) = 0;
    
    % dilate to compensate for thin leaves
    se = strel('disk',5);
    I_dilate = imdilate(I_bw,se);
    se = strel('disk',3);
    I_erode = imerode(I_dilate,se);
    
    % crop to be centered on plant
    J = imcrop(I_erode, [1120, 1500, 360-1, 360-1]);
    
    % get stats
    stats = regionprops(J,'ConvexArea','Area');
    
    % find index of the plant within the "stats" object
    % this will be the index of the largest convex area
    [temp_convex_area, plant_index] = max( [stats.ConvexArea] );
    
    % find area to compute biomass
    temp_area = cat(1, stats(plant_index).Area);
    
    if ~isempty(temp_area)
        hull2D = temp_convex_area;
        biomass2D = temp_area/temp_convex_area;
    else
        hull2D = 0;
        biomass2D = NaN;
    end
end