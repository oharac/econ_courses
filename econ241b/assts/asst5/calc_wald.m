function [wald, p_val] = calc_wald(X, V, B, e_i, q)
% given regressor matrix X, covariance matrix V, coefficient vector B,
% error terms vector e_i, and number of coefficients to test q (assumes
% testing B(1:q) against one another to see if they are identical), returns 
% Wald test value and p-value.

    R = [ones(q, 1) -eye(q) zeros(q, length(B) - q - 1)];
    r = zeros(q, 1);

    [n, k] = size(X);

    ssr = sum(e_i.^2);
    dof = n - k;
    s2 = ssr / dof;

    % [h, pValue, stat, cValue] = waldtest(r,R,cov_mat) % throws an error
    wald = (R * B - r)' * (R * V * R')^-1 * (R * B - r) / q;

    p_val = 1 - fcdf(wald, q, n - k);
    
end