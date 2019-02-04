function [x] = sim_chi2(n, k)
%% simulates n instances of chi-squared at given k

    x = zeros(1, n);

    for i = 1:n
        chi2 = sum(randn(k, 1).^2);
        x(i) = chi2;
    end
end