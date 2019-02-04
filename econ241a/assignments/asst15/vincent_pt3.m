%% ECON241A - Assignment 15
% Question #3
% Vincent Thivierge
% Created: November 19th, 2017
% Updated: November 21th, 2017

%% Initialization
clear ; close all; clc

%% Load Data

data = load('cpsMarch2016Income.mat');

income = horzcat(data.fe, data.wsal_val);

%% Subset to censored

censored = income(find(income(:,2)>0),:);

%% MLE 

%Restricted
[rest]=mle(censored(:,2),'distribution','lognormal')
var_rest = (exp((rest(2)^2))-1)*exp(rest(1)*2 + (rest(2)^2)) 

%Men
[men]=mle(censored(find(censored(:,1)==0),2),'distribution','lognormal')
var_men = (exp((men(2)^2))-1)*exp(men(1)*2 + (men(2)^2)) 

%Women
[women]=mle(censored(find(censored(:,1)==1),2),'distribution','lognormal')
var_women = (exp((women(2)^2))-1)*exp(women(1)*2 + (women(2)^2)) 

%% Likelihood ratio test

ulog = sum((1-censored(:,1)).*log(lognpdf(censored(:,2),men(1),men(2))) + (censored(:,1)).*log(lognpdf(censored(:,2),women(1),women(2))))
rlog = sum(log(lognpdf(censored(:,2),rest(1),rest(2))))

LR = -2*(rlog - ulog)


%% Wald test

% Partial 

syms u_m v_m u_w v_w ; 
g = ((exp(v_m)-1)*exp(2*u_m + v_m)) - ((exp(v_w)-1)*exp(2*u_w + v_w)); 
J = jacobian([g], [u_m v_m u_w v_w])

J_eval = subs(J, [u_m v_m u_w v_w], [men(1) (men(2)^2) women(1) (women(2)^2)]);
partial = vpa(J_eval)

% Hessian of log pdf's

syms u_m v_m u_w v_w x_m x_w; 

log_pdf_m = log(1) - log(x_m) - log(sqrt(v_m*2*pi)) - (((log(x_m)-u_m)^2)/2*v_m)
log_pdf_w = log(1) - log(x_w) - log(sqrt(v_w*2*pi)) - (((log(x_w)-u_w)^2)/2*v_w)

log_pdf = log_pdf_m + log_pdf_w

H = hessian([log_pdf],[u_m, v_m, u_w, v_w])

% Sum elements of hessian of log pdfs 

e_11 = -(men(2)^2)*length(censored)
e_21 = sum(censored(find(censored(:,1)==0),2)-men(1))
e_22 = (1/(2*((men(2)^2)^2)))*length(censored)
e_33 = -(women(2)^2)*length(censored)
e_43 = sum(censored(find(censored(:,1)==1),2)-women(1))
e_44 = (1/(2*((women(2)^2)^2)))*length(censored)

I = [e_11 , e_21 , 0 , 0 ; e_21 , e_22 , 0 , 0 ; 0 , 0 , e_33 , e_43 ; 0 , 0 , e_43 , e_44 ]

var_cov = pinv(I.*-1)

% G-hat

g_hat = vpa(subs(g, [u_m v_m u_w v_w], [men(1) (men(2)^2) women(1) (women(2)^2)]));

% Calculate statistic

Wald = (g_hat*((partial*var_cov*partial')^-1)*g_hat)/length(censored)