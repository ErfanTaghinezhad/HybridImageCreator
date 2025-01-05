clc;
clear;

% Input image paths
image1_path = './images/IMG_3645.jpg'; % First image (e.g., Elon Musk)
image2_path = './images/IMG_3644.jpg'; % Second image (e.g., Donald Trump)

% Read images
image1 = imread(image1_path);
image2 = imread(image2_path);

% Resize images to the same dimensions
[size1_row, size1_col, ~] = size(image1);
[size2_row, size2_col, ~] = size(image2);
min_row = min(size1_row, size2_row);
min_col = min(size1_col, size2_col);
image1_resized = imresize(image1, [min_row, min_col]);
image2_resized = imresize(image2, [min_row, min_col]);

% Convert to grayscale
gray_image1 = rgb2gray(image1_resized);
gray_image2 = rgb2gray(image2_resized);

% Gaussian filter parameters
filter_size = 15;
sigma = 5;
gaussian_filter = fspecial('gaussian', filter_size, sigma);

% Low-pass filter on first image
low_pass_image = imfilter(gray_image1, gaussian_filter, 'replicate');

% High-pass filter on second image
high_pass_image = double(gray_image2) - double(low_pass_image);
high_pass_image = high_pass_image - min(high_pass_image(:));
high_pass_image = high_pass_image / max(high_pass_image(:));

% Normalize images
low_pass_norm = mat2gray(low_pass_image);
high_pass_norm = mat2gray(high_pass_image);

% Create hybrid image
alpha = 0.5;
beta = 0.5;
hybrid_image = alpha * low_pass_norm + beta * high_pass_norm;
hybrid_image = hybrid_image / max(hybrid_image(:));

% Display and save hybrid image
figure;
subplot(1, 3, 1);
imshow(gray_image1, []);
title('Image 1');

subplot(1, 3, 2);
imshow(gray_image2, []);
title('Image 2');

subplot(1, 3, 3);
imshow(hybrid_image, []);
title('Hybrid Image');