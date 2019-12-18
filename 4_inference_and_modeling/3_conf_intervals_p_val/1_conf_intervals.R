p = 0.45
N = 1000

# Results
X = sample(c(1,0), N, replace = TRUE, prob = c(p, 1-p))
# Expected Value
X_hat = mean(X)
# Standard Error
SE_hat = sqrt(X_hat * (1-X_hat)/N)
# 95% confidence interval (i.e approx. 2 sds from the mean on both sides)
c(X_hat - 2 * SE_hat, X_hat + 2 * SE_hat)