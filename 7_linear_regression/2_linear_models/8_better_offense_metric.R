library(Lahman)
library(tidyverse)
library(broom)
library(ggrepel)

options(digits = 3)

fit = Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(BB = BB / G, HR = HR / G, R = R / G) %>% 
  lm(R ~ BB + HR, data = .) # + lets lm() know to fit to multiple reg model
fit
# Call:
#   lm(formula = R ~ BB + HR, data = .)
# 
# Coefficients:
#   (Intercept)     BB        HR  
#   1.7443          0.3874    1.5612 

# The above is a code that fits the multiple regression model:
# Y_i = Beta_0 + Beta_1 * x_1 + Beta_2 * x_2 + epsilon_i

# Use tidy() for clean summary 
tidy(fit, conf.int = TRUE)
# A tibble: 3 x 7
# term        estimate std.error  statistic   p.value  conf.low   conf.high
# <chr>          <dbl>     <dbl>    <dbl>     <dbl>     <dbl>     <dbl>
# (Intercept)    1.74     0.0824    21.2    7.62e- 83    1.58      1.91 
# BB             0.387    0.0270    14.3    1.20e- 42    0.334     0.440
# HR             1.56     0.0490    31.9    1.78e-155    1.47      1.66 

# In previous scripts, we fit the model to 1 var, w/o adjustment:
  # Estimated slopes: BB = 0.735, HR = 1.844
# Here, using the multivariate approach, both slopes decreased:
  # Estimated slopes: BB = 0.387, HR = 1.56


# Creating multiple regression model that predicts R 
# by combining the other offensive metrics 1B, 2B, 3B w/ our HR-BB model.

# We make 2 important assumptions:
  # 1. The five vars are jointly normal. This means if we pick any 1 var, and hold the
  #    other 4 vars fixed the relationship w/ the outcome (i.e. Runs per game) is linear.
  # 2. The slopes for this relationship do not depend on the other 4 vars that were held constant.

# If the 2 assumptions hold true, our model should look like this:
  # Y_i = Beta_0 + Beta_1 * x_i_1 + Beta_2 * x_i_2 + Beta_3 * x_i_3 + 
  #       Beta_4 * x_i_4 + Beta_5 * x_i_5 + epsilon_i
# W/ the x's above representing, respectively: BB, B1, B2, B3, HR (all are per game)

# Finding the LSE for our new model:
fit = Teams %>% 
  filter(yearID %in% 1961:2001) %>% 
  mutate(BB = BB / G,
         singles = (H - X2B - X3B - HR) / G,
         doubles = X2B / G,
         triples = X3B / G,
         HR = HR / G,
         R = R / G) %>% 
  lm(R ~ BB + singles + doubles + triples + HR, data = .)

coefs = tidy(fit, conf.int = TRUE)
coefs
# A tibble: 6 x 7
#     term        estimate std.error statistic   p.value  conf.low  conf.high
#    <chr>          <dbl>     <dbl>     <dbl>     <dbl>     <dbl>     <dbl>
# 1 (Intercept)   -2.77     0.0862     -32.1    4.76e-157   -2.94     -2.60 
# 2 BB             0.371    0.0117      31.6    1.87e-153    0.348     0.394
# 3 singles        0.519    0.0127      40.8    8.67e-217    0.494     0.544
# 4 doubles        0.771    0.0226      34.1    8.44e-171    0.727     0.816
# 5 triples        1.24     0.0768      16.1    2.12e- 52    1.09      1.39 
# 6 HR             1.44     0.0243      59.3    0.           1.40      1.49 

# To see how well our model predicts runs, we predict the number of runs for each team 2002
# and compare it to the actual results of the 2002 season
Teams %>% 
  filter(yearID %in% 2002) %>% # We use 2002 here to plot the actual results of that year; we will specify our prediction to plot against it bellow
  mutate(BB = BB / G,
         singles = (H - X2B - X3B - HR) / G,
         doubles = X2B / G,
         triples = X3B / G,
         HR = HR / G,
         R = R / G) %>% 
  mutate(R_hat = predict(fit, newdata = .)) %>% # Here is where we specify our predicted data we calculated earlier
  ggplot(aes(R_hat, R, label = teamID)) +
  geom_point() +
  geom_text_repel() +
  geom_abline()
