function [p_10, p_10_th, m_mean] = ninety_pctile(p, n_vec, samples)
% This function calculates the 90th percentile (p = .10, one-tailed) for
% mean of a set of Bernoulli trials and compares to the 
% theoretical p = .10 cutoff value of z = 1.286 for a normal distribution.
% Inputs: 
%   p       = probability of success in Bernoulli trials
%   n_vec   = vector of n values in each sample
%   samples = number of samples 
% Outputs (all vectors with rows to match up with n_vec values):
%   p_10    = 90th percentile of sample means (10% above this)
%   p_10_th = theoretical one-tailed P value of .10
%   m_mean  = matrix of sample means for each n_vec value

% Initialize output vectors
    m_mean  = zeros(length(n_vec), samples);
    p_10    = zeros(length(n_vec), 1);
    p_10_th = zeros(length(n_vec), 1);

% since n differs for each set of samples, can't do 3d matrix
    for i = 1:length(n_vec)

        n = n_vec(i);
        
        % create matrix of uniform random values, n rows and many columns
        mat = rand(n, samples);
        
        % create matrix of successes from matrix of unif rand vals
        m_success = mat < p;
        
        % calculate mean of each sample, and assign to output matrix
        m_mean_tmp   = mean(m_success);
        m_mean(i, :) = m_mean_tmp;
        
        % calculate actual and theoretical 90th percentile values
        p_10(i)      = quantile(m_mean_tmp, .90);
        p_10_th(i)   = p + 1.2816 * sqrt(p * (1 - p) / n);

    end
    
end