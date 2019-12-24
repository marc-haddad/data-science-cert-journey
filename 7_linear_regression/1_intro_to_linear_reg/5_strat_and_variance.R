library(HistData)
library(tidyverse)

data("GaltonFamilies")
set.seed(0)

galton_heights = GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

# Correlation is not always the best way to measure relationships
# Famous example: Anscombe's quartet, 4 wildly diff plots, all cor coef = 0.82



# Stratifying data
# Conditional Avg: find the avg of one var given the condition of another
# Ex: Predicting son's height when given father height of 72 in.
#     Conditional avg is the avg son height for every father that is 72 in.
# Common prob. w/ conditional avg: we tend to not have enough data for narrow conditions,
#                                  e.g num of fathers w/ height of exactly 72 in.
# Solution: widen condition to include similar data

# Conditional average height of sons, conditioned on the father height being near 72 in.
conditional_avg = galton_heights %>% filter(round(father) == 72) %>%
  summarize(avg = mean(son)) %>% .$avg
conditional_avg # 71.84 in.

# Stratification followed by box-plots lets us see the dist. of each group.
galton_heights %>% mutate(father_strata = factor(round(father))) %>%
  ggplot(aes(father_strata, son)) +
  geom_boxplot() +
  geom_point()
# The means of each stratum above seem to follow a linear relationship.
galton_heights %>%
  mutate(father = round(father)) %>%
  group_by(father) %>%
  summarize(son_conditional_avg = mean(son)) %>%
  ggplot(aes(father, son_conditional_avg)) +
  geom_point()
# The slope of a best fit line in the above plot is 0.5
# Just like our calculated corr earlier!

# We can see this connection when plotting the standardized heights as points w/ corr. coef. as slope of a line.
r = galton_heights %>% summarize(r = cor(father, son)) %>% .$r
galton_heights %>%
  mutate(father = round(father)) %>%
  group_by(father) %>%
  summarize(son = mean(son)) %>%
  mutate(z_father = scale(father), z_son = scale(son)) %>%
  ggplot(aes(z_father, z_son)) +
  geom_point() +
  geom_abline(intercept = 0, slope = r)
# The line above is known as the Regression line.

# Regression line tells us 
# for every standard dev sd(x) increase above avg mu(x),
# y grows r (from above calc) standard devs sd(y) above avg mu(y)

# In other words, the average change of y in sd(y) units
# is equal to rho * the average change of x in sd(x) units

# The above written in the form of a standard line (y = mx + b):
  # slope m = rho * (sd(y) / sd(x))
  # intercept b = mu(y) - m * mu(x)
# If we standardize vars to have avg = 0 and sd = 1, regression line has
  # intercept b = 0
  # slope m = rho

# Computing intercept & slope of regression line
mu_x = mean(galton_heights$father)
mu_y = mean(galton_heights$son)
s_x = sd(galton_heights$father)
s_y = sd(galton_heights$son)
r = cor(galton_heights$father, galton_heights$son)
m = r * s_y / s_x
b = mu_y - m * mu_x

# Plotting original data w/ calculated reg line
galton_heights %>%
  ggplot(aes(father, son)) +
  geom_point(alpha = 0.5) +
  geom_abline(intercept = b, slope = m)

# Plotting standardized data w/ reg line
galton_heights %>%
  ggplot(aes(scale(father), scale(son))) + # scale() standardizes all vals
  geom_point(alpha = 0.5) +
  geom_abline(intercept = 0, slope = r)

# Regression line shows that the conditional means appear to follow a linear pattern;
# Thus, the regression line gives us the prediction

# Percent of variability in son's height explained by father's height = rho ^ 2
r^2 


