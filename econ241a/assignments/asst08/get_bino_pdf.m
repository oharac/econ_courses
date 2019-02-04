function [x, pdf] = get_bino_pdf(test_stat, m, pvals)
%% Generate pdf
%  Since this is a set of Bernoulli trials, we can model it with a binomial
%  distribution...
%  Inputs: 
%    pvals = p value lower and upper bounds (this is used to
%      determine the overall p for the binomial distribution)
%    m = number of trials in each sample

    p = 1 - (pvals(2) - pvals(1))

    x = 0:max(test_stat) .* m; % note this is in counts, not count/m

    pdf = binopdf(x, m, p);

end
