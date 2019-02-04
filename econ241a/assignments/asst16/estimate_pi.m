function [pi_est] = estimate_pi(draws, reps)
%%  Estimate pi using Monte Carlo integration
%   Draws random x, y points from U(0, 1) and computes proportion that fall 
%   within a unit circle; multiply this by 4 to get an estimate for pi.
%   Arguments:
%     draws = number of (x, y) points to draw in sample
%     reps  = number of samples to draw and compute
%   Returned value:
%     A vector of pi estimates, of length equal to reps.

    % Assign random values to 3-d matrix; last dimension is 2 to contain [x y]
    xy_matrix = rand(draws, reps, 2);

    % Calculate distance from zero for each (x, y) point
    xy_dist = xy_matrix(:, :, 1).^2 + xy_matrix(:, :, 2).^2;

    % For each rep, sum the points within the circle, and divide by draws.
    pi_est = 4 * sum(xy_dist < 1) / draws;

end