% Define the parameters
x_center = 0;
y_center = 0;
a = 1; % Semi-major axis
b = 1; % Semi-minor axis
theta = linspace(0, 4*pi, 100);
phi = pi/4; % Rotation angle (in radians)


% Parametric equations for the ellipse
x = x_center + a * cos(theta);
y = y_center + b * sin(theta);

R = [cos(phi) -sin(phi); sin(phi) cos(phi)];
rotated_coords = R * [x; y];
x_rot = rotated_coords(1, :);
y_rot = rotated_coords(2, :);


%% Plot the ellipse
close all;
figure;
k = boundary(x',y',0);
f = fill(x(k), y(k),'k');

axis equal;
axis off;
saveas(f,"D:\cluster_neuronspikes\Shape Template PNGs\circle.png")
%%
figure;
k = boundary(x_rot',y_rot',0);
f = fill(x_rot(k),y_rot(k),'k');
axis equal
axis off;
saveas(f,"D:\cluster_neuronspikes\Shape Template PNGs\Left To Right Positive Elipse.png");



%%
close all;
array_of_fp =["D:\cluster_neuronspikes\Shape Template PNGs\Horizontal Elipse.png"
"D:\cluster_neuronspikes\Shape Template PNGs\Left To Right Negative Elipse.png"
"D:\cluster_neuronspikes\Shape Template PNGs\Left To Right Positive Elipse.png"
"D:\cluster_neuronspikes\Shape Template PNGs\Vertical Elipse.png"
"D:\cluster_neuronspikes\Shape Template PNGs\circle.png"];
the_cluster_image = imread(array_of_fp(5));
grayImage = rgb2gray(the_cluster_image);
binary_image = imbinarize(grayImage);
disp("num pixels:"+string(size(binary_image)));


