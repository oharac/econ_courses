%% part 2
%
% Suppose we draw n independent random variables x_i ~ N(0,1) and generate 
% the average x_bar. We know that Pr(|x_bar/sqrt(1/n)| > 1.96) = 0.05. 
% Suppose we were to generate m such samples and count up the number of 
% times that |x_bar/sqrt(1/n)| > 1.96. Call this count divided by m, alpha.
% 
% a. What is the standard deviation of alpha?

% The count for events exceeding the cutoff is a binomial 
% distribution, with p = 0.05 for success.  
%     E[X] = mp and var[X] = mp(1 - p)
% But alpha = count / m, so:
%     mean(alpha) = p and 
%     sigma = sqrt(var[x]/m^2) = sqrt(p(1-p))/sqrt(m)

    
%% b. Suppose we wanted there to be a 90 percent chance that the estimated 
% alpha is between 0.04 and 0.06. How large must m be? You may approximate 
% the distribution of alpha by the normal distribution.

% Determine sigma such that 90% of instances fall within +/-.01 of mean. Z
% = -1.645 for 5% below, +1.645 for 5% above so:
%     1.645 sigma = .01 
%     1.645 * sqrt(.05*.95)/.01 = sqrt(m) = 21.8 -> m = 475

% 
%% c. Write a simulation program that sets n = 10 and uses a variety of 
% values of m, some smaller than your value given in part (b) and some 
% larger. Then run this for a number of times saving alpha. Make a plot 
% that shows the theoretical standard
% deviation of alpha (from part (a)) as a function of m as well as the 
% empirical standard deviation of alpha from the simulations. Effectively, 
% do a Monte Carlo of doing a Monte Carlo.

% see monte_monte.m

%% plot theoretical sd for each m, and plot empirical sd for each m.
sd_empirical = monte_monte(475, 10, 30, 600);

sd_theo = sqrt(.05*(1-.05))./sqrt(m_vec);

plot(m_vec, sd_empirical, m_vec, sd_theo, 'r');

%% part 3
%
% Write a Matlab program that draws a simulated Chi^2(4) density and 
% an analytic density on the same figure. To simulate the Chi^2 generate 
% 4 standard normals (randn(4,1)), square them and add them up. Do this a 
% lot of times and then draw the histogram using the Matlab function 
% histogram. Then draw the analytic expression using the chi2pdf
% function with 4 degrees of freedom. 
 
% see sim_chi2.m

%%

n_sims = 100000
chi_vec = sim_chi2(n_sims, 4)

clear title xlabel ylabel

subplot(2, 1, 1);
hist(chi_vec);
title(sprintf('Histogram of Chi^2(4), %d iterations', n_sims))


an_expr = chi2pdf(0:.2:30, 4);
subplot(2, 1, 2);
plot(0:.2:30, an_expr);
title('Analytic expression of Chi^2(4)')


%% part 4
%
% The pdf of the extreme value distribution can be written 
% f(x) = (1/beta)exp(-((x-mu)/beta + exp(-(x-mu)/beta))), 
% where mean(x) = mu + beta*gamma, gamma ~ .5772 and median(x) = mu - log(log(2)). 
% Generate a bunch of samples of standard normals each with 120 
% observations. Find the maximum value for each sample. Find the mean 
% and median of the distribution of the maxima. Now solve for the values 
% of ? and ? implied by the mean and median. Plot the empirical
% density (use the histogram function) of the maxima along with the 
% theoretical pdf implied by the values of ? and ?.

% see extreme_val_dist.m

extreme_val_dist(3000)
