% Button pushed function: GeneratePhantomButton
function GeneratePhantomPushed(app, ~)
    % Setting the canvas size and initialize it with zeros
    canvasSize = [300, 300];
    canvas = zeros(canvasSize);

    % Calculating the center of the canvas
    centerPoint = [canvasSize(1)/2, canvasSize(2)/2];

    % Set radius of the background circle as 40% of the canvas's width
    backgroundCircleRadius = ceil(0.4 * canvasSize(1));

    % Draw the background circle on the canvas with a specified color
    canvas = drawCircle(app, canvas, centerPoint, backgroundCircleRadius, 150);
    
    % Converts the canvas to an 8-bit unsigned integer format (a common step in image processing)
    canvas = uint8(canvas);
    
    % Specifies the distance between each pair of inner circles
    innerCircleDistance = ceil(backgroundCircleRadius/5.4);
    
    % Phantom1
    if(app.Phantom1Button.Value == 1)
        width = app.WidthSlider.Value;
        length = app.LengthSlider.Value;
        
        if(width < 1)
            width = 50;
        end

        if(length < 1)
            length = 50;
        end

        square_size = floor([width*1.5 length*1.5]);

        % Fixed height (constant y with varying x)
        % starting point along x-axis
        x_start = floor(centerPoint(2) - square_size(2)/2);
        % ending point along x-axis
        x_end = floor(centerPoint(2) + square_size(2)/2);
        
        % Fixed width (fixed x with different y)
        y_start = floor(centerPoint(1) - square_size(1)/2);
        y_end = floor(centerPoint(1) + square_size(1)/2);

        % Draw the square to the canvas
        canvas(x_start : x_end, y_start : y_end) = 256;

    % Phantom2 (with 5 inner circle)
    else 
        % make an array of inner circles
        innerCircle = [];

        % creating inner circle 1
        innerCircle(1).center = [centerPoint(1), (centerPoint(2)- floor(4.5 * innerCircleDistance))];
        innerCircle(1).radius = ceil( min(canvasSize)/55);
        
        % creating inner circle 2
        innerCircle(2).center = [centerPoint(1), (centerPoint(2)- 3 * innerCircleDistance)];
        innerCircle(2).radius = floor(1.52 * innerCircle(1).radius);
        
        % creating inner circle 3
        innerCircle(3).center = [centerPoint(1), (centerPoint(2)- 1 * innerCircleDistance)];
        innerCircle(3).radius = floor(1.52 * innerCircle(2).radius);
        
        % creating inner circle 4
        innerCircle(4).center = [centerPoint(1), (centerPoint(2)) + innerCircleDistance];
        innerCircle(4).radius = floor(1.52 * innerCircle(3).radius);
        
        % creating inner circle 5
        innerCircle(5).center = [centerPoint(1), (centerPoint(2) + floor(3.5 * innerCircleDistance))];
        innerCircle(5).radius = floor(1.52 * innerCircle(4).radius);
        
        for i = 1:5
            % Drawing the inner circle on the canvas with a specified color
            canvas = drawCircle(app, canvas, innerCircle(i).center, innerCircle(i).radius, 250);
        end
    end
    
    % saving the phantom image to a png file
    imwrite(canvas,'./phantom.png');
    a = imread('./phantom.png');
    % displaying the input phantom image
    imshow(a,'parent', app.PhantomImage);
    
end