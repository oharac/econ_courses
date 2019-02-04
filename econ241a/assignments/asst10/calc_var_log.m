function[var_log] = calc_var_log(u, n)
% Draws n samples from uniform distribution U(0, u), applies a log
% function, and returns the variance calculated from these
% samples.

    % n = 1000;
    
    theta = rand(n, 1) * (u); % rescale random numbers from 0 to u

    logtheta = log(theta);

    mean_theta = mean(theta);
    var_theta  = var(theta);
    
    mean_log = mean(logtheta);
    var_log  = var(logtheta);
    
end