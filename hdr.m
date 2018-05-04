
% images = {'D:\520\project\memorial0061.png','D:\520\project\memorial0062.png','D:\520\project\memorial0063.png', 'D:\520\project\memorial0064.png',  'D:\520\project\memorial0065.png',  'D:\520\project\memorial0066.png',  'D:\520\project\memorial0067.png'};
% images = {'D:\520\project\figures\yu\DSC_1809.jpg', 'D:\520\project\figures\yu\DSC_1810.jpg'};
% images = {'D:\520\project\figures\yu\DSC_1796.jpg', 'D:\520\project\figures\yu\DSC_1797.jpg','D:\520\project\figures\yu\DSC_1799.jpg', 'D:\520\project\figures\yu\DSC_1801.jpg', 'D:\520\project\figures\yu\DSC_1804.jpg'};
% images = {'D:\520\project\figures\room_1.jpg', 'D:\520\project\figures\room_1_15.jpg'};
% images = {'D:\520\project\figures\DSC_1825.jpg', 'D:\520\project\figures\DSC_1826.jpg', 'D:\520\project\figures\DSC_1827.jpg', 'D:\520\project\figures\DSC_1828.jpg', 'D:\520\project\figures\DSC_1829.jpg', 'D:\520\project\figures\DSC_1830.jpg', 'D:\520\project\figures\DSC_1831.jpg', 'D:\520\project\figures\DSC_1832.jpg', 'D:\520\project\figures\DSC_1833.jpg', 'D:\520\project\figures\DSC_1834.jpg'};
images = {'D:\520\project\figures\DSC_1813.jpg', 'D:\520\project\figures\DSC_1814.jpg', 'D:\520\project\figures\DSC_1815.jpg', 'D:\520\project\figures\DSC_1816.jpg', 'D:\520\project\figures\DSC_1817.jpg', 'D:\520\project\figures\DSC_1818.jpg', 'D:\520\project\figures\DSC_1819.jpg', 'D:\520\project\figures\DSC_1820.jpg', 'D:\520\project\figures\DSC_1821.jpg', 'D:\520\project\figures\DSC_1822.jpg'};
% height = 2000;
% width = 2292;
[height, width, col] = size(imread(images{1}));
[~, num] = size(images);
% num = 5;

I2 = zeros(height, width, 3, num);
sigmar = 40;
eps    = 1e-3;
sigmas = 3;

for i = 1 : num
    tmp = imread(images{i});
%     crop_img = zeros(height, width, 3);
%     for x = 1 : height
%         for y = 1 : width
%             for c = 1 : 3
%                 crop_img(x, y, c) = tmp(x, y, c);
%             end
%         end
%     end
%      flt = zeros(height, width, 3);
%      for c = 1 : 3
%          [flt(:, :, c),Ng] = GPA(tmp(:, :, c), sigmar, sigmas, eps, 'Gauss');
%      end
     I2(:, :, :, i) = uint8(tmp);
    
end

Z = zeros(60, num, 3);

%  RGB channel
 for i = 1 : 3
    for j = 1 : 60 %number of points selected
        x = randi([1, height]);
        y = randi([1, width]);
        for m = 1 : num
            Z(j, m, i) = I2(x, y, i, m);
        end
    end
 end

w = zeros(256, 1);
for z = 0 : 255
    if z <= 0.5*255
        w(z + 1) = z;
    else
        w(z + 1) = 255 - z;
    end
end

% B = [log(1/0.03125), log(1/0.0625), log(1/0.125), log(1/0.25), log(1/0.5), log(1), log(1/2), log(1/4), log(1/8), log(1/16), log(1/32), log(1/64), log(1/128), log(1/256), log(1/512), log(1/1024)];
% B2 = [log(2), log(1), log(1/4), log(1/8), log(1/250), log(1/4000)];
% B = [log(1), log(1/1000)];
% B = [log(5), log(3), log(1), log(1/2), log(1/50), log(1/100), log(1/500), log(1/1000), log(1/2500), log(1/4000)];
B = [log(3), log(2), log(1), log(1/2), log(1/10), log(1/50), log(1/100), log(1/500), log(1/1000), log(1/2500)];
% B = [log(2), log(1),log(1/4), log(1/250), log(1/1000)];
% B2 = [log(1), log(1/15)];

z = 1 : 256; 
l = 200;

g = zeros(256, 3);
[g(:, 1), lE1] = gsolve(Z(:, :, 1), B, l, w);
[g(:, 2), lE2] = gsolve(Z(:, :, 2), B, l, w);
[g(:, 3), lE3] = gsolve(Z(:, :, 3), B, l, w);

figure()
plot(g(:, 1), z,'r',g(:, 2), z,'g', g(:, 3), z, 'b');
title("response funtion for R,G,B channel");

rW = radianceWeights(g(:, 1));
gW = radianceWeights(g(:, 2));
bW = radianceWeights(g(:, 3));

lE_r = rad_map(g(:, 1), rW, I2(:, :, 1, :), B);
lE_g = rad_map(g(:, 1), gW, I2(:, :, 2, :), B);
lE_b = rad_map(g(:, 1), bW, I2(:, :, 3, :), B);
hdr_image = zeros(height, width, 3);
hdr_image(:,:,1) = lE_r;
hdr_image(:,:,2) = lE_g;
hdr_image(:,:,3) = lE_b;


hdr_image1 = rad_map1(I2, B, w, g(:, 1), num);
hdr_image1 = exp(hdr_image1);

rW1 = radianceWeights1(g(:, 1));
gW1 = radianceWeights1(g(:, 2));
bW1 = radianceWeights1(g(:, 3));
%w(z) = g'(z)
hdr_image2 = zeros(height, width, 3);
lE_r2 = rad_map(g(:, 1), rW1, I2(:, :, 1, :), B);
lE_g2 = rad_map(g(:, 1), gW1, I2(:, :, 2, :), B);
lE_b2 = rad_map(g(:, 1), bW1, I2(:, :, 3, :), B);

hdr_image2(:,:,1) = lE_r2;
hdr_image2(:,:,2) = lE_g2;
hdr_image2(:,:,3) = lE_b2;


figure()
subplot(1,3,1),imshow(tonemap(hdr_image2));
title("w(Z)= g'(Z)");

subplot(1,3,2),imshow(tonemap(hdr_image1));
title("Debevec’s algorithm");

subplot(1,3,3),imshow(tonemap(hdr_image));
title("w(Z) = g(Z)/g'(Z)");


