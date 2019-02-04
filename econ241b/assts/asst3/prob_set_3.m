%% Import data from text file.
clear all

filename = '/Users/ohara/github/econ_courses/econ241b/assts/asst3/prob_set3.csv';

raw = readtable(filename);

%% set up data
wage_pub = raw(raw.pubwage == 1, :);

nrows = length(wage_pub.w1);
const = ones(nrows, 1);


%% TYPE 1 WORKER
%% Effort vs wages, type 1 worker
% set up X1 to be a constant plus own wage regressor
X1 = [const wage_pub.w1];
y  = wage_pub.e1;

b1 = (X1' * X1)^-1 * (X1' * y);

col_a1 = regress(y, X1);

lm1 = fitlm(wage_pub, 'e1 ~ w1')


%% Effort vs wages and rel wages, type 1 worker
% set up X2 to be a constant plus own wage regressor plus relative wage
wage_pub.rel_w1 = wage_pub.w1 - wage_pub.w2;

X2 = [const wage_pub.w1 wage_pub.rel_w1];
y  = wage_pub.e1;

b2 = (X2' * X2)^-1 * (X2' * y);

col_a2 = regress(y, X2);

lm2 = fitlm(wage_pub, 'e1 ~ w1 + rel_w1')

p2 = coefTest(lm2, [0 0 1])

%% Effort vs wages and low rel wages, type 1 worker
% set up X3 to be a constant plus own wage regressor plus 
%   (rel wage below zero)

wage_pub.rel_w1_low = wage_pub.rel_w1 .* (wage_pub.rel_w1 < 0);

X3 = [const wage_pub.w1 wage_pub.rel_w1_low];
y  = wage_pub.e1;

b3 = (X3' * X3)^-1 * (X3' * y);

col_a3 = regress(y, X3);

lm3 = fitlm(wage_pub, 'e1 ~ w1 + rel_w1_low')

p3 = coefTest(lm3, [0 0 1])


%% TYPE 2 WORKER
%% Effort vs wages, type 2 worker
% set up X1 to be a constant plus own wage regressor
X1 = [const wage_pub.w2];
y  = wage_pub.e2;

b1 = (X1' * X1)^-1 * (X1' * y);

col_a1 = regress(y, X1);

lm1 = fitlm(wage_pub, 'e2 ~ w2')


%% Effort vs wages and rel wages, type 2 worker
% set up X2 to be a constant plus own wage regressor plus relative wage
wage_pub.rel_w2 = wage_pub.w2 - wage_pub.w1;

X2 = [const wage_pub.w2 wage_pub.rel_w2];
y  = wage_pub.e2;

b2 = (X2' * X2)^-1 * (X2' * y);

col_a2 = regress(y, X2);

lm2 = fitlm(wage_pub, 'e2 ~ w2 + rel_w2')

p2 = coefTest(lm2, [0 0 1])

%% Effort vs wages and low rel wages, type 2 worker
% set up X3 to be a constant plus own wage regressor plus 
%   (rel wage below zero)

wage_pub.rel_w2_low = wage_pub.rel_w2 .* (wage_pub.rel_w2 < 0);

X3 = [const wage_pub.w2 wage_pub.rel_w2_low];
y  = wage_pub.e2;

b3 = (X3' * X3)^-1 * (X3' * y);

col_a3 = regress(y, X3);

lm3 = fitlm(wage_pub, 'e2 ~ w2 + rel_w2_low')

p3 = coefTest(lm3, [0 0 1])
