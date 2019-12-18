# X_hat is results from sample, i.e proportion
X_hat = 0.48
se = sqrt(X_hat * (1-X_hat)/25)
se
# Probability our estimate will be within 1% error:
pnorm(0.01/se) - pnorm(-0.01/se)

# The above indicates that we can only be 8% certain
# that our estimate is within 1% error, due to our current
# sample size

# Margin of error is calculated as:
me = se * 2
# The number 2 above was derived from:
# Pr(Z <= 2) - Pr(Z <= -2) ≈ 95%

# Theoretical model with a sample size of 1000
N = 1000
X_hat = 0.48
se = sqrt(X_hat * (1-X_hat) / N)
se # ≈ 0.0158