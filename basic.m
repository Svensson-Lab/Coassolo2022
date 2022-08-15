clear;
FILE = [dir('_images/*1.tif'); dir('_images/*2.tif'); dir('_images/*3.tif'); dir('_images/*4.tif')];
test = struct2cell(FILE);
ID = [extractBetween(test(1, :), '-', '_'); extractBetween(test(1, :), '_', '.')]';

%% PART 1
tic;
j = 1;
RES = zeros(1e6, 6);
for n = 1:size(FILE, 1)
    disp(FILE(n).name); rng(1);
    RGB = imread(['_images/' FILE(n).name]);
    GREY = imadjust(rgb2gray(RGB));
    BW = imopen(imfill(GREY <= 100, 'holes'), strel('disk', 5, 0));
    stat = regionprops(bwconncomp(BW), 'PixelIdxList');
    RGBr = reshape(RGB, [size(RGB, 1)*size(RGB, 2), 3]);
    for i = 1:size(stat, 1)
        RES(j, :) = [str2double(FILE(n).name(2:3)) str2double(ID(n, :)) mean(RGBr(stat(i).PixelIdxList, :))];
        j = j + 1;
    end
    MASK = RGB;
    MASK(repmat(~BW,[1 1 3])) = 255;
    imwrite(MASK, ['_images/' FILE(n).name(1:end-4) '_maskedNew2.tif']);
end
RES(j:end, :) = [];
save('RES', 'RES');
toc;

%% PART 2
tic;
load('RES');
RES(:, 7:9) = squeeze(rgb2hsv(reshape(RES(:, 4:6), [], 1, 3)));
RES(:, 7) = mod(RES(:, 7) - 1/3, 1);
RES(:, 10:11) = [(RES(:, 7) > 0.5) (RES(:, 7) < 0.5)];
for n = 1:size(FILE, 1)
    figure('visible', 'off'); clf;
    disp(FILE(n).name); rng(1);
    set(gcf, 'color', 'w');
    SUB = RES((RES(:, 1) == str2double(FILE(n).name(2:3))) + (RES(:, 2) == str2double(ID(n, 1))) + (RES(:, 3) == str2double(ID(n, 2))) == 3, :);
    scatter(RES(:, 4), RES(:, 6), 1, [0.5 0.5 0.5], 'filled'); hold on;
    scatter(SUB(SUB(:, 10) == 1, 4), SUB(SUB(:, 10) == 1, 6), 8, 'r', 'filled');
    scatter(SUB(SUB(:, 11) == 1, 4), SUB(SUB(:, 11) == 1, 6), 8, 'b', 'filled');
    title([num2str(sum(SUB(:, 11))) ' blue and ' num2str(sum(SUB(:, 10))) ' brown']);
    set(gca, 'Box', 'on', 'FontSize', 20, 'LineWidth', 2);
    axis([50 250 50 250], 'square')
    xlabel('Red');
    ylabel('Blue');
    saveas(gcf, ['_images/' FILE(n).name(1:end-4) '_groupedNew.png'])
end
toc;

%% PART 3
tic;
load('RES');
RES(:, 7:9) = squeeze(rgb2hsv(reshape(RES(:, 4:6), [], 1, 3)));
RES(:, 7) = mod(RES(:, 7) - 1/3, 1);
RES(:, 10:11) = [(RES(:, 7) > 0.5) (RES(:, 7) < 0.5)];
figure(1); clf;
disp(FILE(n).name); rng(1);
set(gcf, 'color', 'w');
scatter(RES(:, 4), RES(:, 6), 1, [0.5 0.5 0.5], 'filled'); hold on;
scatter(RES(RES(:, 10) == 1, 4), RES(RES(:, 10) == 1, 6), 1, 'r', 'filled');
scatter(RES(RES(:, 11) == 1, 4), RES(RES(:, 11) == 1, 6), 1, 'b', 'filled');
title([num2str(sum(RES(:, 11))) ' blue and ' num2str(sum(RES(:, 10))) ' brown']);
set(gca, 'Box', 'on', 'FontSize', 20, 'LineWidth', 2);
axis([50 250 50 250], 'square')
xlabel('Red');
ylabel('Blue');
saveas(gcf, 'groupedNew.png')

%% PART 4 new
tic;
load('RES');
RES(:, 7:9) = squeeze(rgb2hsv(reshape(RES(:, 4:6), [], 1, 3)));
RES(:, 7) = mod(RES(:, 7) - 1/3, 1);
RES(:, 10:11) = [(RES(:, 7) > 0.5) (RES(:, 7) < 0.5)];
RES(:, 7:9) = squeeze(rgb2hsv(reshape(RES(:, 4:6), [], 1, 3)));
figure(1); clf;
set(gcf, 'color', 'w');
scatter(RES(:, 7)*360, RES(:, 8)*360, 1, squeeze(hsv2rgb(reshape([RES(:, 7) 0.7*ones(size(RES, 1), 2)], [], 1, 3))), 'filled'); hold on;
plot([300 300]', [0 200]', 'k--', 'Color', [1 1 1]/3, 'LineWidth', 3)
%scatter(RES(RES(:, 11) == 1, 7)*360, RES(RES(:, 11) == 1, 8)*360, 1, 'b', 'filled');
set(gca, 'Box', 'on', 'FontSize', 20, 'LineWidth', 2, 'XTick', 0:120:360, 'YTick', 0:120:360);
xlabel('Hue');
ylabel('Saturation');
axis([0 360 0 360], 'square')
saveas(gcf, 'HSV.png')


toc;