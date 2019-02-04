function [] = unif_mean_dist(n, m)
%%%%%%%%%%%%%%%%%%%%%
%%% calculations! %%%
%%%%%%%%%%%%%%%%%%%%%
    % n = 2; m = 1000;

    % generate matrix of values - lots of columns, n = 4 rows
    x_m_by_n = rand(n,m); % n rows by m columns

    % generate mean for each column
    x_bar = mean(x_m_by_n);
    
    % set up plot of sample means
    figure
        histogram(x_bar, 'Normalization', 'pdf')
    title('Distribution of sample means')
end
