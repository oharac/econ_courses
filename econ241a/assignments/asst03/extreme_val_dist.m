function [] = extreme_val_dist(n_trials, n_samples)
% compute extreme value distribution, for given number of trials and 
% samples.  Prints mu, gamma, and beta estimates, and plots empirical
% density and theoretical pdf.

    s_max = zeros(n_trials, 1);

    for i = 1:n_trials
        samples = randn(n_samples, 1);
        s_max(i) = max(samples);
    end

    s_max_mean = mean(s_max);
    s_max_med  = median(s_max);

    mu = s_max_med + log(log(2))
    gamma = .5772
    beta = (s_max_mean - mu) / gamma

    x = 0:.1:ceil(max(s_max));

    f_x = (1/beta).*exp(-((x-mu)/beta + exp(-(x-mu)/beta)));

    clear title xlabel ylabel

    subplot(2, 1, 1);
    hist(s_max);
    title(sprintf('Empirical density: %d trials', n_trials))
    subplot(2, 1, 2);
    plot(x, f_x, 'r')
    title('Theoretical pdf')
end

