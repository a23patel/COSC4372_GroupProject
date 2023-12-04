% Button pushed function: CompareImageButton
function CompareImagePushed(app, ~)
    % Parameters for creating the sampling pattern
    numberOfLines = app.NumberOfLines.Value;
    pointsPerLine = app.PointsPerLine.Value;

    % Generating sampling pattern
    [x, y] = meshgrid(-numberOfLines:pointsPerLine, -numberOfLines:pointsPerLine);
    z = sqrt(x.^2 + y.^2);
    c = (z < 15);

    % Fourier transform and visualization of the sampled K-space image
    cf = fftshift(fft2(c));
    cf1 = log(1 + abs(cf));
    maxIntensity = max(cf1(:));
    imshow(im2uint8(cf1 / maxIntensity), [], 'parent', app.SampledKSpaceImage);

    % Reading the phantom image
    phantomImage = imread('./phantom.png');

    % Reconstructed image using Radial Sampling
    if(app.RadialButton.Value == 1)
        if(numberOfLines >= 16) && (numberOfLines < 64)
            if pointsPerLine >= 16 && pointsPerLine < 64
                theta1 = 0:10:170;
            else
                theta1 = 0:10:180;
            end
            % Perform Radon transform
            [R1, ~] = radon(phantomImage, theta1);
            %size(R1, 2); returns the number of columns in matrix R1
            %size(R1, 1); returns the number of rows in matrix R1
    
            % Interpolate to 512 angles
            P512 = phantomImage;
            [~, ~] = radon(P512, theta1);
            %size(R512, 1);  returns the size of rows in matrix R512
            outputSize = max(size(phantomImage));
            dTheta1 = theta1(2) - theta1(1);
    
            % Perform Inverse Radon transform
            I1 = iradon(R1, dTheta1, outputSize);
            differenceImage = I1;
    
            % Display the reconstructed image for radial sampling
            imshow(differenceImage, [], 'parent', app.ReconstructedImage);

        elseif (numberOfLines >= 64) && (numberOfLines <= 128)
            if (pointsPerLine >= 64) && (pointsPerLine <= 128)
                theta2 = 0:5:175;
            else
                theta2 = 0:4.9:180;
            end

            % Perform Radon transform
            [R2, ~] = radon(phantomImage, theta2);
            %size(R2, 2);  returns number of column in matrix R2
            % size(R2, 1); returns number of rows in matrix R2

            % Interpolate to 512 angles
            P512 = phantomImage;
            [~, ~] = radon(P512, theta2);
            % size(R512, 1); returns number of rows in matrix R512
            outputSize = max(size(phantomImage));
            dTheta2 = theta2(2) - theta2(1);
            % Perform inverse Radon transform
            I2 = iradon(R2, dTheta2, outputSize);
            differenceImage = I2;
        
            % Display the reconstructed image of radial sampling
            imshow(differenceImage, [], 'parent', app.ReconstructedImage);
        else
            if(numberOfLines > 128) && (pointsPerLine > 128)
                theta3 = 0:2:178;
            else
                theta3 = 0:2.5:178;
            end

            % Perform Radon transform
            [R3, ~] = radon(phantomImage, theta3);
            %size(R3, 2); returns number of columns in matrix R3
            %size(R3, 1); returns number of rows in matrix R3

            % Interpolate to 512 angles
            P512 = phantomImage;
            [~, ~] = radon(P512, theta3);
            %size(R512, 1); returns number of rows in matrix R512
            outputSize = max(size(phantomImage));
            dTheta3 = theta3(2) - theta3(1);
            I3 = iradon(R3, dTheta3, outputSize);
            differenceImage = I3;

            % Display the reconstructed image of radial sampling
            imshow(differenceImage, [], 'parent', app.ReconstructedImage);
        end
    else
        % Reconstructed image using Cartesian sampling
        numberOfLines = app.NumberOfLines.Value;
        pointsPerLine = app.PointsPerLine.Value;

        % Defining ranges for cropping
        startX = int64(640 - (numberOfLines * 2.5));
        startY = int64(640 - (pointsPerLine * 2.5));
        if startX == 0
            startX = 1;
        end
        if startY == 0
            startY = 1;
        end
        endX = int64(640 + (numberOfLines * 2.5));
        endY = int64(640 + (pointsPerLine * 2.5));

        % Reading the phantom image
        imData = imread('./phantom.png');

        % Convert image to grayscale
        imData = im2gray(imData);

        % Fourier transform with zero padding
        fourierTransform = fft2(imData, 1280, 1280);
        shiftedKSpace = fftshift(fourierTransform);

        % Cropping the k-space
        croppedKSpace = shiftedKSpace(startX:endX, startY:endY);

        % Inverse Fourier transform
        reconstruction = ifft2(croppedKSpace);

        % Cropping the reconstruction to specified size
        croppedReconstruction = reconstruction(1:numberOfLines, 1:pointsPerLine);

        % Scaling and resizing the image
        absScaled = abs(croppedReconstruction);
        stretchedImage = imresize(absScaled, [256, 256]);

        % Displaying Sampled K-Space for Cartesian
        targetSize = [numberOfLines * 5, pointsPerLine * 5];
        win1 = centerCropWindow2d(size(shiftedKSpace), targetSize);
        B1 = imcrop(abs(log(shiftedKSpace)), win1);
        B1 = imresize(B1, [256, 256]);
        imshow(B1, [], 'parent', app.SampledKSpaceImage);
        differenceImage = stretchedImage;
        % Display the reconstructed image for Cartesian sampling
        imshow(differenceImage, [], 'parent', app.ReconstructedImage);
    end
    % Display the difference image and input phantom image for comparison
    imshowpair(phantomImage, differenceImage, 'montage');
    title('Compare Input Phantom with Reconstructed Phantom', 'Color', 'blue');
end