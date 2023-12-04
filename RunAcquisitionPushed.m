% Button pushed function: RunAcquisitionButton
function RunAcquisitionPushed(app, ~)
    % Get values from Edit Fields
    numberOfLines = app.NumberOfLines.Value;
    pointsPerLine = app.PointsPerLine.Value;

    % Generate Cartesian grid
    [x, y] = meshgrid(-numberOfLines:pointsPerLine, -numberOfLines:pointsPerLine);

    % Calculate radial distance from the center
    radialDistance = sqrt(x.^2 + y.^2);

    % Creating a circular mask with radius 15
    circularMask = (radialDistance < 15);

    % Performing Fourier Transform
    fftResult = fftshift(fft2(circularMask));

    % Computing the log magnitude spectrum
    logMagnitudeSpectrum = log(1 + abs(fftResult));

    % Visualize Sampled K-Space for Radial
    imshow(im2uint8(logMagnitudeSpectrum / max(logMagnitudeSpectrum(:))), [], 'parent', app.SampledKSpaceImage);

    % Read the phantom image
    phantomImage = imread('./phantom.png');

    % Reconstructed image using Radial Sampling
    if(app.RadialButton.Value == 1)
        if (numberOfLines >= 16) && (numberOfLines < 64)
            if(pointsPerLine >= 16) && (pointsPerLine < 64)
                theta1 = 0:10:170;
            else
                theta1 = 0:10:180;
            end
            % Perform Radon transform
            [R1, ~] = radon(phantomImage, theta1);
            % size(R1, 2); returns number of columns in matrix R1
            % size(R1, 1); returns number of rows in matrix R2

            % Interpolate to 512 angles
            P512 = phantomImage;
            [~, ~] = radon(P512, theta1);
            %size(R512, 1); returns the number of rows in matrix R512
            outputSize = max(size(phantomImage));
            dTheta1 = theta1(2) - theta1(1);
            I1 = iradon(R1, dTheta1, outputSize);

            % Display the reconstructed image for Radial sampling
            idiff = I1;
            imshow(idiff, [], 'parent', app.ReconstructedImage);
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
            I2 = iradon(R2, dTheta2, outputSize);
            idiff = I2;
        
            % Display the reconstructed image of radial sampling
            imshow(idiff, [], 'parent', app.ReconstructedImage);
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
            idiff = I3;

            % Display the reconstructed image of radial sampling
            imshow(idiff, [], 'parent', app.ReconstructedImage);
        end
    else
        % Reconstructed image using Cartesian sampling
        numLines = app.NumberOfLines.Value;
        numPoints = app.PointsPerLine.Value;
      
        % Defining ranges for cropping
        startX = int64(640 - (numLines * 2.5));
        startY = int64(640 - (numPoints * 2.5));
        if startX == 0
            startX = 1;
        end
        if startY == 0
            startY = 1;
        end
        endX = int64(640 + (numLines * 2.5));
        endY = int64(640 + (numPoints * 2.5));

        %disp(startX);
        %disp(startY);
        %disp(endX);
        %disp(endY);
        
        % Reading the phantom image
        imData = imread('./phantom.png');
        imData = im2gray(imData);

        % Fourier transform with zero padding
        fourierTransform = fft2(imData, 1280, 1280);
        shiftedKSpace = fftshift(fourierTransform);

        % Cropping the k-space
        croppedKSpace = shiftedKSpace(startX:endX, startY:endY);

        % Inverse Fourier transform
        reconstruction = ifft2(croppedKSpace);

        % Cropping the reconstruction to specified size
        croppedReconstruction = reconstruction(1:numLines, 1:numPoints);

        % Scaling and resizing the image
        absScaled = abs(croppedReconstruction);
        stretchedImage = imresize(absScaled, [256, 256]);

        % Generating Sampled K-Space image for Cartesian sampling
        targetSize = [numLines * 5, numPoints * 5];
        win1 = centerCropWindow2d(size(shiftedKSpace), targetSize);
        B1 = imcrop(abs(log(shiftedKSpace)), win1);
        B1 = imresize(B1, [256, 256]);
        imshow(B1, [], 'parent', app.SampledKSpaceImage);
        idiff = stretchedImage;
        % Display the reconstructed image for Cartesian
        imshow(idiff, [], 'parent', app.ReconstructedImage);
    end

    % Updating reconstruction image panel
    app.PhantomtypeTextArea.Value = app.PhantomButtonGroup.SelectedObject.Text;
    app.MethodTextArea.Value = app.SamplingButtonGroup.SelectedObject.Text;
    numLines = app.NumberOfLines.Value;
    numPointsPerLine = app.PointsPerLine.Value;
    app.outputNumberOfLines.Value = numLines;
    app.outputPointsPerLine.Value = numPointsPerLine;
end