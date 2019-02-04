
m = 100; n = 1000;

pvals = [.025, .975];

test_stat = get_test_stat(m, n, pvals);

[x, pdf] = get_bino_pdf(test_stat, m, pvals);

%% Plot histogram and pdf

figure
hold on
    histogram(test_stat, 'BinWidth', 1/m);
    plot(x/m, pdf*n, 'linewidth', 2);
    xlabel('Observed frequency');
    ylabel('Number of runs');
hold off

