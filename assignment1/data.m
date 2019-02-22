function dataset = data(N, p, tau_sq)
x1 = randn(N,1);

mean_u = 0;
std_u = sqrt(tau_sq);
u = std_u.*randn(10,1) + mean_u;
x2 = (sqrt(1-tau_sq)* x1) + u;

epsilon = randn(N,1);
y = x1-x2+epsilon;

dataset = [x1 x2 y];
end