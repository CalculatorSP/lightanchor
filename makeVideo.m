% CAMERA-SPECIFIC SETUP
FOV = 60 * pi / 180;
FW = 1280;
FH = 720;

V = 2 * tan(FOV / 2) / hypot(FW, FH);

[px, py] = meshgrid(1:FW, 1:FH);
x = px - FW / 2;
y = -(py - FH / 2);
d = hypot(x, y);
phi = atan2(y, x);              % -pi to pi (left to left, ccw looking down)
theta = atan(V * d) - pi / 2;   % -pi / 2 to 0 (south pole to equator)
r = ones(size(px));

% PANORAMA-SPECIFIC SETUP
IMFILE = 'morning.png';
I = imread(IMFILE);
figure;
imshow(I);

[H, W, C] = size(I);
sphi = round(W * (pi - phi) / (2 * pi));            % 0 to W (left to left, cw looking down)
stheta = round(H * (pi - 2 * theta) / (2 * pi));    % H / 2 to H (equator to south pole)
sphi(sphi < 1) = 1;
sphi(sphi > W) = W;
stheta(stheta < 1) = 1;
stheta(stheta > H) = H;

indices = H * (sphi - 1) + stheta;
R = I(indices);
G = I(H * W + indices);
B = I(2 * H * W + indices);
J = reshape([R, G, B], FH, FW, C);

figure;
imshow(J);

