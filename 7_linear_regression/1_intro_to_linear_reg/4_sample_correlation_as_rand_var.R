library(HistData)
library(tidyverse)

data("GaltonFamilies")
set.seed(0)

galton_heights = GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)


# Sample correlation is the most useful estimate of the population correlation
# Thus, the sample correlation is a random var


# Assume the 179 father-son pairs above is entire pop
# Take a sample of 25
R = sample_n(galton_heights, 25, replace = TRUE) %>%
  summarize(cor(father, son))
R # 0.589, sort of close to our pop correl. of 0.5

# We can run a monte carlo sim to see if n = 25 is of sufficient size
B = 1000
N = 25
R = replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>%
    summarize(r = cor(father, son)) %>% .$r
})
data.frame(R) %>% ggplot(aes(R)) + geom_histogram(binwidth = 0.05, color = "black")
# From the plot above, the expected value of our sim is the pop correlation
mean(R) # 0.504
# However, R has a relatively high Standard Error:
sd(R) # 0.144

# B/c the sample corr is an avg of independent draws
# CLT dictates that the dist of Rs from a large enough N is Normal




