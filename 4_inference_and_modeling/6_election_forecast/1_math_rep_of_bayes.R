
# Mathematical representation of Bayesian models

# Model1: X_j = d + epsilon_j
J = 6 # Number of polls taken
N = 2000 # Sample size for each poll
d = 0.021 # Expected value
p = (d + 1)/2 # Proportion according to expected value d
        # rnorm func calculates error epsilon
X = d + rnorm(J, 0, 2 * sqrt(p * (1-p)/N)) # We assume mean = 0 and SE = sqrt...
X

# The above data is for 1 pollster. for multiple pollsters we use "I" as another index

# Model2: X_i_j = d + epsilon_i_j
I = 5 # Number of pollsters
J = 6 # Number of polls taken by each pollster
N = 2000 # Sample size for each poll
d = 0.021 # Expected value
p = (d + 1)/2

X = sapply(1:I, function(i){
  d + rnorm(J, 0, 2*sqrt(p * (1-p)/N)) # This takes 6 samples of n=2000 for pollsters 1 thru I
})
X

# The above does not account for pollster to pollster variability due to house effect
# since it treats the variability as similarly random across different pollsters

# Model3: X_i_j = d + h_i + epsilon_i_j
I = 5
J = 6
N = 2000
d = 0.021
p = (d + 1)/2
h = rnorm(I, 0, 0.025) # Simulated house effect for each pollster

X = sapply(1:I, function(i){
  d + h[i] + rnorm(J, 0, 2 * sqrt(p * (1-p)/N))
})

# The above is closer to reality but is still a bit off. It does not account for general bias
# which we see from historical data.

# Model4: X_i_j = d + b + h_i + epsilon_i_j
I = 5
J = 6
N = 2000
d = 0.021
p = (d + 1)/2
h = rnorm(I, 0, 0.025)
b = 0.025 # Requires historical data on the effect of general bias







