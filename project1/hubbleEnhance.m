function outputImage = hubbleEnhance(type, inputImage, K)
% HUBBLEENHANCE Enhances Hubble Space Telescope image data.
%   outputImage = hubbleEnhance(type, inputImage, K) applies a 
%   specified non-linear transformation to an RGB image matrix.
%
%   INPUTS:
%   type       - String: 'powK' for power-law or 'asinhK' for inverse hyperbolic sine.
%   inputImage - NxMx3 double matrix containing normalized image data [0, 1].
%   K          - Enhancement parameter (exponent for powK, scale factor for asinhK).
%
%   OUTPUT: outputImage - NxMx3 uint8 matrix scaled to [0, 255] for display.

    % Initialize the output matrix
    Inew = zeros(size(inputImage));

    % Perform enhancement based on the requested type
    if strcmp(type, 'powK')
        % Power Law: Inew = (I)^K
        Inew = inputImage.^K;
        
    elseif strcmp(type, 'asinhK')
        % Asinh scaling: Inew = asinh(I * K) / asinh(K)
        % This is excellent for preserving color while stretching low-end signal
        Inew = asinh(inputImage .* K) ./ asinh(K);
        
    else
        error('Unknown enhancement type. Use "powK" or "asinhK".');
    end

    % Convert to 8-bit format [0, 255], data is clipped to [0, 1] before scaling 
    Inew = max(0, min(1, Inew)); 
    outputImage = uint8(Inew .* 255);
end