function[b,S2] = OLS(X,Y)
    [n,k] = size(X); 
    b = (X.'*X)^(-1)*(X.'*Y);
    e = Y-X*b;
    s2 = (e.'*e)/(n-k);
    S2 = diag(s2*(X.'*X)^(-1));
end