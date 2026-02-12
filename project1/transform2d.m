function outputImage = transform2d(inputImage, type, params)
% TRANSFORM Performs spatial manipulations on image data.
%   INPUTS:
%   inputImage - The RGB image matrix (uint8 or double).
%   type       - String: 'rotate', 'flipH', or 'flipV'.
%   params     - For 'rotate', this is the angle in degrees.
%
%   OUTPUT:
%   outputImage - The spatially transformed image.

    switch type
        case 'rotate'
            % Built in function
            outputImage = imrotate(inputImage, params, 'bilinear', 'crop');
            
        case 'flipH'
            % Horizontal reflection (flip across vertical axis)
            outputImage = flip(inputImage, 2);
            
        case 'flipV'
            % Vertical reflection (flip across horizontal axis)
            outputImage = flip(inputImage, 1);
            
        otherwise
            error('Unknown transformation type.');
    end

end
