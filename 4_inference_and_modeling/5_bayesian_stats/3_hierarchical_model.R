
# First level of variability: Each player is given a natural ability to hit at birth
  # p
# Given info: Expected value = 0.270, SE = 0.027

# Second level of variability: Prob of getting a hit due to luck

# CLT tells us that observed avg = Y, EV = p, and SE = sqrt(p*(1-p)/N)
# N is number of hit attempts

# '~' represents the distribution of something

# p ~ N(mu, tau) describes randomness in picking a player
# N in this case means the distribution is "Normal" w/ EV = mu, SE = tau

# Y | p ~ N(p, sigma)
# The distribution of an observed average of 'Y' GIVEN player has talent 'p'
# is "Normal" w/ observedValue = p, SE = sigma

# mu = 0.270
# tau = 0.027
# sigma^2 = p*(1-p)/N

# This is known as the hierarchical model b/c
  # First lv = player-player variability
  # Second lv = variability due to luck when batting

# First level formally known as PRIOR DISTRIBUTION
# Second level formally known as SAMPLING DISTRIBUTION



# Model for player Jose: p = unknown (we are trying to estimate it), se = 0.111
# p ~ N(0.275, 0.027)
# Y | p ~ N(p, 0.111)
# Y = 0.450

# Given info allows us to compute POSTERIOR DISTRIBUTION which summarizes our prediction of p.
# POSTERIOR PROBABILITY DISTRIBUTION is the prob dist of 'p' conditioned that we have
# observed data 'Y'

# Formula:
# E(p | y) = B*mu + (1 - B)Y
  # E(p | y) is expected value of p given we have observed y
  # mu = avg of all players
  # Y = observed avg of Jose
  # If B = 1 we are saying Jose is an average player, so we predict 'mu'
  # If B is 0 we are saying Jose is as he is as he has been observed, 'Y'

  # B = sigma^2/(sigma^2 + tau^2)
  # B is closer to 1 when sigma is large
  # sigma is large when variance and standard error of observed data are large

# The calculated weighted avg E(p | Y) is referred to as "shrinking"

# Jose's expected value for the posterior distribution is:
Y = 0.450 # Observed avg
mu = 0.275 # Historical avg of all players
sigma = 0.111 # Observed SE
tau = 0.027 # Historical SE of all players

B = sigma^2/(sigma^2 + tau^2)

expectedValuepGivenY = B * mu + (1 - B) * Y

expectedValuepGivenY # We expect Jose to bat 0.285 on avg

# In real life, Jose Inglesias ended up batting 0.29 that season

# For 95% CREDIBLE INTERVAL: E(p | Y) +- 1.96 * SE(p | y)

# SE(p | y)^2 = 1/((1/sigma^2 + 1/tau^2))







