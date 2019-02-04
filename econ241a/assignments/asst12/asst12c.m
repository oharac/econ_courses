b = 1;

b_mle10   = estimate_b(1,   10, 100000);
b_mle100  = estimate_b(1,  100, 100000);
b_mle1000 = estimate_b(1, 1000, 100000);

subplot(3, 1, 1)
histogram(b_mle10, 50)
title('b_{mle} for b = 1, n = 10; 100,000 iterations')

subplot(3, 1, 2)
histogram(b_mle100, 50)
title('b_{mle} for b = 1, n = 100; 100,000 iterations')

subplot(3, 1, 3)
histogram(b_mle1000, 50)
title('b_{mle} for b = 1, n = 1,000; 100,000 iterations')
