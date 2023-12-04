classdef GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        MRIAcquisitionSimulator          matlab.ui.Figure
        MRIACQUISITIONSIMULATOR          matlab.ui.control.Label

        PhantomImagePanel                matlab.ui.container.Panel
        PhantomImage                     matlab.ui.control.UIAxes
        PhantomPanel                     matlab.ui.container.Panel
        PhantomButtonGroup               matlab.ui.container.ButtonGroup
        Phantom1Button                   matlab.ui.control.RadioButton
        Phantom2Button                   matlab.ui.control.RadioButton
        Phantom1Image                    matlab.ui.control.Image
        Phantom2Image                    matlab.ui.control.Image
        Phantom1SizePanel                matlab.ui.container.Panel
        WidthSliderLabel                 matlab.ui.control.Label
        WidthSlider                      matlab.ui.control.Slider
        LengthSliderLabel                matlab.ui.control.Label
        LengthSlider                     matlab.ui.control.Slider
        GeneratePhantom                  matlab.ui.control.Button

        KSpaceImagePanel                 matlab.ui.container.Panel
        KSpaceImage                      matlab.ui.control.UIAxes
        DisplayKSpace                    matlab.ui.control.Button

        SampledKSpaceImagePanel          matlab.ui.container.Panel
        SampledKSpaceImage               matlab.ui.control.UIAxes
        SamplingPanel                    matlab.ui.container.Panel
        SamplingButtonGroup              matlab.ui.container.ButtonGroup
        RadialButton                     matlab.ui.control.RadioButton
        CartesianButton                  matlab.ui.control.RadioButton
        RadialImage                      matlab.ui.control.Image
        CartesianImage                   matlab.ui.control.Image
        NumberOfLinesLabel            matlab.ui.control.Label
        NumberOfLines                 matlab.ui.control.NumericEditField
        PointsPerLineLabel    matlab.ui.control.Label
        PointsPerLine         matlab.ui.control.NumericEditField
        RunAcquisition                   matlab.ui.control.Button

        ReconstructedImagePanel          matlab.ui.container.Panel
        ReconstructedImage               matlab.ui.control.UIAxes
        AcquisitionPanel                 matlab.ui.container.Panel
        PhantomtypeTextAreaLabel         matlab.ui.control.Label
        PhantomtypeTextArea              matlab.ui.control.TextArea
        SamplingLabel                    matlab.ui.control.Label
        MethodTextAreaLabel              matlab.ui.control.Label
        MethodTextArea                   matlab.ui.control.TextArea
        NumberOfLinesLabel_2          matlab.ui.control.Label
        outputNumberOfLines          matlab.ui.control.NumericEditField
        PointsPerLineLabel_2  matlab.ui.control.Label
        outputPointsPerLine     matlab.ui.control.NumericEditField
        CompareImage                     matlab.ui.control.Button
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            %-------------------0------------------
            % Create MRI Acquisition Simulator UI Figure
            app.MRIAcquisitionSimulator = uifigure('Visible', 'off');
            app.MRIAcquisitionSimulator.Color = [1 0.85 0.7];
            app.MRIAcquisitionSimulator.Position = [100 100 900 600];
            app.MRIAcquisitionSimulator.Name = 'MRI Acquisition Simulator';

            % Create MRI ACQUISITION SIMULATOR Label
            app.MRIACQUISITIONSIMULATOR = uilabel(app.MRIAcquisitionSimulator);
            app.MRIACQUISITIONSIMULATOR.BackgroundColor = [0.8 0.6 1];
            app.MRIACQUISITIONSIMULATOR.HorizontalAlignment = 'center';
            app.MRIACQUISITIONSIMULATOR.FontName = 'Arial';
            app.MRIACQUISITIONSIMULATOR.FontWeight = 'bold';
            app.MRIACQUISITIONSIMULATOR.Position = [540 750 320 53];
            app.MRIACQUISITIONSIMULATOR.Text = 'MRI ACQUISITION SIMULATOR';
            app.MRIACQUISITIONSIMULATOR.FontColor = [0.5 0 0];

            %-------------------1------------------
            % Create Phantom Image Panel
            app.PhantomImagePanel = uipanel(app.MRIAcquisitionSimulator);
            app.PhantomImagePanel.ForegroundColor = [128/255 0 0];
            app.PhantomImagePanel.Title = 'Phantom Image';
            app.PhantomImagePanel.FontWeight = 'bold';
            app.PhantomImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.PhantomImagePanel.FontName = 'Arial';
            app.PhantomImagePanel.FontAngle = 'italic';
            app.PhantomImagePanel.Position = [60 463 313 283];
            app.PhantomImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.PhantomImagePanel.BorderWidth = 2;

            % Create Phantom Image
            app.PhantomImage = uiaxes(app.PhantomImagePanel);
            zlabel(app.PhantomImage, 'Z')
            app.PhantomImage.FontName = 'Arial';
            app.PhantomImage.XColor = [0 0 0];
            app.PhantomImage.YColor = [0 0 0];
            app.PhantomImage.BoxStyle = 'full';
            app.PhantomImage.GridColor = [0 0 0];
            app.PhantomImage.Position = [1 -2 298 251];

            % Create Phantom Panel
            app.PhantomPanel = uipanel(app.MRIAcquisitionSimulator);
            app.PhantomPanel.ForegroundColor = [128/255 0 0];
            app.PhantomPanel.Title = 'Phantom';
            app.PhantomPanel.FontWeight = 'bold';
            app.PhantomPanel.BackgroundColor = [0.9 0.9 0.2];
            app.PhantomPanel.FontName = 'Arial';
            app.PhantomPanel.FontAngle = 'italic';
            app.PhantomPanel.Position = [61 106 311 345];
            app.PhantomPanel.BorderType = 'line';
            app.PhantomPanel.BorderColor = [0.6 0.6 0.6];  
            app.PhantomPanel.BorderWidth = 2;

            % Create Phantom Button Group
            app.PhantomButtonGroup = uibuttongroup(app.PhantomPanel);
            app.PhantomButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @PhantomButtonGroupSelection, true);
            app.PhantomButtonGroup.ForegroundColor = [0 0.5 0];
            app.PhantomButtonGroup.BorderType = 'none';
            app.PhantomButtonGroup.BackgroundColor = [1 1 0.5];
            app.PhantomButtonGroup.FontName = 'Arial';
            app.PhantomButtonGroup.Position = [11 223 290 95];

            % Create Phantom1 Button
            app.Phantom1Button = uiradiobutton(app.PhantomButtonGroup);
            app.Phantom1Button.Text = 'Phantom 1';
            app.Phantom1Button.FontName = 'Arial';
            app.Phantom1Button.FontWeight = 'bold';
            app.Phantom1Button.FontColor = [0 0.5 0];
            app.Phantom1Button.Position = [11 68 87 22];
            app.Phantom1Button.Value = true;

            % Create Phantom2 Button
            app.Phantom2Button = uiradiobutton(app.PhantomButtonGroup);
            app.Phantom2Button.Text = 'Phantom 2';
            app.Phantom2Button.FontName = 'Arial';
            app.Phantom2Button.FontWeight = 'bold';
            app.Phantom2Button.FontColor = [0 0.5 0];
            app.Phantom2Button.Position = [201 68 87 22];
 
            % Create Phantom1 Image
            app.Phantom1Image = uiimage(app.PhantomButtonGroup);
            app.Phantom1Image.Position = [16 13 77 59];
            app.Phantom1Image.ImageSource = 'phantom1.png';

            % Create Phantom2 Image
            app.Phantom2Image = uiimage(app.PhantomButtonGroup);
            app.Phantom2Image.Position = [205 13 80 57];
            app.Phantom2Image.ImageSource = 'phantom2.png';

            % Create Phantom1 Size Panel
            app.Phantom1SizePanel = uipanel(app.PhantomPanel);
            app.Phantom1SizePanel.ForegroundColor = [0 0.5 0];
            app.Phantom1SizePanel.BorderType = 'none';
            app.Phantom1SizePanel.FontWeight = 'bold';
            app.Phantom1SizePanel.Title = 'Rectangular structure size of Phantom1';
            app.Phantom1SizePanel.BackgroundColor = [1 1 0.5];
            app.Phantom1SizePanel.FontName = 'Arial';
            app.Phantom1SizePanel.Position = [10 70 303 134];

            % Create Width Slider Label
            app.WidthSliderLabel = uilabel(app.Phantom1SizePanel);
            app.WidthSliderLabel.HorizontalAlignment = 'right';
            app.WidthSliderLabel.FontName = 'Arial';
            app.WidthSliderLabel.FontWeight = 'bold';
            app.WidthSliderLabel.FontColor = [0 0.5 0];
            app.WidthSliderLabel.Position = [10 82 40 22];
            app.WidthSliderLabel.Text = 'Width';

            % Create Width Slider
            app.WidthSlider = uislider(app.Phantom1SizePanel);
            app.WidthSlider.Limits = [0 100];
            app.WidthSlider.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            app.WidthSlider.FontWeight = 'bold';
            app.WidthSlider.FontName = 'Arial';
            app.WidthSlider.FontColor = [0 0.5 0];
            app.WidthSlider.Position = [71 91 186 3];

            % Create Length Slider Label
            app.LengthSliderLabel = uilabel(app.Phantom1SizePanel);
            app.LengthSliderLabel.HorizontalAlignment = 'right';
            app.LengthSliderLabel.FontName = 'Arial';
            app.LengthSliderLabel.FontWeight = 'bold';
            app.LengthSliderLabel.FontColor = [0 0.5 0];
            app.LengthSliderLabel.Position = [5 40 47 22];
            app.LengthSliderLabel.Text = 'Length';

            % Create Length Slider
            app.LengthSlider = uislider(app.Phantom1SizePanel);
            app.LengthSlider.Limits = [0 100];
            app.LengthSlider.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            app.LengthSlider.FontName = 'Arial';
            app.LengthSlider.FontColor = [0 0.5 0];
            app.LengthSlider.FontWeight = 'bold';
            app.LengthSlider.Position = [73 49 186 3];

            % Create Generate Phantom Button
            app.GeneratePhantom = uibutton(app.MRIAcquisitionSimulator, 'push');
            app.GeneratePhantom.ButtonPushedFcn = createCallbackFcn(app, @GeneratePhantomPushed, true);
            app.GeneratePhantom.Position = [135 40 173 53];
            app.GeneratePhantom.Text = 'Generate Phantom';
            app.GeneratePhantom.FontColor = [128/255 0 0];
            app.GeneratePhantom.FontWeight = 'bold';
            app.GeneratePhantom.BackgroundColor = [0.65, 0.85, 0.65]; 
            
            %-------------------2------------------
            % Create KSpace Image Panel
            app.KSpaceImagePanel = uipanel(app.MRIAcquisitionSimulator);
            app.KSpaceImagePanel.ForegroundColor = [128/255 0 0];
            app.KSpaceImagePanel.Title = 'K-Space Image of Phantom';
            app.KSpaceImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.KSpaceImagePanel.FontName = 'Arial';
            app.KSpaceImagePanel.FontWeight = 'bold';
            app.KSpaceImagePanel.FontAngle = 'italic';
            app.KSpaceImagePanel.Position = [404 457 313 283];
            app.KSpaceImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.KSpaceImagePanel.BorderWidth = 2;

            % Create KSpace Image
            app.KSpaceImage = uiaxes(app.KSpaceImagePanel);
            zlabel(app.KSpaceImage, 'Z')
            app.KSpaceImage.FontName = 'Arial';
            app.KSpaceImage.XColor = [0 0 0];
            app.KSpaceImage.YColor = [0 0 0];
            app.KSpaceImage.GridColor = [0.15 0.15 0.15];
            app.KSpaceImage.Position = [1 -2 298 251];

            % Create Display KSpace Button
            app.DisplayKSpace = uibutton(app.MRIAcquisitionSimulator, 'push');
            app.DisplayKSpace.ButtonPushedFcn = createCallbackFcn(app, @DisplayKSpacePushed, true);
            app.DisplayKSpace.Position = [473 376 173 53];
            app.DisplayKSpace.Text = 'Display K-Space';
            app.DisplayKSpace.FontColor = [128/255 0 0];
            app.DisplayKSpace.FontWeight = 'bold';
            app.DisplayKSpace.BackgroundColor = [0.65, 0.85, 0.65]; 

            %-------------------3------------------
            % Create Sampled KSpace Image Panel
            app.SampledKSpaceImagePanel = uipanel(app.MRIAcquisitionSimulator);
            app.SampledKSpaceImagePanel.ForegroundColor = [128/255 0 0];
            app.SampledKSpaceImagePanel.Title = 'Sampled K-Space Image of Phantom';
            app.SampledKSpaceImagePanel.FontWeight = 'bold';
            app.SampledKSpaceImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.SampledKSpaceImagePanel.FontName = 'Arial';
            app.SampledKSpaceImagePanel.FontAngle = 'italic';
            app.SampledKSpaceImagePanel.Position = [746 457 313 283];
            app.SampledKSpaceImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.SampledKSpaceImagePanel.BorderWidth = 2;

            % Create Sampled KSpace Image
            app.SampledKSpaceImage = uiaxes(app.SampledKSpaceImagePanel);
            zlabel(app.SampledKSpaceImage, 'Z')
            app.SampledKSpaceImage.FontName = 'Arial';
            app.SampledKSpaceImage.XColor = [0 0 0];
            app.SampledKSpaceImage.YColor = [0 0 0];
            app.SampledKSpaceImage.GridColor = [0.15 0.15 0.15];
            app.SampledKSpaceImage.Position = [1 -2 298 251];

            % Create Sampling Panel
            app.SamplingPanel = uipanel(app.MRIAcquisitionSimulator);
            app.SamplingPanel.ForegroundColor = [128/255 0 0];
            app.SamplingPanel.Title = 'Select type of Sampling';
            app.SamplingPanel.BackgroundColor = [0.9 0.9 0.2];
            app.SamplingPanel.FontName = 'Arial';
            app.SamplingPanel.FontWeight = 'bold';
            app.SamplingPanel.FontAngle = 'italic';
            app.SamplingPanel.Position = [747 100 311 345];
            app.SamplingPanel.BorderColor = [0.6 0.6 0.6];  
            app.SamplingPanel.BorderWidth = 2;

            % Create Sampling Button Group
            app.SamplingButtonGroup = uibuttongroup(app.SamplingPanel);
            app.SamplingButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @SamplingButtonGroupSelection, true);
            app.SamplingButtonGroup.ForegroundColor = [0 0.5 0];
            app.SamplingButtonGroup.BorderType = 'none';
            app.SamplingButtonGroup.BackgroundColor = [1 1 0.5];
            app.SamplingButtonGroup.FontName = 'Arial';
            app.SamplingButtonGroup.Position = [13 209 290 94];

            % Create Radial Button
            app.RadialButton = uiradiobutton(app.SamplingButtonGroup);
            app.RadialButton.Text = 'Radial';
            app.RadialButton.FontName = 'Arial';
            app.RadialButton.FontColor = [0 0.5 0];
            app.RadialButton.FontWeight = 'bold';
            app.RadialButton.Position = [11 68 59 22];
            app.RadialButton.Value = true;

            % Create Cartesian Button
            app.CartesianButton = uiradiobutton(app.SamplingButtonGroup);
            app.CartesianButton.Text = 'Cartesian';
            app.CartesianButton.FontName = 'Arial';
            app.CartesianButton.FontColor = [0 0.5 0];
            app.CartesianButton.FontWeight = 'bold';
            app.CartesianButton.Position = [201 68 79 22];

            % Create Radial Image
            app.RadialImage = uiimage(app.SamplingButtonGroup);
            app.RadialImage.Position = [13 13 60 54];
            app.RadialImage.ImageSource = 'radial.png';

            % Create Cartesian Image
            app.CartesianImage = uiimage(app.SamplingButtonGroup);
            app.CartesianImage.Position = [209 10 60 58];
            app.CartesianImage.ImageSource = 'cartesian.png';

            % Create oflinesEditFieldLabel
            app.NumberOfLinesLabel = uilabel(app.SamplingPanel);
            app.NumberOfLinesLabel.HorizontalAlignment = 'right';
            app.NumberOfLinesLabel.FontName = 'Arial';
            app.NumberOfLinesLabel.FontColor = [0 0.5 0];
            app.NumberOfLinesLabel.FontWeight = 'bold';
            app.NumberOfLinesLabel.Position = [60 135 63 22];
            app.NumberOfLinesLabel.Text = '# of lines:';

            % Create oflinesEditField
            app.NumberOfLines = uieditfield(app.SamplingPanel, 'numeric');
            app.NumberOfLines.Limits = [16 256];
            app.NumberOfLines.HorizontalAlignment = 'center';
            app.NumberOfLines.FontName = 'Arial';
            app.NumberOfLines.FontWeight = 'bold';
            app.NumberOfLines.FontColor = [128/255 0 0];
            app.NumberOfLines.BackgroundColor = [1 1 0.5];
            app.NumberOfLines.Position = [138 127 167 38];
            app.NumberOfLines.Value = 16;

            % Create ofpointsperlineEditFieldLabel
            app.PointsPerLineLabel = uilabel(app.SamplingPanel);
            app.PointsPerLineLabel.HorizontalAlignment = 'right';
            app.PointsPerLineLabel.FontName = 'Arial';
            app.PointsPerLineLabel.FontColor = [0 0.5 0];
            app.PointsPerLineLabel.FontWeight = 'bold';
            app.PointsPerLineLabel.Position = [3 77 121 22];
            app.PointsPerLineLabel.Text = '# of points per line:';

            % Create ofpointsperlineEditField
            app.PointsPerLine = uieditfield(app.SamplingPanel, 'numeric');
            app.PointsPerLine.Limits = [16 256];
            app.PointsPerLine.HorizontalAlignment = 'center';
            app.PointsPerLine.FontName = 'Arial';
            app.PointsPerLine.FontWeight = 'bold';
            app.PointsPerLine.FontColor = [128/255 0 0];
            app.PointsPerLine.BackgroundColor = [1 1 0.5];
            app.PointsPerLine.Position = [139 69 167 38];
            app.PointsPerLine.Value = 16;

            % Create Run Acquisition Button
            app.RunAcquisition = uibutton(app.MRIAcquisitionSimulator, 'push');
            app.RunAcquisition.ButtonPushedFcn = createCallbackFcn(app, @RunAcquisitionPushed, true);
            app.RunAcquisition.Position = [816 33 173 53];
            app.RunAcquisition.Text = 'Run Acquisition';
            app.RunAcquisition.FontColor = [128/255 0 0];
            app.RunAcquisition.FontWeight = 'bold';
            app.RunAcquisition.BackgroundColor = [0.65, 0.85, 0.65]; 

            %-------------------4------------------
            % Create Reconstructed Image Panel
            app.ReconstructedImagePanel = uipanel(app.MRIAcquisitionSimulator);
            app.ReconstructedImagePanel.ForegroundColor = [128/255 0 0];
            app.ReconstructedImagePanel.Title = 'Reconstructed image';
            app.ReconstructedImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.ReconstructedImagePanel.FontName = 'Arial';
            app.ReconstructedImagePanel.FontWeight = 'bold';
            app.ReconstructedImagePanel.FontAngle = 'italic';
            app.ReconstructedImagePanel.Position = [1098 457 313 283];
            app.ReconstructedImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.ReconstructedImagePanel.BorderWidth = 2;

            % Create Reconstructed Image
            app.ReconstructedImage = uiaxes(app.ReconstructedImagePanel);
            zlabel(app.ReconstructedImage, 'Z')
            app.ReconstructedImage.FontName = 'Arial';
            app.ReconstructedImage.XColor = [0 0 0];
            app.ReconstructedImage.YColor = [0 0 0];
            app.ReconstructedImage.GridColor = [0.15 0.15 0.15];
            app.ReconstructedImage.Position = [1 -2 298 251];

            % Create Acquisition Panel
            app.AcquisitionPanel = uipanel(app.MRIAcquisitionSimulator);
            app.AcquisitionPanel.ForegroundColor = [128/255 0 0];
            app.AcquisitionPanel.Title = 'Image Acquisition';
            app.AcquisitionPanel.BackgroundColor = [0.9 0.9 0.2];
            app.AcquisitionPanel.FontName = 'Arial';
            app.AcquisitionPanel.FontWeight = 'bold';
            app.AcquisitionPanel.FontAngle = 'italic';
            app.AcquisitionPanel.Position = [1099 100 311 345];
            app.AcquisitionPanel.BorderColor = [0.6 0.6 0.6];  
            app.AcquisitionPanel.BorderWidth = 2;

            % Create Phantomtype Text Area Label
            app.PhantomtypeTextAreaLabel = uilabel(app.AcquisitionPanel);
            app.PhantomtypeTextAreaLabel.HorizontalAlignment = 'right';
            app.PhantomtypeTextAreaLabel.FontName = 'Arial';
            app.PhantomtypeTextAreaLabel.FontWeight = 'bold';
            app.PhantomtypeTextAreaLabel.FontColor = [0 0.5 0];
            app.PhantomtypeTextAreaLabel.Position = [12 274 89 22];
            app.PhantomtypeTextAreaLabel.Text = 'Phantom Type:';

            % Create Phantomtype Text Area
            app.PhantomtypeTextArea = uitextarea(app.AcquisitionPanel);
            app.PhantomtypeTextArea.Editable = 'off';
            app.PhantomtypeTextArea.HorizontalAlignment = 'center';
            app.PhantomtypeTextArea.FontName = 'Arial';
            app.PhantomtypeTextArea.FontWeight = 'bold';
            app.PhantomtypeTextArea.FontColor = [128/255 0 0];
            app.PhantomtypeTextArea.BackgroundColor = [1 1 0.5];
            app.PhantomtypeTextArea.Position = [116 272 172 26];

            % Create Sampling Label
            app.SamplingLabel = uilabel(app.AcquisitionPanel);
            app.SamplingLabel.FontName = 'Arial';
            app.SamplingLabel.FontColor = [0 0.5 0];
            app.SamplingLabel.FontWeight = 'bold';
            app.SamplingLabel.Position = [17 224 80 27];
            app.SamplingLabel.Text = 'Sampling:';

            % Create Method Text Area Label
            app.MethodTextAreaLabel = uilabel(app.AcquisitionPanel);
            app.MethodTextAreaLabel.HorizontalAlignment = 'right';
            app.MethodTextAreaLabel.FontName = 'Arial';
            app.MethodTextAreaLabel.FontWeight = 'bold';
            app.MethodTextAreaLabel.FontColor = [0 0.5 0];
            app.MethodTextAreaLabel.Position = [104 191 50 22];
            app.MethodTextAreaLabel.Text = 'Method:';

            % Create Method Text Area
            app.MethodTextArea = uitextarea(app.AcquisitionPanel);
            app.MethodTextArea.Editable = 'off';
            app.MethodTextArea.HorizontalAlignment = 'center';
            app.MethodTextArea.FontName = 'Arial';
            app.MethodTextArea.FontWeight = 'bold';
            app.MethodTextArea.FontColor = [128/255 0 0];
            app.MethodTextArea.BackgroundColor = [1 1 0.5];
            app.MethodTextArea.Position = [169 182 95 33];

            % Create oflinesEditField_2Label
            app.NumberOfLinesLabel_2 = uilabel(app.AcquisitionPanel);
            app.NumberOfLinesLabel_2.HorizontalAlignment = 'center';
            app.NumberOfLinesLabel_2.FontName = 'Arial';
            app.NumberOfLinesLabel_2.FontWeight = 'bold';
            app.NumberOfLinesLabel_2.FontColor = [0 0.5 0];
            app.NumberOfLinesLabel_2.Position = [91 133 63 22];
            app.NumberOfLinesLabel_2.Text = '# of lines:';

            % Create outputNumLinesEditField
            app.outputNumberOfLines = uieditfield(app.AcquisitionPanel, 'numeric');
            app.outputNumberOfLines.Editable = 'off';
            app.outputNumberOfLines.HorizontalAlignment = 'center';
            app.outputNumberOfLines.FontName = 'Arial';
            app.outputNumberOfLines.FontWeight = 'bold';
            app.outputNumberOfLines.FontColor = [128/255 0 0];
            app.outputNumberOfLines.BackgroundColor = [1 1 0.5];
            app.outputNumberOfLines.Position = [169 125 95 38];

            % Create ofpointsperlineEditField_2Label
            app.PointsPerLineLabel_2 = uilabel(app.AcquisitionPanel);
            app.PointsPerLineLabel_2.HorizontalAlignment = 'right';
            app.PointsPerLineLabel_2.FontName = 'Arial';
            app.PointsPerLineLabel_2.FontWeight = 'bold';
            app.PointsPerLineLabel_2.FontColor = [0 0.5 0];
            app.PointsPerLineLabel_2.Position = [35 77 121 22];
            app.PointsPerLineLabel_2.Text = '# of points per line:';

            % Create outputPointsPerLineEditField
            app.outputPointsPerLine = uieditfield(app.AcquisitionPanel, 'numeric');
            app.outputPointsPerLine.Editable = 'off';
            app.outputPointsPerLine.HorizontalAlignment = 'center';
            app.outputPointsPerLine.FontName = 'Arial';
            app.outputPointsPerLine.FontWeight = 'bold';
            app.outputPointsPerLine.FontColor = [128/255 0 0];
            app.outputPointsPerLine.BackgroundColor = [1 1 0.5];
            app.outputPointsPerLine.Position = [170 69 94 38];

            % Create Compare Image Button
            app.CompareImage = uibutton(app.MRIAcquisitionSimulator, 'push');
            app.CompareImage.ButtonPushedFcn = createCallbackFcn(app, @CompareImagePushed, true);
            app.CompareImage.Position = [1168 33 173 53];
            app.CompareImage.Text = 'Compare Image';
            app.CompareImage.FontColor = [128/255 0 0];
            app.CompareImage.FontWeight = 'bold';
            app.CompareImage.BackgroundColor = [0.65, 0.85, 0.65];

            % Show the figure after all components are created
            app.MRIAcquisitionSimulator.Visible = 'on';
        end
    end

    methods (Access = private)
            % PhantomButtonGroup: switch between Phanton1 and Phanton2
            function PhantomButtonGroupSelection(app, ~)
            switch app.PhantomButtonGroup.SelectedObject.Text
                case 'Phantom1Button'
                    val = 1;
                case 'Phantom2Button'
                    val = 2;
                otherwise
                    val = 0;
            end
        end

        % SamplingButtonGroup: switch between Radial and Cartesian
        function SamplingButtonGroupSelection(app, ~)
            switch app.SamplingButtonGroup.SelectedObject.Text
                case 'RadialButton'
                    val = 1; 
                case 'CartesianButton'
                    val = 2;
                otherwise
                    val = 0;
            end
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GUI

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.MRIAcquisitionSimulator)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.MRIAcquisitionSimulator)
        end
    end
end
