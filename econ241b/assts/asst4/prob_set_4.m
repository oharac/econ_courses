%% Import data from text file.
clear all

filename = '~/github/econ_courses/econ241b/assts/asst4/prob_set4.csv';

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
%% Effort vs wages and rel wages, type 1 worker
% set up X2 to be a constant plus own wage regressor plus relative wage
wage.rel_w1 = wage.w1 - wage.w2;
wage.rel_w1_low = wage.rel_w1 .* (wage.rel_w1 < 0);

%% manual regression with period fixed effects

% Dummy variable expansion for period variable, then cut one column to
% avoid singular matrix at the end
d_period = dummyvar(wage.period);
d_period(:, 1) = [];

% Set up X matrix including constant, regressors, and fixed effects matrix
X6a = [wage.w11 wage.w12 wage.w13 wage.rel_w1_low d_period const];
y  = wage.e1;

disp('Matrix calculated coefficients for table 3, column 6a')
b6a = (X6a' * X6a)^-1 * (X6a' * y);
disp(b6a(2:5)') %%% these are the coefficients on wage 1, 2, 3, and difference
% 0.4990    1.2778    1.5445   -0.0243

disp('Regress() calculated coefficients for table 3, column 6a')
[B6a, BINT, R, RINT, STATS] = regress(y, X6a);
disp(B6a(2:5)') %%% regression coefficients in table 6a
% 0.4990    1.2778    1.5445   -0.0243
disp('Regress() calculated R^2, F, p val, error var')
disp(STATS) %%% R-square statistic, the F statistic and p value for the full 
      %%% model, and an estimate of the error variance
%  0.2949    6.6031    0.0000    0.5810

%% Try Wald test to check whether coefficients are equal
% H_0: B1 - B2 = 0, B1 - B3 = 0

R = [ones(2, 1) -eye(2) zeros(2, 31)];
r = zeros(2, 1);

e_i = y - X6a * B6a;

ssr = sum(e_i.^2);
dof = length(y) - length(B6a);
s2 = ssr / dof;

cov_mat = (X6a' * X6a)^(-1) * s2;

[n, k] = size(X6a);

% [h, pValue, stat, cValue] = waldtest(r,R,cov_mat) % throws an error
wald_6a = (R*B6a - r)'*(R * cov_mat * R')^-1 * (R*B6a - r) / 2

p_val = 1 - fcdf(wald_6a, 2, n - k)
%% try with new function
[wald, p] = calc_wald(X6a, cov_mat, B6a, e_i, 2)

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
b7a = (X7a' * X7a)^-1 * (X7a' * y);
disp(b7a(2:5)') %%% these are the coefficients on wage 1, 2, 3, and difference
% 0.4990    1.2778    1.5445   -0.0243

disp('Regress() calculated coefficients for table 3, column 7a')
[B7a, BINT, R, RINT, STATS] = regress(y, X7a);
disp(B7a(2:5)') %%% regression coefficients in table 6
%    0.4200    1.1188    1.3080    0.0150
disp('Regress() calculated R^2, F, p val, error var')
disp(STATS) %%% R-square statistic, the F statistic and p value for the full 
      %%% model, and an estimate of the error variance
%    0.6039   10.8984    0.0000    0.3498


%% Try Wald test to check whether coefficients are equal
% H_0: B1 - B2 = 0, B1 - B3 = 0

R = [ones(2, 1) -eye(2) zeros(2, 66)];
r = zeros(2, 1);

e_i = y - X7a * B7a;

ssr = sum(e_i.^2);
dof = length(y) - length(B7a);
s2 = ssr / dof;

cov_mat = (X7a' * X7a)^(-1) * s2;

[n, k] = size(X7a);

% [h, pValue, stat, cValue] = waldtest(r,R,cov_mat) % throws an error
wald_7a = (R*B7a - r)'*(R * cov_mat * R')^-1 * (R*B7a - r) / 2

p_val = 1-fcdf(wald_7a, 2, n - k)



%% TYPE 2 WORKER
%% Effort vs wages and rel wages, type 1 worker
% set up X2 to be a constant plus own wage regressor plus relative wage
wage.rel_w2 = wage.w2 - wage.w1;
wage.rel_w2_low = wage.rel_w2 .* (wage.rel_w2 < 0);

%% manual regression

% Set up X matrix including constant, regressors, and fixed effects matrix
X6b = [wage.w21 wage.w22 wage.w23 wage.w24 wage.rel_w2_low d_period const];
y  = wage.e2;

disp('Matrix calculated coefficients for table 3, column 6b')
b6b = (X6b' * X6b)^-1 * (X6b' * y);
disp(b6b(2:6)') %%% these are the coefficients on wage 1, 2, 3, and difference
%  0.3467    1.0450    1.7184    1.4877    0.0562

disp('Regress() calculated coefficients for table 3, column 6b')
[B6b, BINT, R, RINT, STATS] = regress(y, X6b);
disp(B6b(2:6)') %%% regression coefficients in table 6
%  0.3467    1.0450    1.7184    1.4877    0.0562
disp('Regress() calculated R^2, F, p val, error var')
disp(STATS) %%% R-square statistic, the F statistic and p value for the full 
      %%% model, and an estimate of the error variance
%  0.3178    7.1245    0.0000    0.8583


%% Try Wald test to check whether coefficients are equal
% H_0: B1 - B2 = 0, B1 - B3 = 0, B1 - B4 = 0

R = [ones(3, 1) -eye(3) zeros(3, 31)];
r = zeros(3, 1);

e_i = y - X6b * B6b;

ssr = sum(e_i.^2);
dof = length(y) - length(B6b);
s2 = ssr / dof;

cov_mat = (X6b' * X6b)^(-1) * s2;

[n, k] = size(X6b);

% [h, pValue, stat, cValue] = waldtest(r,R,cov_mat) % throws an error
wald_6b = (R * B6b - r)'*(R * cov_mat * R')^-1 * (R*B6b - r) / 3

p_val = 1-fcdf(wald_6b, 3, n - k)




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
b7b = (X7b' * X7b)^-1 * (X7b' * y);
disp(b7b(2:6)') %%% these are the coefficients on wage 1, 2, 3, and difference
%    0.2594    0.9421    1.5005    1.5753    0.0096

disp('Regress() calculated coefficients for table 3, column 7b')
[B7b, BINT, R, RINT, STATS] = regress(y, X7b);
disp(B7b(2:6)') %%% regression coefficients in table 6
%    0.2594    0.9421    1.5005    1.5753    0.0096
disp('Regress() calculated R^2, F, p val, error var')
disp(STATS) %%% R-square statistic, the F statistic and p value for the full 
      %%% model, and an estimate of the error variance
%    0.6537   13.2698    0.0000    0.4671

%% Try Wald test to check whether coefficients are equal
% H_0: B1 - B2 = 0, B1 - B3 = 0, B1 - B4 = 0

R = [ones(3, 1) -eye(3) zeros(3, 66)];
r = zeros(3, 1);

e_i = y - X7b * B7b;

ssr = sum(e_i.^2);
dof = length(y) - length(B7b);
s2 = ssr / dof;

cov_mat = (X7b' * X7b)^(-1) * s2;

[n, k] = size(X7b);

% [h, pValue, stat, cValue] = waldtest(r,R,cov_mat) % throws an error
wald_7b = (R * B7b - r)'*(R * cov_mat * R')^-1 * (R*B7b - r) / 3

p_val = 1-fcdf(wald_7b, 3, n - k)


