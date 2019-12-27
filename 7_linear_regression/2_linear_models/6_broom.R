library(tidyverse)
library(broom)
dat = Teams %>% filter(yearID %in% 1961:2001) %>% 
  mutate(HR = round(HR / G, 1),
         BB = BB / G,
         R = R / G) %>% 
  select(HR, BB, R) %>% 
  filter(HR >= 0.4 & HR <= 1.2)


# broom returns lm() objects as tidyverse friendly dfs

# The main funcs are:
  # tidy()
  # glance()
  # augment()


# tidy() returns estimates and related info as a df
fit = lm(R ~ BB, data = dat)
tidy(fit)
# A tibble: 2 x 5
# term        estimate std.error statistic  p.value
# <chr>          <dbl>     <dbl>     <dbl>    <dbl>
# (Intercept)    2.20     0.113      19.4    1.12e-70
# BB             0.638    0.0344     18.5    1.35e-65

# We can add important summaries to tidy(), like conf.int
tidy(fit, conf.int = TRUE)
# A tibble: 2 x 7
# term        estimate   std.error statistic  p.value   conf.low conf.high
# <chr>          <dbl>     <dbl>     <dbl>    <dbl>      <dbl>     <dbl>
# (Intercept)    2.20     0.113       19.4   1.12e-70    1.98      2.42 
# BB             0.638    0.0344      18.5   1.35e-65    0.570     0.705

# B/c tidy() returns a df, we can use it w/ do() and filter() and select()
dat %>% 
  group_by(HR) %>% 
  do(tidy(lm(R ~ BB, data = .), conf.int = TRUE)) %>% 
  filter(term == "BB") %>% 
  select(HR, estimate, conf.low, conf.high)
# A tibble: 9 x 4
# Groups:   HR [9]
#     HR   estimate  conf.low  conf.high
#    <dbl>   <dbl>    <dbl>     <dbl>
# 1   0.4    0.734    0.308     1.16 
# 2   0.5    0.566    0.346     0.786
# 3   0.6    0.412    0.219     0.605
# 4   0.7    0.285    0.146     0.425
# 5   0.8    0.365    0.236     0.494
# 6   0.9    0.261    0.112     0.410
# 7   1      0.511    0.363     0.660
# 8   1.1    0.454    0.284     0.624
# 9   1.2    0.440    0.280     0.601


# A table like the one above makes visualization w/ ggplot easier.
dat %>% 
  group_by(HR) %>% 
  do(tidy(lm(R ~ BB, data = .), conf.int = TRUE)) %>% 
  filter(term == "BB") %>% 
  select(HR, estimate, conf.low, conf.high) %>% 
  ggplot(aes(HR, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point()



# glance() deals w/ model-specific outcomes

# augment() deals w/ observation-specific outcomes


