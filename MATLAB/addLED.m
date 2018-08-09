function [vid] = addLED(vid, pos, color)

for chan = 1:numel(color)
    vid(pos(1), pos(2), chan, 1:2:end) = color(chan);
end

end

