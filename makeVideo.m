% CAMERA-SPECIFIC SETUP
FOV = 60 * pi / 180;
FW = 1280;
FH = 720;
[px, py] = meshgrid(1:FW, 1:FH);
p = [px(:) - FW / 2, -(py(:) - FH / 2), -hypot(FW, FH) / 2 * cot(FOV / 2) * ones(FW * FH, 1)];

% PANORAMA-SPECIFIC SETUP
IMFILE = 'morning.png';
I = imread(IMFILE);
[H, W, C] = size(I);

% Apply rotation matrix to p
R = [1 0 0; 0 cosd(90) -sind(90); 0 sind(90) cosd(90)];
rp = p * R.';

% Generate panorama coordinates
stheta = round(W * (pi - atan2(rp(:,2), rp(:,1))) / (2 * pi));                      % 0 to W (left to left, cw looking down)
sphi = round(H * acos(rp(:,3) ./ sqrt(rp(:,1).^2 + rp(:,2).^2 + rp(:,3).^2)) / pi); % 0 to H (north pole to south pole)
stheta(stheta < 1) = 1;
stheta(stheta > W) = W;
sphi(sphi < 1) = 1;
sphi(sphi > H) = H;

% Build the frame by reading panorama memory
indices = H * (stheta - 1) + sphi;
R = I(indices);
G = I(H * W + indices);
B = I(2 * H * W + indices);
J = reshape([R, G, B], FH, FW, C);

figure; imshow(I);
figure; imshow(J);

