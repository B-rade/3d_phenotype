function mask = getmask(I, background)
    
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
    
    mask = I_erode;
    
end