classdef GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MRIAcquisitionSimulatorUIFigure  matlab.ui.Figure
        CompareImageButton             matlab.ui.control.Button
        AcquisitionPanel               matlab.ui.container.Panel
        MethodTextArea                 matlab.ui.control.TextArea
        MethodTextAreaLabel            matlab.ui.control.Label
        PhantomtypeTextArea            matlab.ui.control.TextArea
        PhantomtypeTextAreaLabel       matlab.ui.control.Label
        SamplingLabel                  matlab.ui.control.Label
        outputPointsPerLineEditField   matlab.ui.control.NumericEditField
        ofpointsperlineEditField_2Label  matlab.ui.control.Label
        outputNumLinesEditField        matlab.ui.control.NumericEditField
        oflinesEditField_2Label        matlab.ui.control.Label
        RunAcquisitionButton           matlab.ui.control.Button
        SamplingPanel                  matlab.ui.container.Panel
        ofpointsperlineEditField       matlab.ui.control.NumericEditField
        ofpointsperlineEditFieldLabel  matlab.ui.control.Label
        oflinesEditField               matlab.ui.control.NumericEditField
        oflinesEditFieldLabel          matlab.ui.control.Label
        SamplingButtonGroup            matlab.ui.container.ButtonGroup
        Cartesian                      matlab.ui.control.Image
        Radial                         matlab.ui.control.Image
        CartesianButton                matlab.ui.control.RadioButton
        RadialButton                   matlab.ui.control.RadioButton
        DisplayKSpaceButton            matlab.ui.control.Button
        ReconstructedImagePanel        matlab.ui.container.Panel
        ReconstructedImage             matlab.ui.control.UIAxes
        SampledKSpaceImagePanel        matlab.ui.container.Panel
        SampledKSpaceImage             matlab.ui.control.UIAxes
        KSpaceImagePanel               matlab.ui.container.Panel
        KSpaceImage                    matlab.ui.control.UIAxes
        PhantomImagePanel              matlab.ui.container.Panel
        PhantomImage                   matlab.ui.control.UIAxes
        PhantomPanel                   matlab.ui.container.Panel
        RectangularstructuresizePanel  matlab.ui.container.Panel
        LengthSlider                   matlab.ui.control.Slider
        LengthSliderLabel              matlab.ui.control.Label
        WidthSlider                    matlab.ui.control.Slider
        WidthSliderLabel               matlab.ui.control.Label
        PhantomButtonGroup             matlab.ui.container.ButtonGroup
        Circular                       matlab.ui.control.Image
        Rectangular                    matlab.ui.control.Image
        Phantom2Button                 matlab.ui.control.RadioButton
        Phantom1Button                 matlab.ui.control.RadioButton
        GeneratePhantomButton          matlab.ui.control.Button
        MRIACQUISITIONSIMULATORLabel   matlab.ui.control.Label
    end

    
    % To draw a filled circle on a 2D canvas
    methods (Access = private)
        
        function [updatedCanvas] = draw(~, canvas, center, radius, color)
            % ~ is used to indicate that the function does not use the first input (often used as a placeholder)
            % canvas: the 2D matrix representing the drawing area
            % center: a 1x2 vector [x, y] specifying the center of the circle
            % radius: the radius of the circle
            % color: the intensity or color value to fill the circle
            
            % Calculate the starting and ending points on the x-axis
            xStart = center(1) - radius;
            xEnd = center(1) + radius;
            
            % Loop through each point on the horizontal diameter of the circle
            for x = xStart : xEnd
                % get the distance to center poiont of x-axis
                x_to_cp = center(1) - x;
                % get the distance to center poiont of y-axis by x^2 + y^2
                % = r^2
                y_to_cp = floor(sqrt(radius^2 - x_to_cp^2));
                % find where to draw for y-axis
                y = center(2) - y_to_cp : center(2) + y_to_cp;
                
                % Draw a line in the canvas for the current x position
                canvas(x, y) = color;
            end
            
            % Update the canvas after drawing the circle
            updatedCanvas = canvas;
        end
    end

    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: GeneratePhantomButton
        function GeneratePhantomButtonPushed(app, ~)
            % Set the canvas size and initialize it with zeros
            canvasSize = [300, 300];
            canvas = zeros(canvasSize);

            % Calculate the center of the canvas
            centerPoint = [canvasSize(1)/2, canvasSize(2)/2];
            % Set radius of the background circle as 40% of the canvas's width
            backgroundCircleRadius = ceil(0.4 * canvasSize(1));

            % Draw the background circle on the canvas with a specified color
            canvas = draw(app, canvas, centerPoint, backgroundCircleRadius, 150);
            
            % Converts the canvas to an 8-bit unsigned integer format
            % (a common step in image processing)
            canvas = uint8(canvas);
            
            % Specifies the distance between each pair of inner circles
            innerCircleDistance = ceil(backgroundCircleRadius/5.4);
            
            % Phantom2 (with 5 inner circle)
            if(app.Phantom1Button.Value == 0)
                % make an array of inner circles
                innerCircle = [];

                % inner circle 1
                innerCircle(1).center = [centerPoint(1), (centerPoint(2)- floor(4.5 * innerCircleDistance))];
                innerCircle(1).radius = ceil( min(canvasSize)/55);
                
                % inner circle 2
                innerCircle(2).center = [centerPoint(1), (centerPoint(2)- 3 * innerCircleDistance)];
                innerCircle(2).radius = floor(1.52 * innerCircle(1).radius);
                
                % inner circle 3
                innerCircle(3).center = [centerPoint(1), (centerPoint(2)- 1 * innerCircleDistance)];
                innerCircle(3).radius = floor(1.52 * innerCircle(2).radius);
                
                % inner circle 4
                innerCircle(4).center = [centerPoint(1), (centerPoint(2)) + innerCircleDistance];
                innerCircle(4).radius = floor(1.52 * innerCircle(3).radius);
                
                % inner circle 5
                innerCircle(5).center = [centerPoint(1), (centerPoint(2) + floor(3.5 * innerCircleDistance))];
                innerCircle(5).radius = floor(1.52 * innerCircle(4).radius);
                
                for i = 1:5
                    % Draw the inner circle on the canvas with a specified color
                    canvas = draw(app, canvas, innerCircle(i).center, innerCircle(i).radius, 250);
                end
            
            % Phantom1
            else 
                width = app.WidthSlider.Value;
                length = app.LengthSlider.Value;
                
                if(width<1)
                    width = 30; 
                end

                if(length < 1)
                    length = 30;
                end

                if(width > 47)
                    width = 47;
                end

                if(length > 47)
                    length = 47;
                end

                r_size = floor([width*3 length*3]);

                % get user input - rectangular size 
                % r_para[width, height]
                r_para = r_size;
        
                % x-axis = height
                % height x-axis starting point
                x1 = floor(centerPoint(2) - r_para(2)/2);
                % height x-axis ending point
                x2 = x1 + r_para(2);
                
                % y-axis = width
                % width y-axix starting point
                y1 = floor(centerPoint(1) - r_para(1)/2);
                % width y-axix ending point
                y2 = y1 + r_para(1);
        
                % draw the square
                canvas(x1 : x2, y1 : y2) = 256;
            end

            imwrite(canvas,'./test.png');


            a = imread('./test.png');
            imshow(a,'parent', app.PhantomImage);
            
        end

        % Button pushed function: DisplayKSpaceButton
        function DisplayKSpaceButtonPushed(app, event)
            % reference: https://www.mathworks.com/help/images/fourier-transform.html
            
            % read the phantom
            imdata = imread('./test.png');
            %figure(1);imshow(imdata); title('Original Image');

            % grey scale
            imdata = im2gray(imdata);
            %figure(2);imshow(imdata); title('Grey Scale');

            % get the fourier transform with zero padding of 1k by 1k
            fourier_t = fft2(imdata, 1280, 1280);

            % shift the k-space
            fourier_shift = fftshift(fourier_t);
            s = abs(fourier_shift);
            %figure(3);imshow(s, []); title('Fourier Transform');

            % log transform
            s2 = log(s);
            %figure(4);imshow(s2, []); title('Log Transform FT');
           
            % show image in panel
            imshow(s2, [], 'parent', app.KSpaceImage);
        end

        % Button pushed function: RunAcquisitionButton
        function RunAcquisitionButtonPushed(app, event)
            a = app.oflinesEditField.Value;
            b = app.ofpointsperlineEditField.Value;
            [x,y] = meshgrid(-a:b,-a:b);
            z = sqrt(x.^2+y.^2);
            c = (z<15);
            cf = fftshift(fft2(c));
            cf1 = log(1+abs(cf));
            m = max(cf1(:));
            %Generate Sampled K-Space for Radial
            imshow(im2uint8(cf1/m), [], 'parent', app.SampledKSpaceImage);
            o_img = imread('./test.png');
            idiff = 0;
            
            %Reconstructed image using Radial Sampling
            if(app.RadialButton.Value == 1)
                img = imread('./test.png');
                if(a >= 16) && (a < 64)
                    if(b >= 16) && (b < 64)
                        theta1 = 0:10:170;
                    else
                        theta1 = 0:10:180;
                    end
                    [R1,~] = radon(img,theta1); 
                    num_angles_R1 = size(R1,2)
                    N_R1 = size(R1,1)
                    P_512 = img;
                    [R_512,xp_512] = radon(P_512,theta1);
                    N_512 = size(R_512,1)
                    output_size = max(size(img));
                    dtheta1 = theta1(2) - theta1(1);
                    I1 = iradon(R1,dtheta1,output_size);
                    idiff = I1;
                    %%Generate Sampled K-Space for Radial
                    imshow(I1, [], 'parent', app.ReconstructedImage);

                elseif(a >= 64) && (a <= 128)
                    if(b >= 64) && (b <= 128)
                        theta2 = 0:5:175;
                    else
                        theta2 = 0:4.9:180;
                    end
                    [R2,~] = radon(img,theta2);
                    num_angles_R2 = size(R2,2)
                    N_R2 = size(R2,1)
                    P_512 = img;
                    [R_512,xp_512] = radon(P_512,theta2);
                    N_512 = size(R_512,1)
                    output_size = max(size(img));
                    dtheta1 = theta2(2) - theta2(1);
                    I2 = iradon(R2,dtheta1,output_size);
                    idiff = I2;
                    %%Generate K-Space for Radial image
                    imshow(I2, [], 'parent', app.ReconstructedImage);
                else
                    if(a > 128) && (b > 128)
                        theta3 = 0:2:178;
                    else
                        theta3 = 0:2.5:178;
                    end
                    [R3,xp] = radon(img,theta3); 
                    num_angles = size(R3,2)
                    N_R = size(R3,1)
                    P_512 = img;
                    [R_512,xp_512] = radon(P_512,theta3);
                    N_512 = size(R_512,1)
                    output_size = max(size(img));
                    dtheta = theta3(2) - theta3(1);
                    I3 = iradon(R3,dtheta,output_size);
                    idiff = I3;
                    %%Generate Sampled K-Space for Radial image
                    imshow(I3, [], 'parent', app.ReconstructedImage);
                end

            else                
                 % Reconstructed image using Cartesian sampling 
                 num_lines = app.oflinesEditField.Value;
                 num_points = app.ofpointsperlineEditField.Value;

                 x_range = num_lines;
                 y_range = num_points;

                 start_range_x = int64(640 - (num_lines*2.5));
                 start_range_y = int64(640 - (num_points*2.5));

                 % index starts at 1
                 if(start_range_x == 0)
                     start_range_x = 1;
                 end
                 if(start_range_y == 0)
                     start_range_y = 1;
                 end

                 end_range_x = int64(640 + (num_lines*2.5));
                 end_range_y = int64(640 + (num_points*2.5));

                 %disp(start_range_x);
                 %disp(start_range_y);
                 %disp(end_range_x);
                 %disp(end_range_y);

                 % read the phantom
                imdata = imread('./test.png');
                %figure(1);imshow(imdata); title('Original Image');

                % grey scale
                imdata = im2gray(imdata);
                %figure(2);imshow(imdata); title('Grey Scale');

                % get the fourier transform with zero padding of 1k by 1k
                fourier_t = fft2(imdata, 1280, 1280);

                % shift the k-space
                fourier_shift = fftshift(fourier_t);

                cropped_ft = fourier_shift(start_range_x:end_range_x, start_range_y:end_range_y);
                reconstruction = ifft2(cropped_ft);

                %disp(x_range);
                %disp(y_range);

                scaled = reconstruction(1:x_range, 1:y_range);
                abs_scaled = abs(scaled);
                stretchedImage = imresize(abs_scaled, [256 256]);

                target_x = x_range*5;
                target_y = y_range*5;
                targetSize = [target_x target_y];

                 win1 = centerCropWindow2d(size(fourier_shift),targetSize);

                 B1 = imcrop(abs(log(fourier_shift)), win1);
                 B1 = imresize(B1, [256 256]);
                 %Generate Sample K-Space for Cartesian
                 imshow(B1, [], 'parent', app.SampledKSpaceImage);

                %figure(2);imshow(abs(scaled), []); title('Scaled Image');
                %figure(4);imshow(abs(reconstruction), []); title('Reconstructed Image');
                idiff = stretchedImage;
                %Generate Reconstructed image for Cartesian
                imshow(stretchedImage, [], 'parent', app.ReconstructedImage);
            end

            %Reconstruction image panel
            app.PhantomtypeTextArea.Value = app.PhantomButtonGroup.SelectedObject.Text;
            app.MethodTextArea.Value = app.SamplingButtonGroup.SelectedObject.Text;
            numLine = app.oflinesEditField.Value;
            pointsPerLine = app.ofpointsperlineEditField.Value;
            
            app.outputNumLinesEditField.Value = numLine
            app.outputPointsPerLineEditField.Value = pointsPerLine
        end

        % Selection changed function: PhantomButtonGroup
        function PhantomButtonGroupSelectionChanged(app, event)
            switch app.PhantomButtonGroup.SelectedObject.Text
                case 'Phantom1Button'
                    val = 1;
                case 'Phantom2Button'
                    val = 2;
                otherwise
                    val = 0;
            end
        end

        % Selection changed function: SamplingButtonGroup
        function SamplingButtonGroupSelectionChanged(app, event)
            switch app.SamplingButtonGroup.SelectedObject.Text
                case 'RadialButton'
                    val = 1; 
                case 'CartesianButton'
                    val = 2;
                otherwise
                    val = 0;
            end
        end

        % Button pushed function: CompareImageButton
        function CompareImageButtonPushed(app, event)
            a = app.oflinesEditField.Value;
            b = app.ofpointsperlineEditField.Value;
            [x,y] = meshgrid(-a:b,-a:b);
            z = sqrt(x.^2+y.^2);
            c = (z<15);
            cf = fftshift(fft2(c));
            cf1 = log(1+abs(cf));
            m = max(cf1(:));
            %Generate Sampled K-Space for Radial
            imshow(im2uint8(cf1/m), [], 'parent', app.SampledKSpaceImage);
            o_img = imread('./test.png');
            idiff = 0;
            
            %Reconstructed image using Radial Sampling
            if(app.RadialButton.Value == 1)
                img = imread('./test.png');
                if(a >= 16) && (a < 64)
                    if(b >= 16) && (b < 64)
                        theta1 = 0:10:170;
                    else
                        theta1 = 0:10:180;
                    end
                    [R1,~] = radon(img,theta1); 
                    num_angles_R1 = size(R1,2)
                    N_R1 = size(R1,1)
                    P_512 = img;
                    [R_512,xp_512] = radon(P_512,theta1);
                    N_512 = size(R_512,1)
                    output_size = max(size(img));
                    dtheta1 = theta1(2) - theta1(1);
                    I1 = iradon(R1,dtheta1,output_size);
                    idiff = I1;
                    %%Generate Sampled K-Space for Radial
                    imshow(I1, [], 'parent', app.ReconstructedImage);

                elseif(a >= 64) && (a <= 128)
                    if(b >= 64) && (b <= 128)
                        theta2 = 0:5:175;
                    else
                        theta2 = 0:4.9:180;
                    end
                    [R2,~] = radon(img,theta2);
                    num_angles_R2 = size(R2,2)
                    N_R2 = size(R2,1)
                    P_512 = img;
                    [R_512,xp_512] = radon(P_512,theta2);
                    N_512 = size(R_512,1)
                    output_size = max(size(img));
                    dtheta1 = theta2(2) - theta2(1);
                    I2 = iradon(R2,dtheta1,output_size);
                    idiff = I2;
                    %%Generate K-Space for Radial image
                    imshow(I2, [], 'parent', app.ReconstructedImage);
                else
                    if(a > 128) && (b > 128)
                        theta3 = 0:2:178;
                    else
                        theta3 = 0:2.5:178;
                    end
                    [R3,xp] = radon(img,theta3); 
                    num_angles = size(R3,2)
                    N_R = size(R3,1)
                    P_512 = img;
                    [R_512,xp_512] = radon(P_512,theta3);
                    N_512 = size(R_512,1)
                    output_size = max(size(img));
                    dtheta = theta3(2) - theta3(1);
                    I3 = iradon(R3,dtheta,output_size);
                    idiff = I3;
                    %%Generate Sampled K-Space for Radial image
                    imshow(I3, [], 'parent', app.ReconstructedImage);
                end

            else                
                 % Reconstructed image using Cartesian sampling 
                 num_lines = app.oflinesEditField.Value;
                 num_points = app.ofpointsperlineEditField.Value;

                 x_range = num_lines;
                 y_range = num_points;

                 start_range_x = int64(640 - (num_lines*2.5));
                 start_range_y = int64(640 - (num_points*2.5));

                 % index starts at 1
                 if(start_range_x == 0)
                     start_range_x = 1;
                 end
                 if(start_range_y == 0)
                     start_range_y = 1;
                 end

                 end_range_x = int64(640 + (num_lines*2.5));
                 end_range_y = int64(640 + (num_points*2.5));

                 %disp(start_range_x);
                 %disp(start_range_y);
                 %disp(end_range_x);
                 %disp(end_range_y);

                 % read the phantom
                imdata = imread('./test.png');
                %figure(1);imshow(imdata); title('Original Image');

                % grey scale
                imdata = im2gray(imdata);
                %figure(2);imshow(imdata); title('Grey Scale');

                % get the fourier transform with zero padding of 1k by 1k
                fourier_t = fft2(imdata, 1280, 1280);

                % shift the k-space
                fourier_shift = fftshift(fourier_t);

                cropped_ft = fourier_shift(start_range_x:end_range_x, start_range_y:end_range_y);
                reconstruction = ifft2(cropped_ft);

                %disp(x_range);
                %disp(y_range);

                scaled = reconstruction(1:x_range, 1:y_range);
                abs_scaled = abs(scaled);
                stretchedImage = imresize(abs_scaled, [256 256]);

                target_x = x_range*5;
                target_y = y_range*5;
                targetSize = [target_x target_y];

                 win1 = centerCropWindow2d(size(fourier_shift),targetSize);

                 B1 = imcrop(abs(log(fourier_shift)), win1);
                 B1 = imresize(B1, [256 256]);
                 %Generate Sample K-Space for Cartesian
                 imshow(B1, [], 'parent', app.SampledKSpaceImage);

                %figure(2);imshow(abs(scaled), []); title('Scaled Image');
                %figure(4);imshow(abs(reconstruction), []); title('Reconstructed Image');
                idiff = stretchedImage;
                %Generate Reconstructed image for Cartesian
                imshow(stretchedImage, [], 'parent', app.ReconstructedImage);
            end

            imshowpair(o_img,idiff,'diff');
            title('Difference Between Phantom and Reconstructed');
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MRIAcquisitionSimulatorUIFigure and hide until all components are created
            app.MRIAcquisitionSimulatorUIFigure = uifigure('Visible', 'off');
            app.MRIAcquisitionSimulatorUIFigure.Color = [0 0 0];
            app.MRIAcquisitionSimulatorUIFigure.Position = [100 100 1523 858];
            app.MRIAcquisitionSimulatorUIFigure.Name = 'MRI Acquisition Simulator';

            % Create MRIACQUISITIONSIMULATORLabel
            app.MRIACQUISITIONSIMULATORLabel = uilabel(app.MRIAcquisitionSimulatorUIFigure);
            app.MRIACQUISITIONSIMULATORLabel.BackgroundColor = [0.8 0.8 0.8];
            app.MRIACQUISITIONSIMULATORLabel.HorizontalAlignment = 'center';
            app.MRIACQUISITIONSIMULATORLabel.FontName = 'Verdana';
            app.MRIACQUISITIONSIMULATORLabel.FontWeight = 'bold';
            app.MRIACQUISITIONSIMULATORLabel.Position = [626 787 334 51];
            app.MRIACQUISITIONSIMULATORLabel.Text = 'MRI ACQUISITION SIMULATOR';

            % Create GeneratePhantomButton
            app.GeneratePhantomButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.GeneratePhantomButton.ButtonPushedFcn = createCallbackFcn(app, @GeneratePhantomButtonPushed, true);
            app.GeneratePhantomButton.Position = [135 52 173 53];
            app.GeneratePhantomButton.Text = 'Generate Phantom';

            % Create PhantomPanel
            app.PhantomPanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.PhantomPanel.ForegroundColor = [1 1 1];
            app.PhantomPanel.Title = 'Phantom';
            app.PhantomPanel.BackgroundColor = [0 0 0];
            app.PhantomPanel.FontName = 'Verdana';
            app.PhantomPanel.FontAngle = 'italic';
            app.PhantomPanel.Position = [61 126 311 345];

            % Create PhantomButtonGroup
            app.PhantomButtonGroup = uibuttongroup(app.PhantomPanel);
            app.PhantomButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @PhantomButtonGroupSelectionChanged, true);
            app.PhantomButtonGroup.ForegroundColor = [1 1 1];
            app.PhantomButtonGroup.BorderType = 'none';
            app.PhantomButtonGroup.BackgroundColor = [0 0 0];
            app.PhantomButtonGroup.FontName = 'Verdana';
            app.PhantomButtonGroup.Position = [4 209 290 94];

            % Create Phantom1Button
            app.Phantom1Button = uiradiobutton(app.PhantomButtonGroup);
            app.Phantom1Button.Text = 'Phantom 1';
            app.Phantom1Button.FontName = 'Verdana';
            app.Phantom1Button.FontColor = [1 1 1];
            app.Phantom1Button.Position = [11 68 87 22];
            app.Phantom1Button.Value = true;

            % Create Phantom2Button
            app.Phantom2Button = uiradiobutton(app.PhantomButtonGroup);
            app.Phantom2Button.Text = 'Phantom 2';
            app.Phantom2Button.FontName = 'Verdana';
            app.Phantom2Button.FontColor = [1 1 1];
            app.Phantom2Button.Position = [201 68 87 22];

            % Create Rectangular
            app.Rectangular = uiimage(app.PhantomButtonGroup);
            app.Rectangular.Position = [16 13 77 59];
            app.Rectangular.ImageSource = 'phantom1.png';

            % Create Circular
            app.Circular = uiimage(app.PhantomButtonGroup);
            app.Circular.Position = [205 13 80 57];
            app.Circular.ImageSource = 'phantom2.png';

            % Create RectangularstructuresizePanel
            app.RectangularstructuresizePanel = uipanel(app.PhantomPanel);
            app.RectangularstructuresizePanel.ForegroundColor = [1 1 1];
            app.RectangularstructuresizePanel.BorderType = 'none';
            app.RectangularstructuresizePanel.Title = 'Rectangular structure size';
            app.RectangularstructuresizePanel.BackgroundColor = [0 0 0];
            app.RectangularstructuresizePanel.FontName = 'Verdana';
            app.RectangularstructuresizePanel.Position = [4 62 306 134];

            % Create WidthSliderLabel
            app.WidthSliderLabel = uilabel(app.RectangularstructuresizePanel);
            app.WidthSliderLabel.HorizontalAlignment = 'right';
            app.WidthSliderLabel.FontName = 'Verdana';
            app.WidthSliderLabel.FontColor = [1 1 1];
            app.WidthSliderLabel.Position = [10 82 40 22];
            app.WidthSliderLabel.Text = 'Width';

            % Create WidthSlider
            app.WidthSlider = uislider(app.RectangularstructuresizePanel);
            app.WidthSlider.Limits = [0 50];
            app.WidthSlider.MajorTicks = [0 10 20 30 40 50 60 70 80];
            app.WidthSlider.FontName = 'Verdana';
            app.WidthSlider.FontColor = [1 1 1];
            app.WidthSlider.Position = [71 91 186 3];

            % Create LengthSliderLabel
            app.LengthSliderLabel = uilabel(app.RectangularstructuresizePanel);
            app.LengthSliderLabel.HorizontalAlignment = 'right';
            app.LengthSliderLabel.FontName = 'Verdana';
            app.LengthSliderLabel.FontColor = [1 1 1];
            app.LengthSliderLabel.Position = [5 40 47 22];
            app.LengthSliderLabel.Text = 'Length';

            % Create LengthSlider
            app.LengthSlider = uislider(app.RectangularstructuresizePanel);
            app.LengthSlider.Limits = [0 50];
            app.LengthSlider.MajorTicks = [0 10 20 30 40 50 60 70 80];
            app.LengthSlider.FontName = 'Verdana';
            app.LengthSlider.FontColor = [1 1 1];
            app.LengthSlider.Position = [73 49 186 3];

            % Create PhantomImagePanel
            app.PhantomImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.PhantomImagePanel.ForegroundColor = [1 1 1];
            app.PhantomImagePanel.Title = 'Phantom image';
            app.PhantomImagePanel.BackgroundColor = [0 0 0];
            app.PhantomImagePanel.FontName = 'Verdana';
            app.PhantomImagePanel.FontAngle = 'italic';
            app.PhantomImagePanel.Position = [60 488 313 283];

            % Create PhantomImage
            app.PhantomImage = uiaxes(app.PhantomImagePanel);
            zlabel(app.PhantomImage, 'Z')
            app.PhantomImage.FontName = 'Verdana';
            app.PhantomImage.XColor = [1 1 1];
            app.PhantomImage.YColor = [1 1 1];
            app.PhantomImage.BoxStyle = 'full';
            app.PhantomImage.GridColor = [0 0 0];
            app.PhantomImage.Position = [1 -2 298 251];

            % Create KSpaceImagePanel
            app.KSpaceImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.KSpaceImagePanel.ForegroundColor = [1 1 1];
            app.KSpaceImagePanel.Title = 'K-Space image';
            app.KSpaceImagePanel.BackgroundColor = [0 0 0];
            app.KSpaceImagePanel.FontName = 'Verdana';
            app.KSpaceImagePanel.FontAngle = 'italic';
            app.KSpaceImagePanel.Position = [404 486 313 283];

            % Create KSpaceImage
            app.KSpaceImage = uiaxes(app.KSpaceImagePanel);
            zlabel(app.KSpaceImage, 'Z')
            app.KSpaceImage.FontName = 'Verdana';
            app.KSpaceImage.XColor = [1 1 1];
            app.KSpaceImage.YColor = [1 1 1];
            app.KSpaceImage.GridColor = [0.15 0.15 0.15];
            app.KSpaceImage.Position = [1 -2 298 251];

            % Create SampledKSpaceImagePanel
            app.SampledKSpaceImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.SampledKSpaceImagePanel.ForegroundColor = [1 1 1];
            app.SampledKSpaceImagePanel.Title = 'Sampled K-Space image';
            app.SampledKSpaceImagePanel.BackgroundColor = [0 0 0];
            app.SampledKSpaceImagePanel.FontName = 'Verdana';
            app.SampledKSpaceImagePanel.FontAngle = 'italic';
            app.SampledKSpaceImagePanel.Position = [746 488 313 283];

            % Create SampledKSpaceImage
            app.SampledKSpaceImage = uiaxes(app.SampledKSpaceImagePanel);
            zlabel(app.SampledKSpaceImage, 'Z')
            app.SampledKSpaceImage.FontName = 'Verdana';
            app.SampledKSpaceImage.XColor = [1 1 1];
            app.SampledKSpaceImage.YColor = [1 1 1];
            app.SampledKSpaceImage.GridColor = [0.15 0.15 0.15];
            app.SampledKSpaceImage.Position = [1 -2 298 251];

            % Create ReconstructedImagePanel
            app.ReconstructedImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.ReconstructedImagePanel.ForegroundColor = [1 1 1];
            app.ReconstructedImagePanel.Title = 'Reconstructed image';
            app.ReconstructedImagePanel.BackgroundColor = [0 0 0];
            app.ReconstructedImagePanel.FontName = 'Verdana';
            app.ReconstructedImagePanel.FontAngle = 'italic';
            app.ReconstructedImagePanel.Position = [1098 486 313 283];

            % Create ReconstructedImage
            app.ReconstructedImage = uiaxes(app.ReconstructedImagePanel);
            zlabel(app.ReconstructedImage, 'Z')
            app.ReconstructedImage.FontName = 'Verdana';
            app.ReconstructedImage.XColor = [1 1 1];
            app.ReconstructedImage.YColor = [1 1 1];
            app.ReconstructedImage.GridColor = [0.15 0.15 0.15];
            app.ReconstructedImage.Position = [1 -2 298 251];

            % Create DisplayKSpaceButton
            app.DisplayKSpaceButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.DisplayKSpaceButton.ButtonPushedFcn = createCallbackFcn(app, @DisplayKSpaceButtonPushed, true);
            app.DisplayKSpaceButton.Position = [473 376 173 53];
            app.DisplayKSpaceButton.Text = 'Display K-Space';

            % Create SamplingPanel
            app.SamplingPanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.SamplingPanel.ForegroundColor = [1 1 1];
            app.SamplingPanel.Title = 'Sampling';
            app.SamplingPanel.BackgroundColor = [0 0 0];
            app.SamplingPanel.FontName = 'Verdana';
            app.SamplingPanel.FontAngle = 'italic';
            app.SamplingPanel.Position = [747 126 311 345];

            % Create SamplingButtonGroup
            app.SamplingButtonGroup = uibuttongroup(app.SamplingPanel);
            app.SamplingButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @SamplingButtonGroupSelectionChanged, true);
            app.SamplingButtonGroup.ForegroundColor = [1 1 1];
            app.SamplingButtonGroup.BorderType = 'none';
            app.SamplingButtonGroup.BackgroundColor = [0 0 0];
            app.SamplingButtonGroup.FontName = 'Verdana';
            app.SamplingButtonGroup.Position = [4 209 290 94];

            % Create RadialButton
            app.RadialButton = uiradiobutton(app.SamplingButtonGroup);
            app.RadialButton.Text = 'Radial';
            app.RadialButton.FontName = 'Verdana';
            app.RadialButton.FontColor = [1 1 1];
            app.RadialButton.Position = [11 68 59 22];
            app.RadialButton.Value = true;

            % Create CartesianButton
            app.CartesianButton = uiradiobutton(app.SamplingButtonGroup);
            app.CartesianButton.Text = 'Cartesian';
            app.CartesianButton.FontName = 'Verdana';
            app.CartesianButton.FontColor = [1 1 1];
            app.CartesianButton.Position = [201 68 79 22];

            % Create Radial
            app.Radial = uiimage(app.SamplingButtonGroup);
            app.Radial.Position = [13 13 60 54];
            app.Radial.ImageSource = 'radial.png';

            % Create Cartesian
            app.Cartesian = uiimage(app.SamplingButtonGroup);
            app.Cartesian.Position = [209 13 60 58];
            app.Cartesian.ImageSource = 'cartesian.png';

            % Create oflinesEditFieldLabel
            app.oflinesEditFieldLabel = uilabel(app.SamplingPanel);
            app.oflinesEditFieldLabel.BackgroundColor = [0 0 0];
            app.oflinesEditFieldLabel.HorizontalAlignment = 'right';
            app.oflinesEditFieldLabel.FontName = 'Verdana';
            app.oflinesEditFieldLabel.FontColor = [1 1 1];
            app.oflinesEditFieldLabel.Position = [60 135 63 22];
            app.oflinesEditFieldLabel.Text = '# of lines';

            % Create oflinesEditField
            app.oflinesEditField = uieditfield(app.SamplingPanel, 'numeric');
            app.oflinesEditField.Limits = [16 256];
            app.oflinesEditField.HorizontalAlignment = 'center';
            app.oflinesEditField.FontName = 'Verdana';
            app.oflinesEditField.FontColor = [1 1 1];
            app.oflinesEditField.BackgroundColor = [0 0 0];
            app.oflinesEditField.Position = [138 127 167 38];
            app.oflinesEditField.Value = 16;

            % Create ofpointsperlineEditFieldLabel
            app.ofpointsperlineEditFieldLabel = uilabel(app.SamplingPanel);
            app.ofpointsperlineEditFieldLabel.BackgroundColor = [0 0 0];
            app.ofpointsperlineEditFieldLabel.HorizontalAlignment = 'right';
            app.ofpointsperlineEditFieldLabel.FontName = 'Verdana';
            app.ofpointsperlineEditFieldLabel.FontColor = [1 1 1];
            app.ofpointsperlineEditFieldLabel.Position = [3 77 121 22];
            app.ofpointsperlineEditFieldLabel.Text = '# of points per line';

            % Create ofpointsperlineEditField
            app.ofpointsperlineEditField = uieditfield(app.SamplingPanel, 'numeric');
            app.ofpointsperlineEditField.Limits = [16 256];
            app.ofpointsperlineEditField.HorizontalAlignment = 'center';
            app.ofpointsperlineEditField.FontName = 'Verdana';
            app.ofpointsperlineEditField.FontColor = [1 1 1];
            app.ofpointsperlineEditField.BackgroundColor = [0 0 0];
            app.ofpointsperlineEditField.Position = [139 69 167 38];
            app.ofpointsperlineEditField.Value = 16;

            % Create RunAcquisitionButton
            app.RunAcquisitionButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.RunAcquisitionButton.ButtonPushedFcn = createCallbackFcn(app, @RunAcquisitionButtonPushed, true);
            app.RunAcquisitionButton.Position = [816 52 173 53];
            app.RunAcquisitionButton.Text = 'Run Acquisition';

            % Create AcquisitionPanel
            app.AcquisitionPanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.AcquisitionPanel.ForegroundColor = [1 1 1];
            app.AcquisitionPanel.Title = 'Acquisition';
            app.AcquisitionPanel.BackgroundColor = [0 0 0];
            app.AcquisitionPanel.FontName = 'Verdana';
            app.AcquisitionPanel.FontAngle = 'italic';
            app.AcquisitionPanel.Position = [1099 126 311 345];

            % Create oflinesEditField_2Label
            app.oflinesEditField_2Label = uilabel(app.AcquisitionPanel);
            app.oflinesEditField_2Label.BackgroundColor = [0 0 0];
            app.oflinesEditField_2Label.HorizontalAlignment = 'center';
            app.oflinesEditField_2Label.FontName = 'Verdana';
            app.oflinesEditField_2Label.FontColor = [1 1 1];
            app.oflinesEditField_2Label.Position = [91 133 63 22];
            app.oflinesEditField_2Label.Text = '# of lines';

            % Create outputNumLinesEditField
            app.outputNumLinesEditField = uieditfield(app.AcquisitionPanel, 'numeric');
            app.outputNumLinesEditField.Editable = 'off';
            app.outputNumLinesEditField.HorizontalAlignment = 'center';
            app.outputNumLinesEditField.FontName = 'Verdana';
            app.outputNumLinesEditField.FontColor = [1 1 1];
            app.outputNumLinesEditField.BackgroundColor = [0.8 0.8 0.8];
            app.outputNumLinesEditField.Position = [169 125 95 38];

            % Create ofpointsperlineEditField_2Label
            app.ofpointsperlineEditField_2Label = uilabel(app.AcquisitionPanel);
            app.ofpointsperlineEditField_2Label.BackgroundColor = [0 0 0];
            app.ofpointsperlineEditField_2Label.HorizontalAlignment = 'right';
            app.ofpointsperlineEditField_2Label.FontName = 'Verdana';
            app.ofpointsperlineEditField_2Label.FontColor = [1 1 1];
            app.ofpointsperlineEditField_2Label.Position = [35 77 121 22];
            app.ofpointsperlineEditField_2Label.Text = '# of points per line';

            % Create outputPointsPerLineEditField
            app.outputPointsPerLineEditField = uieditfield(app.AcquisitionPanel, 'numeric');
            app.outputPointsPerLineEditField.Editable = 'off';
            app.outputPointsPerLineEditField.HorizontalAlignment = 'center';
            app.outputPointsPerLineEditField.FontName = 'Verdana';
            app.outputPointsPerLineEditField.FontColor = [1 1 1];
            app.outputPointsPerLineEditField.BackgroundColor = [0.8 0.8 0.8];
            app.outputPointsPerLineEditField.Position = [170 69 94 38];

            % Create SamplingLabel
            app.SamplingLabel = uilabel(app.AcquisitionPanel);
            app.SamplingLabel.FontName = 'Verdana';
            app.SamplingLabel.FontColor = [1 1 1];
            app.SamplingLabel.Position = [17 224 80 27];
            app.SamplingLabel.Text = 'Sampling';

            % Create PhantomtypeTextAreaLabel
            app.PhantomtypeTextAreaLabel = uilabel(app.AcquisitionPanel);
            app.PhantomtypeTextAreaLabel.BackgroundColor = [0 0 0];
            app.PhantomtypeTextAreaLabel.HorizontalAlignment = 'right';
            app.PhantomtypeTextAreaLabel.FontName = 'Verdana';
            app.PhantomtypeTextAreaLabel.FontColor = [1 1 1];
            app.PhantomtypeTextAreaLabel.Position = [12 274 89 22];
            app.PhantomtypeTextAreaLabel.Text = 'Phantom type';

            % Create PhantomtypeTextArea
            app.PhantomtypeTextArea = uitextarea(app.AcquisitionPanel);
            app.PhantomtypeTextArea.Editable = 'off';
            app.PhantomtypeTextArea.HorizontalAlignment = 'center';
            app.PhantomtypeTextArea.FontName = 'Verdana';
            app.PhantomtypeTextArea.FontColor = [1 1 1];
            app.PhantomtypeTextArea.BackgroundColor = [0 0 0];
            app.PhantomtypeTextArea.Position = [116 272 172 26];

            % Create MethodTextAreaLabel
            app.MethodTextAreaLabel = uilabel(app.AcquisitionPanel);
            app.MethodTextAreaLabel.BackgroundColor = [0 0 0];
            app.MethodTextAreaLabel.HorizontalAlignment = 'right';
            app.MethodTextAreaLabel.FontName = 'Verdana';
            app.MethodTextAreaLabel.FontColor = [1 1 1];
            app.MethodTextAreaLabel.Position = [104 191 50 22];
            app.MethodTextAreaLabel.Text = 'Method';

            % Create MethodTextArea
            app.MethodTextArea = uitextarea(app.AcquisitionPanel);
            app.MethodTextArea.Editable = 'off';
            app.MethodTextArea.HorizontalAlignment = 'center';
            app.MethodTextArea.FontName = 'Verdana';
            app.MethodTextArea.FontColor = [1 1 1];
            app.MethodTextArea.BackgroundColor = [0 0 0];
            app.MethodTextArea.Position = [169 182 95 33];

            % Create CompareImageButton
            app.CompareImageButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.CompareImageButton.ButtonPushedFcn = createCallbackFcn(app, @CompareImageButtonPushed, true);
            app.CompareImageButton.Position = [1168 52 173 53];
            app.CompareImageButton.Text = 'Compare Image';

            % Show the figure after all components are created
            app.MRIAcquisitionSimulatorUIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MRIAcquisitionSimulatorUIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MRIAcquisitionSimulatorUIFigure)
        end
    end
end