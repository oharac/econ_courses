function [beta] = beta_n(n, mu)
% Calculates beta (power of test) comparing the expected mu, from a sample
% of size n, to a standard normal with mu_0 = 0 and variance sigma^2 = 1.
% Inputs: 
%   n    = vector of sample sizes
%   mu   = estimated population mean
% Outputs: 
%   beta = power of test, as probability of incurring a type II error; this
%          will be a vector of same length as n

    % set up parameters
    mu_0 = 0; sig2 = 1; z_target = 1.96;
    
    % Calculate standardized z score for each value of n
    x_bar = mu_0 + z_target .* sqrt(sig2 ./ n);
    
    z_b_pos = ( x_bar - mu) ./ sqrt(sig2 ./ n);
    z_b_neg = (-x_bar - mu) ./ sqrt(sig2 ./ n);
    % Calculate beta for each z score (each tail)
    beta = 1 - (normcdf(z_b_pos, 0, sig2) - normcdf(z_b_neg, 0, sig2));

end
