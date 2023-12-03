% To draw a filled circle on a 2D canvas
function [updatedCanvas] = drawCircle(~, canvas, center, radius, color)
    % ~ is used to indicate that the function does not use the first input (often used as a placeholder)
    % canvas: the 2D matrix representing the drawing area
    % center: a 1x2 vector [x, y] specifying the center of the circle
    % radius: the radius of the circle
    % color: the intensity or color value to fill the circle
    
    % Calculating the starting and ending points on the x-axis
    xStart = center(1) - radius;
    xEnd = center(1) + radius;
    
    % Iterating through each point on the horizontal diameter of the circle
    for x = xStart : xEnd
        % get the distance to center point of x-axis
        x_to_cp = center(1) - x;
        % get the distance to center point of y-axis by x^2 + y^ = r^2
        y_to_cp = floor(sqrt(radius^2 - x_to_cp^2));
        % Calculating y-axis postion
        y = center(2) - y_to_cp : center(2) + y_to_cp;
        
        % Drawing a line in the canvas for the current x position
        canvas(x, y) = color;
    end
    
    % Updating the canvas after drawing the circle
    updatedCanvas = canvas;
end