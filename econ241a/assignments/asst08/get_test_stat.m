function [test_stat] = get_test_stat(m, n, pvals)
%% Generate frequencies
%  Inputs: m = number of trials per sample
%          n = number of samples
%          pvals = lower bound and upper bound between 0 and 1

    % Generate z values from p values
    z_bounds = icdf('Normal', pvals, 0, 1);

    % Generate m x n matrix of randoms from standard normal
    sample_m_n = randn(m, n);

    % Compare samples to z bounds; outside bounds = 1 (TRUE), 
    %   inside = 0 (FALSE)
    test_m_n = (sample_m_n < z_bounds(1) | sample_m_n > z_bounds(2) );

    test_count = sum(test_m_n)

    test_stat = test_count ./ m;

end