function [loc] = detectLED(vid)

h = zeros(1, 1, 1, size(vid, 4));
h(1, 1, 1, 1:2:end) = 255;
res = convn(vid, h(1, 1, 1, end:-1:1), 'valid');
[~, idx] = max(res(:));
loc = [ceil(idx/size(vid, 1)), mod(idx, size(vid, 1))];

end

