library(HistData)
library(tidyverse)
data("GaltonFamilies")
set.seed(1983)
galton_heights <- GaltonFamilies %>%
  filter(gender == "male") %>%
  group_by(family) %>%
  sample_n(1) %>%
  ungroup() %>%
  select(father, childHeight) %>%
  rename(son = childHeight)



# Least squares equation quantifies the values that minimize the distance of the fitted model to the data.

# Residual sum of squares (RSS)
# The value that minimizes the RSS is called the Least Squares Estimate (LSE)

# Compute RSS for any pair of beta0 and beta1 in Galton's data
rss = function(beta0, beta1, data){
  resid = galton_heights$son - (beta0 + beta1 * galton_heights$father)
  return(sum(resid^2))
}

# Since we have an RSS value for any pair of vals beta0 and beta1, we can make a 3d plot, w/ RSS as the Z axis, to find the minimum val
# To represent it in 2d we will keep beta0 fixed to 25, that way we are only analyzing the changes of beta1 and RSS
beta1 = seq(0, 1, len = nrow(galton_heights))
results = data.frame(beta1 = beta1,
                     rss = sapply(beta1, rss, beta0 = 25))
results %>% ggplot(aes(beta1, rss)) +
  geom_line() +
  geom_line(aes(beta1, rss), col=2)
# The min is around 0.65. 
# It is important to remember that this minimum was caculated while beta0 was fixed;
# In order to find the true min, we need some calculus. This can be done w/ funcs in R.