# Our plot above shows that our predictions are pretty accurate to reality
# due to the fact that the actual results are close to our identity line

# Our fitted model formula:
# -2.769 + 0.371 * BB + 0.519 * singles + 0.771 * doubles +
# 1.240 * triples + 1.443 * HR


# Going deeper: Per-player analysis

# The per-plate-appearance rate takes game participation of every individual player into account
pa_per_game = Batting %>% filter(yearID == 2002) %>% 
  group_by(teamID) %>% 
  summarize(pa_per_game = sum(AB + BB) / max(G)) %>% 
  .$pa_per_game %>% 
  mean
# 38.747

# Using data from 1999 to 2001 to predict 2002 ppa
players = Batting %>% filter(yearID %in% 1999:2001) %>% 
  group_by(playerID) %>% 
  mutate(PA = BB + AB) %>% 
  summarize(G = sum(PA) / pa_per_game,
            BB = sum(BB) / G,
            singles = sum(H - X2B - X3B - HR) / G,
            doubles = sum(X2B) / G,
            triples = sum(X3B) / G,
            HR = sum(HR) / G,
            AVG = sum(H) / sum(AB),
            PA = sum(PA)) %>% 
  filter(PA >= 300) %>% # Filter out players that didn't play very much
  select(-G) %>% 
  mutate(R_hat = predict(fit, newdata = .))
# The results from the above formula can be interpreted as:
# The num of Rs we predict a team would score if all batters are exactly like a specific player

players %>% ggplot(aes(R_hat)) +
  geom_histogram(binwidth = 0.5, color = "black")

# To build a team, w/ efficient results per expenses ratio
# we need to know each player's salaries and positions

# Start by adding the 2002 salaries of each player
players = Salaries %>% 
  filter(yearID == 2002) %>% 
  select(playerID, salary) %>% 
  right_join(players, by = "playerID")

# Add a defensive position
# Fairly complicated b/c players play more than one position each year
# Solution: pick the one position most played by each player using top_n()
#           If there is a tie, we will pick the first row returned
# We also have to remove "OF" b/c OF contains multiple positions and is a general term
# Also, remove pitchers
players = Fielding %>% filter(yearID == 2002) %>% 
  filter(!POS %in% c("OF", "P")) %>% 
  group_by(playerID) %>% 
  top_n(1, G) %>% 
  filter(row_number(G) == 1) %>% 
  ungroup() %>% 
  select(playerID, POS) %>% 
  right_join(players, by = "playerID") %>% 
  filter(!is.na(POS) & !is.na(salary))
# Finally, add names and last names:
players = Master %>% 
  select(playerID, nameFirst, nameLast, debut) %>% 
  right_join(players, by = "playerID")
players %>% select(nameFirst, nameLast, POS, salary, R_hat) %>% 
  arrange(desc(R_hat)) %>% 
  top_n(10)

# Selecting by R_hat
# nameFirst  nameLast     POS    salary  R_hat
# Todd       Helton       1B    5000000  8.23
# Jason      Giambi       1B   10428571  7.99
# Albert     Pujols       3B     600000  7.54
# Nomar      Garciaparra  SS    9000000  7.51
# Jeff       Bagwell      1B   11000000  7.48
# Alex       Rodriguez    SS   22000000  7.44
# Carlos     Delgado      1B   19400000  7.37
# Rafael     Palmeiro     1B    8712986  7.26
# Mike       Piazza        C   10571429  7.16
# Jim        Thome        1B    8000000  7.16

# Players w/ high metrics have high salaries
players %>% ggplot(aes(salary, R_hat, color = POS)) +
  geom_point() +
  scale_x_log10()

# B/c rookies can't negotiate for salaries we can filter them out
players %>% filter(debut < 1998) %>% 
  ggplot(aes(salary, R_hat, color = POS)) +
  geom_point() +
  scale_x_log10()
# We see a lot of the low-cost high performance players have decreased

# Using the above graph we can pick the highest performers w/ the lowest salaries for our team
