function [] = lotsa_plots(n, m)
%%%%%%%%%%%%%%%%%%%%%
%%% calculations! %%%
%%%%%%%%%%%%%%%%%%%%%

    tic;

    % n = 4; m = 1000;

    % generate matrix of values - lots of columns, n = 4 rows
    x_m_by_n = normrnd(0,1,n,m); % n rows x m columns

    % generate mean, variance, and t stat for each column
    x_bar = mean(x_m_by_n);
    var_x = var(x_m_by_n);
    t_stat_x = x_bar ./ sqrt(var_x / n);

    toc % print time to calculate

%%%%%%%%%%%%%%
%%% plots! %%%
%%%%%%%%%%%%%%

    % set up plot of sample means
    x_vals_norm = -3:0.1:3;

    x_bar_pdf = normpdf(x_vals_norm,0,1/sqrt(n)); %theoretical pdf

    figure
        histogram(x_bar, 'Normalization', 'pdf')
        hold on; 
        plot(x_vals_norm, x_bar_pdf, 'r', 'lineWidth', 2)
    title('Distribution of sample means')

    % set up plot of sample variances (chi-squared!)
    x_vals_chi2 = 0:0.01:14;

    var_x_pdf = chi2pdf(x_vals_chi2, n - 1); % 4 samples = 3 degrees of freedom

    figure
        histogram((n - 1) .* var_x, 'Normalization', 'pdf')
        hold on; 
        plot(x_vals_chi2, var_x_pdf, 'r', 'lineWidth', 2)
        title('Distribution of sample variances')

    t_stat_pdf = tpdf(x_vals_norm, (n - 1));

    figure
        histogram(t_stat_x, 'Normalization', 'pdf')
        hold on;
        plot(x_vals_norm, t_stat_pdf, 'r', 'lineWidth', 2)
        title('Distribution of t-statistics')
        xlim([-5 5])

    toc % time to calculate AND plot
end