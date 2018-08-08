function [loc] = detectLED(vid)

[H, ~, ~, T] = size(vid);

g_vid = double(vid(:, :, 1, :)) / 255;
h = zeros(1, 1, 1, T);
h(1, 1, 1, 1:2:end) = 1;
res = convn(g_vid, h(1, 1, 1, end:-1:1), 'valid');
[~, idx] = max(res(:));
loc = [ceil(idx/H), mod(idx, H)];

end

