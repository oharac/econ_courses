function [] = plot_bino_norm2(n_small, n_large)
%% is mean supposed to be n/2 instead of 1/2?
    x1 = 0:n_small
    x2 = 0:n_large

    bin_sm = binocdf(x1, n_small, .5)
    bin_lg = binocdf(x2, n_large, .5)

    norm_sm = normcdf(x1, n_small/2, sqrt(n_small/4))
    norm_lg = normcdf(x2, n_large/2, sqrt(n_large/4))

    figure;
    subplot(2,1,1);
    plot(x1, bin_sm, '*', x1, norm_sm, 'r');
    title('small N, mean = N/2');
    subplot(2,1,2);
    plot(x2, bin_lg, '*', x2, norm_lg, 'r');
    title('large N, mean = N/2');
end
