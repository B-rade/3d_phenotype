figure
scatter3(0,0,0);

for theta = 108:36:109
    
    I = imread(strcat('images\test_',sprintf('%03d',theta),'.png'));
    

    x = [-1300 2454-1300; -1300 2454-1300];
    y = [0 0; 0 0];
    z = [0 0; 2056 2056];

    theta_rad = deg2rad(theta);
    rot = [cos(theta_rad), sin(theta_rad); -sin(theta_rad), cos(theta_rad)];
    
    x = reshape(x',4,1);
    y = reshape(y',4,1);

    xy = [x y] * rot;

    x = vec2mat(xy(:,1),2);
    y = vec2mat(xy(:,2),2);

%     x = [-1300 2454-1300; -1300 2454-1300];    
%     y = [0 0; 0 0];
    
    surface('XData',x,'YData',y,...
            'ZData',z,'CData',flip(I,1),...
            'FaceColor','texturemap','EdgeColor','none');
    alpha 0.5
    axis square;
    
end

I = imread('images\test_top.png');

x = [-1300 2454-1300; -1300 2454-1300];
y = [-2056/2 -2056/2; 2056/2 2056/2]+8;
z = [0 0; 0 0];

theta = 90;
theta_rad = deg2rad(theta);
rot = [cos(theta_rad), sin(theta_rad); -sin(theta_rad), cos(theta_rad)];

x = reshape(x',4,1);
y = reshape(y',4,1);

xy = [x y] * rot;

x = vec2mat(xy(:,1),2);
y = vec2mat(xy(:,2),2);

surface('XData',x,'YData',y,...
        'ZData',z,'CData',flip(I,1),...
        'FaceColor','texturemap','EdgeColor','none');
alpha 0.5
surface('XData',x,'YData',y,...
        'ZData',z+1000,'CData',flip(I,1),...
        'FaceColor','texturemap','EdgeColor','none');
alpha 0.5
surface('XData',x,'YData',y,...
        'ZData',z+2000,'CData',flip(I,1),...
        'FaceColor','texturemap','EdgeColor','none');
alpha 0.5