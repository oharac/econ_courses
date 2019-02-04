reps = 200;
draw_vals = [20:20:5000];

% initialize matrix for estimates
pi_est = zeros(length(draw_vals), reps);

% generate estimates in a loop
for i = 1:length(draw_vals)
    pi_est(i, :) = estimate_pi(draw_vals(i), reps);
end

% plot estimates and mean for each number of draws
pi_mean = mean(pi_est');

plot(draw_vals, pi_est, 'b.')
xlabel('Number of draws'); ylabel('Estimate for pi');
hold on;
plot(draw_vals, pi_mean, 'w', 'LineWidth', 4);
plot(draw_vals, pi_mean, 'r', 'LineWidth', 2);
hold off;
