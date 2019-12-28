library(tidyverse)
library(broom)
library(Lahman)
Teams_small <- Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(avg_attendance = attendance/G)

# Predict avg attendance w/ respect to R / G and HR / G and W
Teams_small %>% mutate(R = R / G) %>% lm(avg_attendance ~ R, data = .)
Teams_small %>% mutate(HR = HR / G) %>% lm(avg_attendance ~ HR, data = .)
Teams_small %>% lm(avg_attendance ~ W, data = .)

# Avg attendance incr per yr
Teams_small %>% lm(avg_attendance ~ yearID, data = .)

# Correl. of W w/ R / G and W w/ HR / G
Teams_small %>% mutate(R = R / G) %>% summarize(cor(W, R))
Teams_small %>% mutate(HR = HR / G) %>% summarize(cor(W, HR))

# Create stratafied dataset by dividing W by 10 and rounding to nearest int
stratified_teams = Teams_small %>% mutate(W = round(W / 10)) %>% 
  filter(W >= 5 & W <= 10 & n() >= 20)

# How many teams have a W strata = 8?
stratified_teams %>% filter(W == 8) %>% nrow() # 338

# Which stratum has the largest reg line slope predicting avg attendance for each W strata?
stratified_teams %>% mutate(R = R / G) %>% group_by(W) %>% 
  do(tidy(lm(avg_attendance ~ R, data = .))) %>% 
  filter(term == "R") %>% arrange(desc(estimate))

# Do the same as above except for HR instead of R
stratified_teams %>% mutate(HR = HR / G) %>% group_by(W) %>% 
  do(tidy(lm(avg_attendance ~ HR, data = .))) %>% 
  filter(term == "HR") %>% arrange(desc(estimate))

# Fit a multi-var reg to determine effects of R / G, HR / G, W, and yr on avg attendance
Teams_small %>% mutate(R = R / G, HR = HR / G) %>% 
  lm(avg_attendance ~ R + HR + W + yearID, data = .) %>% 
  .$coef
# (Intercept)     R       HR       W       yearID 
# -456674         322     1798     117     230 

# Use above formula to calc the effect of: R = 5, HR = 1.2, W = 80, yr = 2002 & 1960
fit = Teams_small %>% mutate(R = R / G, HR = HR / G) %>% 
  lm(avg_attendance ~ R + HR + W + yearID, data = .)

dat = data.frame(R = 5, HR = 1.2, W = 80, yearID = 2002)
predict(fit, newdata = dat) # 16149

dat = data.frame(R = 5, HR = 1.2, W = 80, yearID = 1960)
predict(fit, newdata = dat) # 6505

# Predict avg attendance from original Teams data frame, what is the correl. b/w predicted and actual
Teams %>% 
  filter(yearID %in% 2002) %>% # We use 2002 here to plot the actual results of that year; we will specify our prediction to plot against it bellow
  mutate(HR = HR / G, R = R / G) %>% 
  mutate(attend_hat = predict(fit, newdata = .)) %>% 
  summarize(cor(attend_hat, attendance))
# Correl. is 0.519


