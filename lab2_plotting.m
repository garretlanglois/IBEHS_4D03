% Define the data for the four reconstruction types (excluding "Original")
x = 1:4;  % indices for: Half, Blocks 50, Blocks 10, Every Other
y = [0.7541, 0.7740, 0.8184, 0.7879];  % Mean attenuation coefficients
err = [0.0164, 0.0261, 0.0230, 0.0191]; % Standard deviations

% Create a new figure with a white background
figure('Color', 'w', 'Position', [100 100 700 500]);

% Plot the scatter points with error bars, using a modern marker style
errorbar(x, y, err, 'o', 'MarkerSize', 10, ...
    'MarkerFaceColor', [0.2, 0.6, 0.8], 'MarkerEdgeColor', 'k', ...
    'LineWidth', 1.5, 'Color', [0.2, 0.6, 0.8]);
hold on;

% Calculate the line of best fit (linear fit)
p = polyfit(x, y, 1);  % First-order polynomial fit
x_fit = linspace(min(x), max(x), 100);
y_fit = polyval(p, x_fit);

% Plot the best fit line with a smooth, contrasting color
plot(x_fit, y_fit, '-r', 'LineWidth', 2);

% Customize the x-axis with descriptive labels for each reconstruction type
set(gca, 'XTick', 1:4, 'XTickLabel', {'Half','Blocks 50','Blocks 10','Every Other'}, ...
    'FontSize', 12, 'FontWeight', 'bold');

% Customize y-axis font
ylabel('Mean Attenuation Coefficient', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Reconstruction Type', 'FontSize', 14, 'FontWeight', 'bold');

% Add title with increased font size and bold weight
title('Attenuation Coefficients (Excluding Original) with Best Fit Line', ...
    'FontSize', 16, 'FontWeight', 'bold');

% Enhance grid appearance
grid on;
set(gca, 'GridLineStyle', '--', 'GridColor', [0.5, 0.5, 0.5], 'GridAlpha', 0.7);

% Optionally, set limits if desired (uncomment and adjust if needed)
% xlim([0.5, 4.5]);
% ylim([min(y)-0.05, max(y)+0.05]);

% Remove the box outline for a cleaner look
box off;

hold off;
