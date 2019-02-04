function [sd_alpha] = monte_monte(M, N, Q, M_max)
% inputs: M = predicted number of trials from 2(b)
%         N = number of samples per trial
%         Q = number of trials per m value
%         M_max > M, upper limit for number of trials
% parameterized as:
% M = 475; % the sweet spot I think
% N = 10; % defined in problem
% Q = 30; % try 30 trials at each m value
% M_max = 600

    mean_a_m = zeros(M_max, 1);
    sd_alpha   = zeros(M_max, 1);

    m_vec = 1:M_max;

    for m = m_vec
        % Initialize alpha vector for this set of trials at M:
        alpha = zeros(Q, 1);

        for j = 1:Q
            % initialize x_bar vector for this set of Q trials:
            x_bar = zeros(m, 1);

            for i = 1:m
                % generate a vector length n, with random draws from N ~ (0, 1).
                x = randn(N, 1);
                % calculate the mean of vector.
                x_bar(i) = mean(x);
                % do this m times.
            end

            % determine which trials exceeded limits
            x_exceed = abs(x_bar./sqrt(1/N)) > 1.96;
                % booleans in Matlab are 0 (FALSE) and 1 (TRUE)

            % count how many trials!
            x_count = sum(x_exceed);
                % since TRUE == 1, sum == count of TRUEs

            % count how many means exceed bounds; assign to alpha (as count/m).
            alpha(j) = x_count/m;
        end

        % For this set of Q trials at this m, calc mean and sd, assign to 
        % appropriate spot in the mean and sd vectors
        mean_a_m(m) = mean(alpha);
        sd_alpha(m)   = std(alpha);
    end
end