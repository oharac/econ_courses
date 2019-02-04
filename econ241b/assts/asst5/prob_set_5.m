%% Import data from text file.
clear all

filename = '~/github/econ_courses/econ241b/assts/asst5/prob_set5.csv';

raw = readtable(filename);
% NOTE: this is the same data as for asst 3; I did not save the Stata 
% edits made for assignment 4.

%% set up data
% keep just public wages and drop the pubwage column
wage = raw(raw.pubwage == 1, :);
wage.pubwage = [];

% add in w11-w14, w21-w24 columns
wage.w11 = wage.w1 == 1;
wage.w12 = wage.w1 == 2;
wage.w13 = wage.w1 == 3;
wage.w14 = wage.w1 == 4;
wage.w21 = wage.w2 == 1;
wage.w22 = wage.w2 == 2;
wage.w23 = wage.w2 == 3;
wage.w24 = wage.w2 == 4;

nrows = length(wage.w1);
const = ones(nrows, 1);


%% TYPE 1 WORKER
% Effort vs wages and rel wages, type 1 worker
% set up X2 to be a constant plus own wage regressor plus relative wage
wage.rel_w1 = wage.w1 - wage.w2;
wage.rel_w1_low = wage.rel_w1 .* (wage.rel_w1 < 0);

%% manual regression with period fixed effects and clustering

% Dummy variable expansion for period variable, then cut one column to
% avoid singular matrix at the end
d_period = dummyvar(wage.period);
d_period(:, 1) = [];

% Set up X matrix including constant, regressors, and fixed effects matrix
X6a = [wage.w11 wage.w12 wage.w13 wage.rel_w1_low d_period const];
y  = wage.e1;

disp('Matrix calculated coefficients for table 3, column 6a')
B6a = (X6a' * X6a)^-1 * (X6a' * y);
disp(B6a(1:4)') %%% these are the coefficients on wage 1, 2, 3, and difference
% 0.4990    1.2778    1.5445   -0.0243

% Calc residuals
e_i6a = y - X6a * B6a;

%% Calc covariance matrix with clustering

V_b6a = calc_clust_V (X6a, B6a, e_i6a, wage.wrk1id);

se_b6a = sqrt(diag(V_b6a));
disp('Cluster robust standard errors for table 3, column 6a')
disp(se_b6a(1:4)')
    
%% Use Wald test to check whether coefficients are equal

[wald_6a, p_6a] = calc_wald(X6a, V_b6a, B6a, e_i6a, 2);
disp('Wald test and p-value, col 6a:')
disp(wald_6a); disp(p_6a)


%% Manual regression: fixed effects on period and worker ID

% Dummy variable expansion for worker 1 variable, then cut two columns to
% avoid singular matrix at the end.
d_wrk1id = dummyvar(wage.wrk1id);
sum_test = sum(d_wrk1id) ~= 0;
d_wrk1id = d_wrk1id(:, sum_test);
d_wrk1id(:, 37) = [];
d_wrk1id(:, 1) = [];
%%
% Set up X matrix including constant, regressors, and fixed effects matrix
X7a = [wage.w11 wage.w12 wage.w13 wage.rel_w1_low d_period d_wrk1id const];
y  = wage.e1;

disp('Matrix calculated coefficients for table 3, column 7a')
B7a = (X7a' * X7a)^-1 * (X7a' * y);
disp(B7a(1:4)') %%% these are the coefficients on wage 1, 2, 3, and difference
% 0.4990    1.2778    1.5445   -0.0243

% Calc residuals
e_i7a = y - X7a * B7a;

%% Calc covariance matrix with clustering

V_b7a = calc_clust_V (X7a, B7a, e_i7a, wage.wrk1id);

se_b7a = sqrt(diag(V_b7a));
disp('Cluster robust standard errors for table 3, column 7a')
disp(se_b7a(1:4)')


%% Use Wald test to check whether coefficients are equal

[wald_7a, p_7a] = calc_wald(X7a, V_b7a, B7a, e_i7a, 2);
disp('Wald test and p-value, col 7a:')
disp(wald_7a); disp(p_7a)



%% TYPE 2 WORKER
% Effort vs wages and rel wages, type 1 worker
% set up X2 to be a constant plus own wage regressor plus relative wage
wage.rel_w2 = wage.w2 - wage.w1;
wage.rel_w2_low = wage.rel_w2 .* (wage.rel_w2 < 0);

%% manual regression

% Set up X matrix including constant, regressors, and fixed effects matrix
X6b = [wage.w21 wage.w22 wage.w23 wage.w24 wage.rel_w2_low d_period const];
y  = wage.e2;

disp('Matrix calculated coefficients for table 3, column 6b')
B6b = (X6b' * X6b)^-1 * (X6b' * y);
disp(B6b(1:5)') %%% these are the coefficients on wage 1, 2, 3, and difference
%  0.3467    1.0450    1.7184    1.4877    0.0562

% Calc residuals
e_i6b = y - X6b * B6b;

%% Calc covariance matrix with clustering

V_b6b = calc_clust_V (X6b, B6b, e_i6b, wage.wrk2id);

se_b6b = sqrt(diag(V_b6b));
disp('Cluster robust standard errors for table 3, column 6b')
disp(se_b6b(1:5)')

%% Use Wald test to check whether coefficients are equal

[wald_6b, p_6b] = calc_wald(X6b, V_b6b, B6b, e_i6b, 3);
disp('Wald test and p-value, col 6b:')
disp(wald_6b); disp(p_6b)


%% Manual regression: fixed effects on period and worker ID

% Dummy variable expansion for worker 2 variable, then cut two columns to
% avoid singular matrix at the end.
d_wrk2id = dummyvar(wage.wrk2id);
sum_test = sum(d_wrk2id) ~= 0;
d_wrk2id = d_wrk2id(:, sum_test);
d_wrk2id(:, 37) = [];
d_wrk2id(:, 1) = [];
%
% Set up X matrix including constant, regressors, and fixed effects matrix
X7b = [wage.w21 wage.w22 wage.w23 wage.w24 wage.rel_w2_low d_period d_wrk2id const];
y  = wage.e2;

disp('Matrix calculated coefficients for table 3, column 7b')
B7b = (X7b' * X7b)^-1 * (X7b' * y);
disp(B7b(1:5)') %%% these are the coefficients on wage 1, 2, 3, and difference
%    0.2594    0.9421    1.5005    1.5753    0.0096

% Calc residuals
e_i7b = y - X7b * B7b;

%% Calc covariance matrix with clustering

V_b7b = calc_clust_V (X7b, B7b, e_i7b, wage.wrk2id);

se_b7b = sqrt(diag(V_b7b));
disp('Cluster robust standard errors for table 3, column 7b')
disp(se_b7b(1:5)')

%% Use Wald test to check whether coefficients are equal

[wald_7b, p_7b] = calc_wald(X7b, V_b7b, B7b, e_i7b, 3);
disp('Wald test and p-value, col 7b:')
disp(wald_7b); disp(p_7b)

