function [V_b] = calc_clust_V (X, B, e_i, clust_vec) 
%% Takes arguments of X, Beta, residual vector e_i, and a clustering 
%  vector, returns the covariance matrix V_hat_beta.

% X = X6a; B = b6a; clust_vec = wage.wrk1id;

    clust_index = unique(clust_vec);

    n_obs = length(clust_vec);
    k_regr = length(B);
    G_gps = length(clust_index);

    omega_sum = zeros(k_regr, k_regr);
%%
    for i = 1:length(clust_index)
        clust_id = clust_index(i);
        
        X_gp = X(clust_vec == clust_id, :);
        e_gp = e_i(clust_vec == clust_id);
        omega_gp = X_gp' * e_gp * e_gp' * X_gp;

        omega_sum = omega_sum + omega_gp;
    end
%%
    % calc the adjustment factor
    a_n = (n_obs - 1)/(n_obs - k_regr) * G_gps / (G_gps - 1);

    V_b = a_n * inv(X' * X) * omega_sum * (X' * X)^(-1);

end