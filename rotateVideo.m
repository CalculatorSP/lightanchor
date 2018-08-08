function [vid] = rotateVideo(vid, r)

[~, ~, ~, T] = size(vid);

for t = 1:T
    vid(:, :, :, t) = rotateFrame(vid(:, : ,:, t), r(:, :, t));
end

end

function [frame] = rotateFrame(frame, r)

[H, W, C] = size(frame);
[x, y] = meshgrid(1:H, 1:W);
rot = round(hom2cart(cart2hom(x(:), y(:)) * r.'));

end
