function [b_mle] = estimate_b(b, n, m)
%  This function calculates a maximum likelihood estimator based on a
%  sample of n observations from a uniform distribution from 0 to b.
%  Arguments: 
%    b: top end of random uniform distribution
%    n: number of observations in the sample
%    m: the number of iterations for this sample size
%  Return value: 
%    b_mle: vector of the max likelihood estimator for b for each sample

    % generate n rows x m columns of random uniform ~U[0, 1], multiply 
    % by b to get ~U[0, b]
    x = rand(n, m) * b;

    % from question 1, our b_mle is just the max observed value of x
    b_mle = max(x);
end

