options(digits = 3)
library(tidyverse)
library(dslabs)

data(death_prob)
head(death_prob)

p = 0.003193
loss_per_death = -150000
premium = 1150
n = 1000
expected_value_single = p*loss_per_death + premium*(1-p)
se = abs(loss_per_death - premium) * sqrt(p * (1-p))
se

EV = n * expected_value_single
EV

SE = sqrt(n) * se
SE

# Pr(EV < 0)
pnorm(0, EV, SE)

p = 0.005013
S = 700000

b = (700000/n - loss_per_death*p)/(1-p)
new_premium = b
se_new = (abs(loss_per_death - new_premium) * sqrt(p * (1-p)))* sqrt(n)
se_new 
pnorm(0, S, se_new)



p = 0.015









