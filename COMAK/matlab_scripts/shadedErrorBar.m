function shadedErrorBar(x, y, errBar, lineProps, color, transparent)
    % Create a shaded error bar plot with customizable colors.
    %
    % Parameters:
    %   x           - X data points.
    %   y           - Y data points.
    %   errBar      - Error bar data points.
    %   lineProps   - Line properties.
    %   color       - Color for the line and the shaded area (optional).
    %   transparent - Transparency value for the shaded area (default 0.3).

    if nargin < 6
        transparent = 0.2; % Default transparency
    end

    % Plot mean line
    if nargin >= 4 && ~isempty(lineProps)
        plot(x, y, lineProps{:});
    else
        plot(x, y);
    end
    hold on;

    % Plot shaded error bar
    if nargin >= 5 && ~isempty(color)
        fill([x(:); flipud(x(:))], [y(:) + errBar(:); flipud(y(:) - errBar(:))], color, ...
            'FaceAlpha', transparent, 'EdgeColor', 'none');
    else
        fill([x(:); flipud(x(:))], [y(:) + errBar(:); flipud(y(:) - errBar(:))], ...
            'r', 'FaceAlpha', transparent, 'EdgeColor', 'none'); % Default blue color
    end
end
