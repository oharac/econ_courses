%%%%%%%%%%%%%%%%%
% Author: Jaime Ramirez-Cuellar
% Date: February 2, 2018
% Purpose: 
%%%%%%%%%%%%%%%%%

% Specify DGP
rng(100)
T = 200;
u = randn(T,1); x = randn(T,1); e = randn(T,1);
x1 = 0.5*x;
x2 = e+x;
X = [x1 x2];
beta = [2 3]';
y = [x1 x2]*beta+u; 

% Estimate beta
b = (X'*X)\(X'*y)
b = X\y

% Estimate beta1
u1 = (x1-x2*(x2\x1)) ;
b1_a = u1\y 

% Another possibility
y1 =  (y-x2*(x2\y));
b1_b = u1\y1