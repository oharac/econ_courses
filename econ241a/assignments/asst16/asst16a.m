%% Set up variables and params
%    set parameters: number of samples, scale factor for X, variance for
%    epsilon
n = 100;
x_scale = 10;
eps_var = .25;

%  Generate X and epsilon vectors; X ~ u(0, x_scale), eps ~ n(0, eps_var)
X = sort(rand(n, 1) * x_scale);
eps = normrnd(0, sqrt(eps_var), n, 1);

%  Set up a true beta and some random betas around it
beta = 10; %rand(1) * 10;
beta_hats = rand(50, 1) * beta * 2;

%  calculate y from given formula
y = log(beta .* X) + eps;

%% plot y ~ X

figure;
plot(X, y, 'k.');
hold on;
plot(X, log(beta .* X), 'r');
% plot(X, beta .* X, 'b');
ylim([min(y) max(y)]);
xlabel('X', 'Interpreter', 'latex'); 
ylabel('$y = \log(\beta X) + \varepsilon$', 'Interpreter', 'latex')

%% calculate and plot sum of squared residuals
%  for each combination of (X, y) and each value of beta_hats

% sq_resid = zeros(length(y), length(beta_hats));
% for i = 1:length(beta_hats)
%     sq_resid(:, i) = (y - log(X * beta_hats(i))) .^ 2;
% end

sq_resid = (y - log(X * beta_hats')) .^ 2;

sum_sq_resid = sum(sq_resid);

figure;
plot(beta_hats, sum_sq_resid, '*')
xlabel('Parameter estimates: $\hat{\beta}$', 'Interpreter', 'latex');
ylabel('Sum of squared residuals: $\sum (y - \log\hat{\beta}x)^2$', 'Interpreter', 'latex')

figure;
plot(beta_hats, sum_sq_resid, '*')
xlabel('Parameter estimates: $\hat{\beta}$', 'Interpreter', 'latex');
ylabel('Sum of squared residuals: $\sum (y - \log\hat{\beta}x)^2$', 'Interpreter', 'latex')
xlim([7 13])
ylim([0 40])

%% Part b

beta_j    = zeros(11, 1);
y_bar = mean(y);

figure
for (i = 1:5) % iterate from several starting points
    beta_j(1) = beta_hats(i); % initialize beta_j from beta_hats
    for (j = 1:10)
        delta_hat = (y_bar - log(beta_j(j)) - sum(log(X))/n) * beta_j(j)

        beta_j(j + 1) = beta_j(j) + delta_hat;
    end
    plot([1:length(beta_j)], beta_j, 'LineWidth', 2)
    hold on
end
xlabel('Iterations', 'Interpreter', 'latex')
ylabel('$\hat{\beta}$ estimates', 'Interpreter', 'latex')
legend(strcat('beta_0=', string(beta_hats(1:5))))
