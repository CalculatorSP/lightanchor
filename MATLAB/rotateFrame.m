function [frame_out] = rotateFrame(frame_in, r)

[H, W, ~] = size(frame_in);
[x, y] = meshgrid(1:W, 1:H);
x = x - W/2;
y = -(y - H/2);
rot = round(hom2cart(cart2hom([x(:) y(:)]) * r.'));
x = reshape(rot(:, 1), H, W) + W/2;
y = reshape(rot(:, 2), H, W) + H/2;
frame_out = frame_in;
for i = 1:H
    for j = 1:W
        if x(i, j) > 0 && x(i, j) <= W && y(i, j) > 0 && y(i, j) <= H
            frame_out(i, j, :) = frame_in(y(i, j), x(i, j), :);
        else
            frame_out(i, j, :) = 0;
        end
    end
end

figure; imshow(frame_in);
figure; imshow(frame_out);

end
