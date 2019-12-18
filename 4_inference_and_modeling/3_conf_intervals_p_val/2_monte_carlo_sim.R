# Simulation showing the accuracy of confidence intervals
N = 1000
p = 0.45
B = 10000

# Calculates how often our p is within our 95% confidence intervals
inside = replicate(B, {
  X = sample(c(1, 0), N, replace = TRUE, prob = c(p, 1-p))
  X_hat = mean(X)
  SE_hat = sqrt(X_hat * (1-X_hat)/N)
  # If p between 2 standard deviations of X_hat = TRUE, else = FALSE
  between(p, X_hat - 2*SE_hat, X_hat + 2*SE_hat)
})
mean(inside)

