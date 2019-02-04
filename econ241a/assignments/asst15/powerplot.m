function [] = powerplot(n)
% Iterates over each sample size in n, and generates a plot of power at
% different z values from 0 to 2
% Inputs: n = vector of different n values to plot
% Output: none

    % Set up vector of values for x axis, and an empty pwr array
    x_vals = -3:.02:3;

    pwr = zeros(length(x_vals), length(n));

    % For each x value, calc power at all given n values (since power_n
    % function can accept multiple n values, we can calc all at once)
    for i = 1:length(x_vals)
        pwr(i, :) = beta_n(n, x_vals(i));
    end
    
    % Plot the array of powers at each n against the x values
    plot(x_vals, pwr, 'linewidth', 2)
    legend(cellstr(num2str(n', 'n = %-d')))
    title('Power for sample mean for different n')

end