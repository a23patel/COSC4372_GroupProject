% Button pushed function: DisplayKSpaceButton
function DisplayKSpaceButtonPushed(app, ~)
    % reference: https://www.mathworks.com/help/images/fourier-transform.html
    
    % reading the phantom
    imdata = imread('./phantom.png');

    % Converting the RGB image to grayscale
    imdata = im2gray(imdata);

    % get the fourier transform with zero padding of size 1024 by 1024
    fourier_t = fft2(imdata, 1024, 1024);

    % shift the zero-frequency component of the Fourier transform to the center of the matrix
    fourier_shift = fftshift(fourier_t);

    % Calculating the magnitude of the shifted Fourier transform
    s = abs(fourier_shift);

    % Performing log transform on the magnitude of fourier
    % transform
    s2 = log(s);
   
    % Displaying the final k-spaced image in the image panel within the app
    imshow(s2, [], 'parent', app.KSpaceImage);
end