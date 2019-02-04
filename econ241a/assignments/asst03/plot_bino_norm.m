function [] = plot_bino_norm(n_small, n_large)
% Write a Matlab program that plots two figures (one figure for small n 
% and one for a large n), each comparing two cdfs. For both figures, one 
% cdf is the number of heads out of n coin flips with a probability of 
% heads equals to 1/2. The other cdf is for a normal distribution with 
% mean 1/2 and standard deviation sqrt(n/4). The Matlab function binocdf
% will give you the former and normcdf will give you the latter.

% n_small = 10
% n_large = 100
    x1 = 0:n_small
    x2 = 0:n_large

    bin_sm = binocdf(x1, n_small, 0.5)
    bin_lg = binocdf(x2, n_large, 0.5)

    norm_sm = normcdf(x1, 0.5, sqrt(n_small/4))
    norm_lg = normcdf(x2, 0.5, sqrt(n_large/4))

    figure;
    subplot(2,1,1);
    plot(x1, bin_sm, '*', x1,norm_sm);
    title('small N, mean = 0.5');
    subplot(2,1,2);
    plot(x2, bin_lg, '*', x2,norm_lg);
    title('large N, mean ');
end
