library(Lahman)
library(tidyverse)
library(dslabs)

ds_theme_set()


# Which is better for a team: Bases on balls (BBs) or Stolen bases (SBs)?

# Do teams that hit more HRs score more runs overall?

# Best way to visualize the relationship of 2 vars: Scatter plot

# HRs and Rs per game
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(HR_per_game = HR / G, R_per_game = R / G) %>%
  ggplot(aes(HR_per_game, R_per_game)) +
  geom_point(alpha = 0.5)
# We can see a strong correl. b/w hr_per_game and total runs per game

# SBs and Rs per game
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(SB_per_game = SB / G, R_per_game = R / G) %>%
  ggplot(aes(SB_per_game, R_per_game)) +
  geom_point(alpha = 0.5)
# Relationship not clear

# BBs and Rs per game
Teams %>% filter(yearID %in% 1961:2001) %>%
  mutate(BB_per_game = BB / G, R_per_game = R / G) %>%
  ggplot(aes(BB_per_game, R_per_game)) +
  geom_point(alpha = 0.5)
# Strong correl. b/w BBs and Rs, not as strong as HRs