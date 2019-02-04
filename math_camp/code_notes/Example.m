clear all;
clc;

X = [1 5 3 ; 1 1 4 ; 1 5 7 ; 1 3 10];
Y = [2; 3 ; 2 ; 1];

[b,S2] = OLS(X,Y);

[z,bint,r,rint,stats] = regress(Y,X);

plot(.5,1.5);