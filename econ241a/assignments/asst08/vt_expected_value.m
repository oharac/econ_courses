%% ECON241A - Assignment 9
% Question #2 Survey
% Vincent Thivierge
% Created: October 23rd, 2017
% Updated: October 23rd, 2017

function f=expected_value(n)

f=-1*(normcdf(-1.96-(2/(sqrt(16/n)))) + (1-normcdf(1.96-(2/(sqrt(16/n)))))*50000 - 7*n)

end