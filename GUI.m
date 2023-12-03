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
% Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create MRIAcquisitionSimulatorUIFigure and hide until all components are created
            app.MRIAcquisitionSimulatorUIFigure = uifigure('Visible', 'off');
            app.MRIAcquisitionSimulatorUIFigure.Color = [1 0.85 0.7];
            app.MRIAcquisitionSimulatorUIFigure.Position = [100 100 900 600];
            app.MRIAcquisitionSimulatorUIFigure.Name = 'MRI Acquisition Simulator';

            % Create MRIACQUISITIONSIMULATORLabel
            app.MRIACQUISITIONSIMULATORLabel = uilabel(app.MRIAcquisitionSimulatorUIFigure);
            app.MRIACQUISITIONSIMULATORLabel.BackgroundColor = [0.8 0.6 1];
            app.MRIACQUISITIONSIMULATORLabel.HorizontalAlignment = 'center';
            app.MRIACQUISITIONSIMULATORLabel.FontName = 'Arial';
            app.MRIACQUISITIONSIMULATORLabel.FontWeight = 'bold';
            app.MRIACQUISITIONSIMULATORLabel.Position = [540 750 320 53];
            app.MRIACQUISITIONSIMULATORLabel.Text = 'MRI ACQUISITION SIMULATOR';
            app.MRIACQUISITIONSIMULATORLabel.FontColor = [0.5 0 0];

            % Create GeneratePhantomButton
            app.GeneratePhantomButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.GeneratePhantomButton.ButtonPushedFcn = createCallbackFcn(app, @GeneratePhantomButtonPushed, true);
            app.GeneratePhantomButton.Position = [135 40 173 53];
            app.GeneratePhantomButton.Text = 'Generate Phantom';
            app.GeneratePhantomButton.FontColor = [128/255 0 0];
            app.GeneratePhantomButton.FontWeight = 'bold';
            app.GeneratePhantomButton.BackgroundColor = [0.65, 0.85, 0.65]; 
            
            % Create PhantomPanel
            app.PhantomPanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
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

            % Create PhantomButtonGroup
            app.PhantomButtonGroup = uibuttongroup(app.PhantomPanel);
            app.PhantomButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @PhantomButtonGroupSelectionChanged, true);
            app.PhantomButtonGroup.ForegroundColor = [0 0.5 0];
            app.PhantomButtonGroup.BorderType = 'none';
            app.PhantomButtonGroup.BackgroundColor = [1 1 0.5];
            app.PhantomButtonGroup.FontName = 'Arial';
            app.PhantomButtonGroup.Position = [11 223 290 95];

            % Create Phantom1Button
            app.Phantom1Button = uiradiobutton(app.PhantomButtonGroup);
            app.Phantom1Button.Text = 'Phantom 1';
            app.Phantom1Button.FontName = 'Arial';
            app.Phantom1Button.FontWeight = 'bold';
            app.Phantom1Button.FontColor = [0 0.5 0];
            app.Phantom1Button.Position = [11 68 87 22];
            app.Phantom1Button.Value = true;

            % Create Phantom2Button
            app.Phantom2Button = uiradiobutton(app.PhantomButtonGroup);
            app.Phantom2Button.Text = 'Phantom 2';
            app.Phantom2Button.FontName = 'Arial';
            app.Phantom2Button.FontWeight = 'bold';
            app.Phantom2Button.FontColor = [0 0.5 0];
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
            app.RectangularstructuresizePanel.ForegroundColor = [0 0.5 0];
            app.RectangularstructuresizePanel.BorderType = 'none';
            app.RectangularstructuresizePanel.FontWeight = 'bold';
            app.RectangularstructuresizePanel.Title = 'Rectangular structure size';
            app.RectangularstructuresizePanel.BackgroundColor = [1 1 0.5];
            app.RectangularstructuresizePanel.FontName = 'Arial';
            app.RectangularstructuresizePanel.Position = [10 70 303 134];

            % Create WidthSliderLabel
            app.WidthSliderLabel = uilabel(app.RectangularstructuresizePanel);
            app.WidthSliderLabel.HorizontalAlignment = 'right';
            app.WidthSliderLabel.FontName = 'Arial';
            app.WidthSliderLabel.FontWeight = 'bold';
            app.WidthSliderLabel.FontColor = [0 0.5 0];
            app.WidthSliderLabel.Position = [10 82 40 22];
            app.WidthSliderLabel.Text = 'Width';

            % Create WidthSlider
            app.WidthSlider = uislider(app.RectangularstructuresizePanel);
            app.WidthSlider.Limits = [0 100];
            app.WidthSlider.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            app.WidthSlider.FontWeight = 'bold';
            app.WidthSlider.FontName = 'Arial';
            app.WidthSlider.FontColor = [0 0.5 0];
            app.WidthSlider.Position = [71 91 186 3];

            % Create LengthSliderLabel
            app.LengthSliderLabel = uilabel(app.RectangularstructuresizePanel);
            app.LengthSliderLabel.HorizontalAlignment = 'right';
            app.LengthSliderLabel.FontName = 'Arial';
            app.LengthSliderLabel.FontWeight = 'bold';
            app.LengthSliderLabel.FontColor = [0 0.5 0];
            app.LengthSliderLabel.Position = [5 40 47 22];
            app.LengthSliderLabel.Text = 'Length';

            % Create LengthSlider
            app.LengthSlider = uislider(app.RectangularstructuresizePanel);
            app.LengthSlider.Limits = [0 100];
            app.LengthSlider.MajorTicks = [0 10 20 30 40 50 60 70 80 90 100];
            app.LengthSlider.FontName = 'Arial';
            app.LengthSlider.FontColor = [0 0.5 0];
            app.LengthSlider.FontWeight = 'bold';
            app.LengthSlider.Position = [73 49 186 3];

            % Create PhantomImagePanel
            app.PhantomImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.PhantomImagePanel.ForegroundColor = [128/255 0 0];
            app.PhantomImagePanel.Title = 'Phantom Image';
            app.PhantomImagePanel.FontWeight = 'bold';
            app.PhantomImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.PhantomImagePanel.FontName = 'Arial';
            app.PhantomImagePanel.FontAngle = 'italic';
            app.PhantomImagePanel.Position = [60 463 313 283];
            app.PhantomImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.PhantomImagePanel.BorderWidth = 2;

            % Create PhantomImage
            app.PhantomImage = uiaxes(app.PhantomImagePanel);
            zlabel(app.PhantomImage, 'Z')
            app.PhantomImage.FontName = 'Arial';
            app.PhantomImage.XColor = [0 0 0];
            app.PhantomImage.YColor = [0 0 0];
            app.PhantomImage.BoxStyle = 'full';
            app.PhantomImage.GridColor = [0 0 0];
            app.PhantomImage.Position = [1 -2 298 251];

            % Create KSpaceImagePanel
            app.KSpaceImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.KSpaceImagePanel.ForegroundColor = [128/255 0 0];
            app.KSpaceImagePanel.Title = 'K-Space Image of Phantom';
            app.KSpaceImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.KSpaceImagePanel.FontName = 'Arial';
            app.KSpaceImagePanel.FontWeight = 'bold';
            app.KSpaceImagePanel.FontAngle = 'italic';
            app.KSpaceImagePanel.Position = [404 457 313 283];
            app.KSpaceImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.KSpaceImagePanel.BorderWidth = 2;

            % Create KSpaceImage
            app.KSpaceImage = uiaxes(app.KSpaceImagePanel);
            zlabel(app.KSpaceImage, 'Z')
            app.KSpaceImage.FontName = 'Arial';
            app.KSpaceImage.XColor = [0 0 0];
            app.KSpaceImage.YColor = [0 0 0];
            app.KSpaceImage.GridColor = [0.15 0.15 0.15];
            app.KSpaceImage.Position = [1 -2 298 251];

            % Create DisplayKSpaceButton
            app.DisplayKSpaceButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.DisplayKSpaceButton.ButtonPushedFcn = createCallbackFcn(app, @DisplayKSpaceButtonPushed, true);
            app.DisplayKSpaceButton.Position = [473 376 173 53];
            app.DisplayKSpaceButton.Text = 'Display K-Space';
            app.DisplayKSpaceButton.FontColor = [128/255 0 0];
            app.DisplayKSpaceButton.FontWeight = 'bold';
            app.DisplayKSpaceButton.BackgroundColor = [0.65, 0.85, 0.65]; 

            % Create SampledKSpaceImagePanel
            app.SampledKSpaceImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.SampledKSpaceImagePanel.ForegroundColor = [128/255 0 0];
            app.SampledKSpaceImagePanel.Title = 'Sampled K-Space Image of Phantom';
            app.SampledKSpaceImagePanel.FontWeight = 'bold';
            app.SampledKSpaceImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.SampledKSpaceImagePanel.FontName = 'Arial';
            app.SampledKSpaceImagePanel.FontAngle = 'italic';
            app.SampledKSpaceImagePanel.Position = [746 457 313 283];
            app.SampledKSpaceImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.SampledKSpaceImagePanel.BorderWidth = 2;

            % Create SampledKSpaceImage
            app.SampledKSpaceImage = uiaxes(app.SampledKSpaceImagePanel);
            zlabel(app.SampledKSpaceImage, 'Z')
            app.SampledKSpaceImage.FontName = 'Arial';
            app.SampledKSpaceImage.XColor = [0 0 0];
            app.SampledKSpaceImage.YColor = [0 0 0];
            app.SampledKSpaceImage.GridColor = [0.15 0.15 0.15];
            app.SampledKSpaceImage.Position = [1 -2 298 251];

            % Create ReconstructedImagePanel
            app.ReconstructedImagePanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.ReconstructedImagePanel.ForegroundColor = [128/255 0 0];
            app.ReconstructedImagePanel.Title = 'Reconstructed image';
            app.ReconstructedImagePanel.BackgroundColor = [0.9 0.9 0.2];
            app.ReconstructedImagePanel.FontName = 'Arial';
            app.ReconstructedImagePanel.FontWeight = 'bold';
            app.ReconstructedImagePanel.FontAngle = 'italic';
            app.ReconstructedImagePanel.Position = [1098 457 313 283];
            app.ReconstructedImagePanel.BorderColor = [0.6 0.6 0.6];  
            app.ReconstructedImagePanel.BorderWidth = 2;

            % Create ReconstructedImage
            app.ReconstructedImage = uiaxes(app.ReconstructedImagePanel);
            zlabel(app.ReconstructedImage, 'Z')
            app.ReconstructedImage.FontName = 'Arial';
            app.ReconstructedImage.XColor = [0 0 0];
            app.ReconstructedImage.YColor = [0 0 0];
            app.ReconstructedImage.GridColor = [0.15 0.15 0.15];
            app.ReconstructedImage.Position = [1 -2 298 251];

            % Create SamplingPanel
            app.SamplingPanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.SamplingPanel.ForegroundColor = [128/255 0 0];
            app.SamplingPanel.Title = 'Select type of Sampling';
            app.SamplingPanel.BackgroundColor = [0.9 0.9 0.2];
            app.SamplingPanel.FontName = 'Arial';
            app.SamplingPanel.FontWeight = 'bold';
            app.SamplingPanel.FontAngle = 'italic';
            app.SamplingPanel.Position = [747 100 311 345];
            app.SamplingPanel.BorderColor = [0.6 0.6 0.6];  
            app.SamplingPanel.BorderWidth = 2;

            % Create SamplingButtonGroup
            app.SamplingButtonGroup = uibuttongroup(app.SamplingPanel);
            app.SamplingButtonGroup.SelectionChangedFcn = createCallbackFcn(app, @SamplingButtonGroupSelectionChanged, true);
            app.SamplingButtonGroup.ForegroundColor = [0 0.5 0];
            app.SamplingButtonGroup.BorderType = 'none';
            app.SamplingButtonGroup.BackgroundColor = [1 1 0.5];
            app.SamplingButtonGroup.FontName = 'Arial';
            app.SamplingButtonGroup.Position = [13 209 290 94];

            % Create RadialButton
            app.RadialButton = uiradiobutton(app.SamplingButtonGroup);
            app.RadialButton.Text = 'Radial';
            app.RadialButton.FontName = 'Arial';
            app.RadialButton.FontColor = [0 0.5 0];
            app.RadialButton.FontWeight = 'bold';
            app.RadialButton.Position = [11 68 59 22];
            app.RadialButton.Value = true;

            % Create CartesianButton
            app.CartesianButton = uiradiobutton(app.SamplingButtonGroup);
            app.CartesianButton.Text = 'Cartesian';
            app.CartesianButton.FontName = 'Arial';
            app.CartesianButton.FontColor = [0 0.5 0];
            app.CartesianButton.FontWeight = 'bold';
            app.CartesianButton.Position = [201 68 79 22];

            % Create Radial
            app.Radial = uiimage(app.SamplingButtonGroup);
            app.Radial.Position = [13 13 60 54];
            app.Radial.ImageSource = 'radial.png';

            % Create Cartesian
            app.Cartesian = uiimage(app.SamplingButtonGroup);
            app.Cartesian.Position = [209 10 60 58];
            app.Cartesian.ImageSource = 'cartesian.png';

            % Create oflinesEditFieldLabel
            app.oflinesEditFieldLabel = uilabel(app.SamplingPanel);
            app.oflinesEditFieldLabel.HorizontalAlignment = 'right';
            app.oflinesEditFieldLabel.FontName = 'Arial';
            app.oflinesEditFieldLabel.FontColor = [0 0.5 0];
            app.oflinesEditFieldLabel.FontWeight = 'bold';
            app.oflinesEditFieldLabel.Position = [60 135 63 22];
            app.oflinesEditFieldLabel.Text = '# of lines:';

            % Create oflinesEditField
            app.oflinesEditField = uieditfield(app.SamplingPanel, 'numeric');
            app.oflinesEditField.Limits = [16 256];
            app.oflinesEditField.HorizontalAlignment = 'center';
            app.oflinesEditField.FontName = 'Arial';
            app.oflinesEditField.FontWeight = 'bold';
            app.oflinesEditField.FontColor = [128/255 0 0];
            app.oflinesEditField.BackgroundColor = [1 1 0.5];
            app.oflinesEditField.Position = [138 127 167 38];
            app.oflinesEditField.Value = 16;

            % Create ofpointsperlineEditFieldLabel
            app.ofpointsperlineEditFieldLabel = uilabel(app.SamplingPanel);
            app.ofpointsperlineEditFieldLabel.HorizontalAlignment = 'right';
            app.ofpointsperlineEditFieldLabel.FontName = 'Arial';
            app.ofpointsperlineEditFieldLabel.FontColor = [0 0.5 0];
            app.ofpointsperlineEditFieldLabel.FontWeight = 'bold';
            app.ofpointsperlineEditFieldLabel.Position = [3 77 121 22];
            app.ofpointsperlineEditFieldLabel.Text = '# of points per line:';

            % Create ofpointsperlineEditField
            app.ofpointsperlineEditField = uieditfield(app.SamplingPanel, 'numeric');
            app.ofpointsperlineEditField.Limits = [16 256];
            app.ofpointsperlineEditField.HorizontalAlignment = 'center';
            app.ofpointsperlineEditField.FontName = 'Arial';
            app.ofpointsperlineEditField.FontWeight = 'bold';
            app.ofpointsperlineEditField.FontColor = [128/255 0 0];
            app.ofpointsperlineEditField.BackgroundColor = [1 1 0.5];
            app.ofpointsperlineEditField.Position = [139 69 167 38];
            app.ofpointsperlineEditField.Value = 16;

            % Create RunAcquisitionButton
            app.RunAcquisitionButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.RunAcquisitionButton.ButtonPushedFcn = createCallbackFcn(app, @RunAcquisitionButtonPushed, true);
            app.RunAcquisitionButton.Position = [816 33 173 53];
            app.RunAcquisitionButton.Text = 'Run Acquisition';
            app.RunAcquisitionButton.FontColor = [128/255 0 0];
            app.RunAcquisitionButton.FontWeight = 'bold';
            app.RunAcquisitionButton.BackgroundColor = [0.65, 0.85, 0.65]; 

            % Create AcquisitionPanel
            app.AcquisitionPanel = uipanel(app.MRIAcquisitionSimulatorUIFigure);
            app.AcquisitionPanel.ForegroundColor = [128/255 0 0];
            app.AcquisitionPanel.Title = 'Image Acquisition';
            app.AcquisitionPanel.BackgroundColor = [0.9 0.9 0.2];
            app.AcquisitionPanel.FontName = 'Arial';
            app.AcquisitionPanel.FontWeight = 'bold';
            app.AcquisitionPanel.FontAngle = 'italic';
            app.AcquisitionPanel.Position = [1099 100 311 345];
            app.AcquisitionPanel.BorderColor = [0.6 0.6 0.6];  
            app.AcquisitionPanel.BorderWidth = 2;

            % Create oflinesEditField_2Label
            app.oflinesEditField_2Label = uilabel(app.AcquisitionPanel);
            app.oflinesEditField_2Label.HorizontalAlignment = 'center';
            app.oflinesEditField_2Label.FontName = 'Arial';
            app.oflinesEditField_2Label.FontWeight = 'bold';
            app.oflinesEditField_2Label.FontColor = [0 0.5 0];
            app.oflinesEditField_2Label.Position = [91 133 63 22];
            app.oflinesEditField_2Label.Text = '# of lines:';

            % Create outputNumLinesEditField
            app.outputNumLinesEditField = uieditfield(app.AcquisitionPanel, 'numeric');
            app.outputNumLinesEditField.Editable = 'off';
            app.outputNumLinesEditField.HorizontalAlignment = 'center';
            app.outputNumLinesEditField.FontName = 'Arial';
            app.outputNumLinesEditField.FontWeight = 'bold';
            app.outputNumLinesEditField.FontColor = [128/255 0 0];
            app.outputNumLinesEditField.BackgroundColor = [1 1 0.5];
            app.outputNumLinesEditField.Position = [169 125 95 38];

            % Create ofpointsperlineEditField_2Label
            app.ofpointsperlineEditField_2Label = uilabel(app.AcquisitionPanel);
            app.ofpointsperlineEditField_2Label.HorizontalAlignment = 'right';
            app.ofpointsperlineEditField_2Label.FontName = 'Arial';
            app.ofpointsperlineEditField_2Label.FontWeight = 'bold';
            app.ofpointsperlineEditField_2Label.FontColor = [0 0.5 0];
            app.ofpointsperlineEditField_2Label.Position = [35 77 121 22];
            app.ofpointsperlineEditField_2Label.Text = '# of points per line:';

            % Create outputPointsPerLineEditField
            app.outputPointsPerLineEditField = uieditfield(app.AcquisitionPanel, 'numeric');
            app.outputPointsPerLineEditField.Editable = 'off';
            app.outputPointsPerLineEditField.HorizontalAlignment = 'center';
            app.outputPointsPerLineEditField.FontName = 'Arial';
            app.outputPointsPerLineEditField.FontWeight = 'bold';
            app.outputPointsPerLineEditField.FontColor = [128/255 0 0];
            app.outputPointsPerLineEditField.BackgroundColor = [1 1 0.5];
            app.outputPointsPerLineEditField.Position = [170 69 94 38];

            % Create SamplingLabel
            app.SamplingLabel = uilabel(app.AcquisitionPanel);
            app.SamplingLabel.FontName = 'Arial';
            app.SamplingLabel.FontColor = [0 0.5 0];
            app.SamplingLabel.FontWeight = 'bold';
            app.SamplingLabel.Position = [17 224 80 27];
            app.SamplingLabel.Text = 'Sampling:';

            % Create PhantomtypeTextAreaLabel
            app.PhantomtypeTextAreaLabel = uilabel(app.AcquisitionPanel);
            app.PhantomtypeTextAreaLabel.HorizontalAlignment = 'right';
            app.PhantomtypeTextAreaLabel.FontName = 'Arial';
            app.PhantomtypeTextAreaLabel.FontWeight = 'bold';
            app.PhantomtypeTextAreaLabel.FontColor = [0 0.5 0];
            app.PhantomtypeTextAreaLabel.Position = [12 274 89 22];
            app.PhantomtypeTextAreaLabel.Text = 'Phantom Type:';

            % Create PhantomtypeTextArea
            app.PhantomtypeTextArea = uitextarea(app.AcquisitionPanel);
            app.PhantomtypeTextArea.Editable = 'off';
            app.PhantomtypeTextArea.HorizontalAlignment = 'center';
            app.PhantomtypeTextArea.FontName = 'Arial';
            app.PhantomtypeTextArea.FontWeight = 'bold';
            app.PhantomtypeTextArea.FontColor = [128/255 0 0];
            app.PhantomtypeTextArea.BackgroundColor = [1 1 0.5];
            app.PhantomtypeTextArea.Position = [116 272 172 26];

            % Create MethodTextAreaLabel
            app.MethodTextAreaLabel = uilabel(app.AcquisitionPanel);
            app.MethodTextAreaLabel.HorizontalAlignment = 'right';
            app.MethodTextAreaLabel.FontName = 'Arial';
            app.MethodTextAreaLabel.FontWeight = 'bold';
            app.MethodTextAreaLabel.FontColor = [0 0.5 0];
            app.MethodTextAreaLabel.Position = [104 191 50 22];
            app.MethodTextAreaLabel.Text = 'Method:';

            % Create MethodTextArea
            app.MethodTextArea = uitextarea(app.AcquisitionPanel);
            app.MethodTextArea.Editable = 'off';
            app.MethodTextArea.HorizontalAlignment = 'center';
            app.MethodTextArea.FontName = 'Arial';
            app.MethodTextArea.FontWeight = 'bold';
            app.MethodTextArea.FontColor = [128/255 0 0];
            app.MethodTextArea.BackgroundColor = [1 1 0.5];
            app.MethodTextArea.Position = [169 182 95 33];

            % Create CompareImageButton
            app.CompareImageButton = uibutton(app.MRIAcquisitionSimulatorUIFigure, 'push');
            app.CompareImageButton.ButtonPushedFcn = createCallbackFcn(app, @CompareImageButtonPushed, true);
            app.CompareImageButton.Position = [1168 33 173 53];
            app.CompareImageButton.Text = 'Compare Image';
            app.CompareImageButton.FontColor = [128/255 0 0];
            app.CompareImageButton.FontWeight = 'bold';
            app.CompareImageButton.BackgroundColor = [0.65, 0.85, 0.65];

            % Show the figure after all components are created
            app.MRIAcquisitionSimulatorUIFigure.Visible = 'on';
        end
    end

    methods (Access = private)
            % Selection changed function: PhantomButtonGroup
        function PhantomButtonGroupSelectionChanged(app, ~)
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
        function SamplingButtonGroupSelectionChanged(app, ~)
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
