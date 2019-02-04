function [] = chebychev_plot( d )
% Plots Chebychev bound and actual probability for "interesting values of
% d" (input) for a standard normal distribution function.
% Input d can be vector of values of d to be calculated/plotted.

mu = 0; sig2 = 1;

P_upperbound = sig2 ./ d.^2;

P_actual = normpdf(d, mu, sqrt(sig2));

subplot(2, 1, 1)
    plot(d, P_upperbound, 'b--', d, P_actual, 'g')
    ylim([0 max(P_actual + .1)])
    ylabel('probability'); xlabel('d')
    legend('P upperbound', 'P actual')
subplot(2, 1, 2)
    plot(d, P_upperbound./P_actual, d, d, 'r--')
    ylim([0 10])
    legend('Bound / actual', '1:1 line')
    ylabel('ratio P_{bound}/P_{actual}'); xlabel('d')

end

