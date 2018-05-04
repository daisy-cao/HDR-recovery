function [ weights ] = radianceWeights1(g)

weights = zeros(256, 1);
g2 = diff(g) + 0.1;
for i = 1 :255
    weights(i) = g2(i);
end
weights(256) = g2(255);

weights = weights + 1;