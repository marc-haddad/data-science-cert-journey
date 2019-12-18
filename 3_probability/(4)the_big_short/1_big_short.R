nloans = 1000
cash = 180000
loss_per_forclosure = -200000
p = 0.02
defaults = sample(c(0, 1), nloans, 
                  prob = c(1-p, p), 
                  replace = TRUE)

sum(defaults * loss_per_forclosure)

B = 10000
losses = replicate(B, {
  defaults = sample(c(0, 1), nloans, prob = c(1 - p, p), replace = TRUE)
  sum(defaults * loss_per_forclosure)
})
mean(losses)
sd(losses)

nloans = 1000
cash = 180000
loss_per_forclosure = -200000
p = 0.02

# Expected Value
ex = nloans * (p * loss_per_forclosure + (1 - p) * 0)
# Standard Deviation
sd = sqrt(nloans) * abs(loss_per_forclosure) * sqrt(p * (1 - p))
ex
sd

# We need to set an interest rate that will counter losses
# i.e. loss_per_forclosure * p + interest * (1 - p) = 0
interest = -loss_per_forclosure * p/(1-p)
# interestRate ≈ 2%
interestRate = interest/cash

# We want the probability of losing money to be 0.01
# Pr(S < 0) = 0.01 note: 'S' is the expected value of the sum of all loans
# S = (l*p + x*(1-p)) * n  note: 'l' = loss_per_foreclosure, 'n' = nloans, 'p' = probability of losing
l = loss_per_forclosure
n = nloans
p
# Standard Error: SE = abs(x - l) * sqrt(n*p * (1 - p))

# Transforming both sides of Pr(S < 0)
# by subtracting S and dividing by Standard Error, we get:
  # Pr(Z < -S / SE)
# Plugging in S and SE:
  # Pr(Z < -((l*p + x*(1-p)) * n) / 
  #                               (abs(x - l) * sqrt(n*p * (1-p)))) 
  #                                                           = qnorm(0.01)

# Remember: Pr(Z <= z) = 0.01 This means that probability of z = qnorm(0.01)
# Therefore: ((l*p + x*(1-p)) * n) / 
#                               (abs(x - l) * sqrt(n*p * (1-p)))
#                                                             = qnorm(0.01)
z = qnorm(0.01)
# Solving for x:
x = -l * (n*p-z*sqrt(n*p*(1-p)))/(n*(1-p)+z*sqrt(n*p*(1-p)))
x # = 6249.181
x/cash # Interest rate to achieve above ≈ 3%


