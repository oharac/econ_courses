%%% Initialize workspace and load data

clear all;

load('cpsMarch2016Income.mat')

%% Combine data into matrices; censor zeros and then create a log version
inc_raw = [wsal_val, fe];

inc_cens = inc_raw(inc_raw(:, 1) > 0, :);

inc_ln = inc_cens;
inc_ln(:, 1) = log(inc_ln(:, 1));

%% Part a:
%  find MLE of mu and sigma^2 for men and women separately; then jointly;
%  then do the same for variance.  Here I run these on the non-logged data
%  and tell Matlab it's a lognormal distribution.  I get the same answers
%  if I run mle on the logged data (mle assumes normal dist).

mle_m = mle(inc_cens(inc_cens(:, 2) == 0, 1), 'distribution', 'lognormal');
mle_w = mle(inc_cens(inc_cens(:, 2) == 1, 1), 'distribution', 'lognormal');
mle_joint = mle(inc_cens(:, 1),               'distribution', 'lognormal');

x = mle(inc_ln(:, 1), 'distribution', 'normal'); % same as inc_mle_m

% m: 10.5043, 1.1195
% w: 10.0918, 1.1568
% j: 10.3041, 1.1563

%%
var_w = (exp(mle_w(2)^2) - 1) * exp(2 * mle_w(1) + mle_w(2)^2);
var_m = (exp(mle_m(2)^2) - 1) * exp(2 * mle_m(1) + mle_m(2)^2);
var_j = (exp(mle_joint(2)^2) - 1) * exp(2 * mle_joint(1) + mle_joint(2)^2);

% w: 6.2488e9
% m: 1.1655e10
% j: 4.3415e9

%% Part b: 

% The first term clips each variable to just men or just women; the second
% calculates the log of pdf of the observation
logL_m = (1 - inc_cens(:, 2)) .* log(lognpdf(inc_cens(:, 1), mle_m(1), mle_m(2)));
logL_w = (inc_cens(:, 2))     .* log(lognpdf(inc_cens(:, 1), mle_w(1), mle_w(2)));

% Why is this the sum of the two?
u_log = sum(logL_m + logL_w)

r_log = sum(log(lognpdf(inc_cens(:, 1), mle_joint(1), mle_joint(2))))

LR = -2 * (r_log - u_log)


%% Part c: 
