p = .5;

n_vec = [2, 5, 10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000];

samples = 1000;

[p_10, p_10_th, m_mean] = ninety_pctile(p, n_vec, samples);

figure
hold on;
refline(1, 0);
cmap = jet(length(n_vec)); % color map for n values
scatter(p_10_th, p_10, 50, cmap, 'filled')

xlabel('Theoretical value')
ylabel('Actual value from samples')
title('Theoretical vs actual p = .10 values, for different n')

csvwrite('p_vals.csv', cat(2, n_vec', p_10_th, p_10))
csvwrite('m_means.csv', cat(2, n_vec', m_mean))