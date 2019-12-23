
# Analyze Galton's dataset

library(HistData)
library(tidyverse)

data("GaltonFamilies")

# Galton wanted to find how much parents' height determined son height
galton_heights = GaltonFamilies %>%
  filter(childNum == 1 & gender == "male") %>%
  select(father, childHeight) %>%
  rename(son = childHeight)

# b/c the heights are normally dist. we can summarize them w/ avg and sd
galton_heights %>%
  summarize(mean(father), sd(father), mean(son), sd(son))
# mean(father)  sd(father)   mean(son)  sd(son)
# 69.09888      2.546555     70.45475   2.557061

# Important characteristic of above data
galton_heights %>% ggplot(aes(father, son)) +
  geom_point(alpha = 0.5)
# The above plot shows: the taller the dad, the taller the son 
# Summary stats, avg & sd, do not tell us
# anything about the correlation b/w son & father heights


# Notes on Correlation Coefficient (CC)

# CC = ∑i_n{
#    ( (x_i - mu_x) /
#       sigma_x)
#         *
#    ( (y_i - mu_y) /
#       sigma_y)
# }

# Correlation b/w father and son heights
galton_heights %>% summarize(cor(father, son)) # 0.5
