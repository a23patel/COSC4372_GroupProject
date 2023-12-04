% Button pushed function: DisplayKSpaceButton
function DisplayKSpacePushed(app, ~)
    
    % read the input phantom
    phantom = imread('./phantom.png');

    % Converting the RGB image to grayscale
    phantom = im2gray(phantom);

    % get the Fourier transform with zero padding of size 1024 by 1024
    fourier_transform = fft2(phantom, 1024, 1024);

    % shift the zero-frequency component of the Fourier transform to the center of the matrix
    fourier_shift = fftshift(fourier_transform);

    % Calculating the magnitude of the shifted Fourier transform
    si = abs(fourier_shift);

    % Performing log transform on the magnitude of fourier transform
    si2 = log(si);
   
    % Displaying the final k-spaced image in the image panel within the app
    imshow(si2, [], 'parent', app.KSpaceImage);
end