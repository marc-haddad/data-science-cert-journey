library(Lahman)
library(tidyverse)
library(broom)
library(ggrepel)
library(reshape2)
library(lpSolve)
library(dslabs)
options(digits = 3)

# In measurement error models it is common to have nonrandom covariates (like time),
# and randomness is introduced through measurement error rather than sampling or natural variability.

# Plotting trajectory of falling obj.
falling_object = rfalling_object()

falling_object %>% 
  ggplot(aes(time, observed_distance)) +
  geom_point() +
  ylab("Distance in meters") +
  xlab("Time in seconds")
# Looking at the above plot, we deduce that the shape is a parabola
# Parabola func:
  # f(x) = Beta_0 + Beta_1 * x + Beta_2 * x^2

# The data doesn't fall exactly on the parabola b/c of measurement error

# To account for errors we write this model:
  # Y_i = Beta_0 + Beta_1 * x_i + Beta_2 * x_i^2 + epsilon_i, i = 1,..., n
  # Y is distance in meters, x_i is time in seconds, epsilon_i is measurement error

# Measurement error is assumed to be random, independent from each other, and having the same distrib. for each i.
# Also assume no bias
# This means Expected val of epsilon = 0 (E[epsilon] = 0)

# Despite being parabolic, the above is a linear model
# b/c it is a linear combination of: 
    # known quantities: x & x^2
    # and unknown params: Betas

# Unlike prev examples, the x's are fixed quantities, no conditioning occurs


# We can create the model w/ LSE
# We use LSE b/c it does not require the errors to be approx. normal.
# lm() will find Betas that minimize the residual sum of sqs
fit = falling_object %>% 
  mutate(time_sq = time^2) %>% 
  lm(observed_distance ~ time + time_sq, data = .) # Reminder: we use "+" here to let lm() know we want to create multi reg
tidy(fit)
# A tibble: 3 x 5
# term        estimate  std.error statistic  p.value
# <chr>          <dbl>     <dbl>     <dbl>    <dbl>
# (Intercept)   55.9       0.616    90.8   3.61e-17
# time          -0.682     0.880    -0.775 4.54e- 1
# time_sq       -4.64      0.261   -17.8   1.89e- 9

# To check if our above estimated params fit the data,
# we use augment()
augment(fit) %>% 
  ggplot() +
  geom_point(aes(time, observed_distance)) +
  geom_line(aes(time, .fitted))
# The above plot shows that our predicted vals go right through all the points

