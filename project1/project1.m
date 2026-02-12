clear; clc;

% Load the data 
% These files contain a variable named 'imageData'
L_B = load('HST_MOS_5136_ACS_WFC_F475W_drz.mat');
L_G = load('HST_MOS_5136_ACS_WFC_F625W_drz.mat');
L_R = load('HST_MOS_5136_ACS_WFC_F775W_drz.mat');

% Extract, Convert to Double, and Crop (Pre-processing Step 1)
% We crop immediately [1200:4700] to save RAM
rows = 1200:4700;
cols = 1200:4700;

I_B_crop = double(L_B.imageData(rows, cols));
I_G_crop = double(L_G.imageData(rows, cols));
I_R_crop = double(L_R.imageData(rows, cols));

% Clear the large structures from memory immediately
clear L_B L_G L_R;

% Create the RGB Stack
% Red = F775W, Green = F625W, Blue = F475W
patch = cat(3, I_R_crop, I_G_crop, I_B_crop);
clear I_R_crop I_G_crop I_B_crop; % More memory cleanup

% Pre-processing: Clipping and Normalization
% Set all values less than 0 to 0
patch(patch < 0) = 0;

% Normalize to [0, 1]
maxVal = max(patch(:));
minVal = min(patch(:));
normalizedPatch = (patch - minVal) / maxVal;

% Apply Enhancement using your hubbleEnhance function
% For Task 1, you are required to use 'powK' and 'asinhK', 
% I used k=0.11 as mentioned in the assignment
enhancedImage = hubbleEnhance('powK', normalizedPatch, 0.11);

% Display the result
figure;
imshow(enhancedImage);
title('Abell 1689 - Enhanced Color Image (powK, K=0.11)');

%% Part 1 Question 3
r = 0:0.001:1; % Input intensity
% (1) Power Law
s_pow = r.^0.14;
% (2) Asinh Stretch
K_val = 13000;
s_asinh = asinh(r * K_val) / asinh(K_val);
% Plotting
figure;
plot(r, s_pow, 'r', 'LineWidth', 2); hold on;
plot(r, s_asinh, 'b', 'LineWidth', 2);
grid on;
xlabel('Input Intensity (r)');
ylabel('Output Intensity (s)');
legend('s = r^{0.14}', 's = asinh(r*13000)/asinh(13000)', 'Location', 'southeast');
title('Comparison of Image Enhancement Transfer Functions');

%% PART 2, QUESTION 1 
% Create the Un-modified RGB Image
% We must still convert it to uint8 [0-255] for display, 
% but we apply no non-linear enhancement.
unmodifiedImage = uint8(normalizedPatch .* 255);

% Create the Power Law Enhanced Image (K = 0.13)
enhancedPow = hubbleEnhance('powK', normalizedPatch, 0.13);

% Create the Asinh Enhanced Image (K = 10000)
enhancedAsinh = hubbleEnhance('asinhK', normalizedPatch, 10000);

% Plotting the 3x1 Matrix
figure('Name', 'Task 1: Comparison of Enhancement Methods', 'NumberTitle', 'off');

% Subplot 1: Un-modified
subplot(3, 1, 1);
imshow(unmodifiedImage);
title('1. Un-modified Normalized RGB Image (Mostly Black)');

% Subplot 2: Power Law (powK)
subplot(3, 1, 2);
imshow(enhancedPow);
title('2. Enhanced RGB: powK (K = 0.13)');

% Subplot 3: Asinh (asinhK)
subplot(3, 1, 3);
imshow(enhancedAsinh);
title('3. Enhanced RGB: asinhK (K = 10000)');

% Adjust layout to prevent titles from overlapping
sgtitle('Abell 1689: Visual Comparison of Astronomical Image Enhancements');

%%  PART 3: ENHANCE THE IMAGE FURTHER (REFERENCE IMAGE) 

% 1. Start with your best enhancement (usually asinhK)
finalView = enhancedAsinh;

% 2. Apply Reflection (Horizontal Flip)
% Raw Hubble data is often mirrored relative to the sky-view
finalView = transform(finalView, 'flipH', []);

% 3. Apply Rotation, try a 90-degree clockwise rotation
finalView = transform(finalView, 'rotate', -90);

% 4. Fine-Tune the Crop, centered on the lensing arcs.
[rows, cols, ~] = size(finalView);
centerR = round(rows/2);
centerC = round(cols/2);
offset = 1250; % Adjust this to frame the cluster perfectly
finalView = finalView(centerR-offset:centerR+offset, centerC-offset:centerC+offset, :);

% Plot 
figure('Name', 'Replicated Hubble Reference Image');
imshow(finalView);
title('Abell 1689: Replicated Press-Release Orientation');
