function [] = plotLstar(a_vec, b_vec)
%% Econ 241A lecture 1 assignment: 
% Consider the problem of a farmer who plants seeds using labor L and
%   grows a crop of size X.  Suppose the production function is
%      X = alpha*L 
% and that the farmer's utility is
%      U(X, L) = X^beta + (L_bar - L)
%   where L_bar - L is leisure and beta < 1.  How many hours should the
%   farmer put in and how does the marginal productivity of labor affect
%   the decision?  Write a Matlab function that plots the optimal
%   labor supply against the marginal product of labor.
% ------------
% This function plots the optimal labor against a grid of alpha and beta
% values at a resolution provided by the user (default = 0.05).
% 
% The marginal product of labor is dX/dL = alpha.  Each additional unit
%   of labor increases output by alpha units.
%
% The optimal labor occurs when dU/dL = 0.  
%   U(L) = (alpha*L)^beta + (L_bar - L) = 0
%   L* = [1/(a^b * b)]^(1 / (b - 1)) = (a^b * b) ^ (1 / (1 - b))
% ------------
% Input: a_vec and b_vec are vectors of possible values for parameters
%   alpha > 0 and 0 < beta < 1.  These vectors will be used to create
%   a grid to calculate L*.
% ------------
% Output: none; simply plots the function.

%% use meshgrid to create a matrix of alpha and beta values.  Alpha = 2
% is sufficient to see the shape of the curve; beta ranges from 0 - 1 
% exclusive at user-determined resolution (e.g. reso = .05, then beta is
% [0.05, 0.05, 0.95].

    [a, b] = meshgrid(a_vec, b_vec)

%% Calculate L_star
    L_star = ((a.^b) .* b) .^ (1 ./ (1 - b))

%% Plot using surfc
    surfc(a, b, L_star)
    zlabel('L*')
    xlabel('alpha')
    ylabel('beta')

end
