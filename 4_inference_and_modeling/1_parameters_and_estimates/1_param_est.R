library(tidyverse)
library(dslabs)
ds_theme_set()
take_poll(25)

# p = proportion of blue beads AKA a parameter
p
# spread = p - (1-p) --> 2p - 1

# An 'estimate' is a summary of the observed data that we believe,
# to be representative of the parameter of instance

X = c(1, 0) # Random var X is 1 if blue, 0 if red
