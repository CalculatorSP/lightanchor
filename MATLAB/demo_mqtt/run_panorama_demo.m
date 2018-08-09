function run_panorama_demo()

close all;

rot = eye(3);
new = true;

% CAMERA-SPECIFIC SETUP
FOV = 60 * pi / 180;
FW = 640;
FH = 480;
[px, py] = meshgrid(1:FW, 1:FH);
p = [px(:) - FW / 2, -(py(:) - FH / 2), -hypot(FW, FH) / 2 * cot(FOV / 2) * ones(FW * FH, 1)];
p = p * [1 0 0; 0 cosd(90) -sind(90); 0 sind(90) cosd(90)].';

% PANORAMA-SPECIFIC SETUP
IMFILE = 'morning.png';
I = imread(IMFILE);
[H, W, C] = size(I);

% figure; imshow(I);

myMQTT = mqtt('tcp://johnpi.local', 'Port', 1883);
vio_mud = myMQTT.subscribe('topic/vio_mud');
vio_mud.Callback = @(topic, msg) vio_mud_func(topic, msg);

disp('Connected.');

figure;
set(gca, 'xlimmode','manual',...
'ylimmode','manual',...
'zlimmode','manual',...
'climmode','manual',...
'alimmode','manual');

% Apply rotation matrix to p
rp = p * rot.';

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
dispImg = imshow(reshape([R, G, B], FH, FW, C));
while (true)
    pause(.001);
    if new
        % Apply rotation matrix to p
        rp = p * rot.';

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
        dispImg.CData = reshape([R, G, B], FH, FW, C);
        
        new = false;
    end
end

myMQTT.disconnect();

function vio_mud_func(~,msg)
    vio = sscanf(msg,'%f,%f,%f,%f,%f,%f,%f');
    if length(vio) == 7
        v = [vio(6),-vio(7),vio(5)];
        rot = eul2rotm(v, 'ZYX');
        new = true;
    end
end

end
