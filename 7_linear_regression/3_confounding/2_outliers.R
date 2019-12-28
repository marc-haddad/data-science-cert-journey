library(tidyverse)
library(broom)
set.seed(1, sample.kind = "Rounding")
# Outliers are another way we observe high correl. w/ no causation

# Take 2 measurements from 2 independent outcomes, x & y, and standardize the measurements
# HOWEVER, we made a fatal flaw and forgot to standardize entry 23
x = rnorm(100, 100, 1)
y = rnorm(100, 84, 1)
x[-23] = scale(x[-23])
y[-23] = scale(y[-23])

tibble(x, y) %>% ggplot(aes(x, y)) +
  geom_point(alpha = 0.5)
# The above plot has most points grouped in the bottom left of the plot,
# and one point waaaay up to the far top-right corner

cor(x, y) # 0.988

# If we remove the outlier the correl. is reduced to almost 0
cor(x[-23], y[-23]) # -0.00107


# The Spearman correlation is robust against outliers
# It involves the computation of correl on the RANKS of vals
cor(rank(x), rank(y)) # 0.0658, much closer to 0 even w/ the outlier

# Spearman correl. can also be called by using the method arg w/in cor
cor(x, y, method = "spearman") # 0.0658

# Learn more about robust methods in this book:
# Robust Statistics: Edition 2;
# Peter J. Huber, Elvezio M. Ronchetti