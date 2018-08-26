function [loc] = detectLED(vid)

[H, ~, ~, T] = size(vid);

% Get red channel of video and convert to 1-channel double
g_vid = double(vid(:, :, 1, :)) / 255;

% Generate template signal
h = zeros(1, 1, 1, T);
h(1, 1, 1, 1:2:end) = 1;

% Sum of squared differences
% res = 2 * convn(g_vid, h(1, 1, 1, end:-1:1), 'valid') - sum(g_vid.^2, 4);

% Normalized ssd
% h = (h - mean(h, 4)) / std(h, 4);
% g_vid = (gvid - mean(gvid, 4)) / std(gvid, 4);
% res = convn(gvid, h(1, 1, 1, end:-1:1), 'valid');

% Cross-correlation
% res = 2 * convn(g_vid, h(1, 1, 1, end:-1:1), 'valid') - sum(g_vid.^2, 4);

% Normalized cc
h = (h - mean(h, 4)) ./ std(h, 0, 4);
g_vid = (g_vid - mean(g_vid, 4)) ./ std(g_vid, 0, 4);
res = convn(g_vid, h(1, 1, 1, end:-1:1), 'valid');

% Find max
[maxval, maxidx] = max(res(:));
[minval, ~] = min(res(:));
res = (res - minval) ./ (maxval - minval);
res = cat(3, 0*res, 0*res, res);
res(maxidx) = 1;
figure; imshow(res);
loc = [mod(maxidx - 1, H) + 1, floor((maxidx - 1) / H) + 1];

end

