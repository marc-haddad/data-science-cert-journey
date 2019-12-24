library(tidyverse)
library(Lahman)

# To find out the effect of BBs on Rs (independant of HRs),
# we can keep HRs fixed and then examine rel b/w Rs and BBs.


# First: we stratify HR per G to the closest 10th
dat = Teams %>% filter(yearID %in% 1961:2001) %>% 
  mutate(HR_strata = round(HR / G, 1),
         BB_per_game = BB / G,
         R_per_game = R / G) %>% 
  filter(HR_strata >= 0.4 & HR_strata <= 1.2)
dat # Stratified data-set

# Scatter Plot
dat %>% 
  ggplot(aes(BB_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap(~HR_strata)
# Plot shows the effect of BBs on Rs for each strata of HR

# When not controlling for the effect of HRs,
# the slope of the reg line for predicting Rs w/ BBs = 0.735

# When controlling for HRs, the reg line slopes are significantly reduced.
dat %>% 
  group_by(HR_strata) %>% 
  summarize(slope = cor(BB_per_game, R_per_game) * sd(R_per_game) / sd(BB_per_game))
# A tibble: 9 x 2
# HR_strata  slope
#   <dbl>   <dbl>
#   0.4     0.734
#   0.5     0.566
#   0.6     0.412
#   0.7     0.285
#   0.8     0.365
#   0.9     0.261
#   1       0.511
#   1.1     0.454
#   1.2     0.440

# The above vals are closer to the slope obtained from 1Bs (0.449)

# Check to see if, after stratifying HRs, there remains any HR effects on BBs predicting Rs
# Do this by stratifying BBs and seeing the effect on HRs on Rs
dat = Teams %>% filter(yearID %in% 1961:2001) %>% 
  mutate(BB_strata = round(BB / G, 1), 
         HR_per_game = HR / G,
         R_per_game = R / G) %>% 
  filter(BB_strata >= 2.8 & BB_strata <= 3.9)
dat %>% 
  ggplot(aes(HR_per_game, R_per_game)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method = "lm") +
  facet_wrap(~BB_strata)

# The slopes of the above plot:
dat %>% group_by(BB_strata) %>% 
  summarize(slope = cor(HR_per_game, R_per_game) * sd(R_per_game) / sd(HR_per_game))
# A tibble: 12 x 2
# BB_strata slope
# <dbl>     <dbl>
# 2.8       1.52
# 2.9       1.57
# 3         1.52
# 3.1       1.49
# 3.2       1.58
# 3.3       1.56
# 3.4       1.48
# 3.5       1.63
# 3.6       1.83
# 3.7       1.45
# 3.8       1.70
# 3.9       1.30

# Slopes are approx. b/w 1.5 & 1.7;
# Does not change from the original slope estimate of 1.84 (where we don't control for BBs)


