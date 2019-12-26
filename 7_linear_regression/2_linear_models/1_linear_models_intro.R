library(Lahman)
library(tidyverse)
options(digits = 3)
# Are BBs more predictive of runs?


# The slope of reg line b/w R per game and BB per game is 0.735.
# Does this mean that getting a player that scores 2 BBs more per game on avg will incr. runs by 1.47 (2 * 0.735)?

# NO!!! Association is NOT causation.
# Teams that score 2 BBs above avg DO score 1.47 runs overall,
# but this does not mean that BBs are the cause.

# Reg line slope for 1Bs (singles) is 0.449, a lower val
# Even though 1Bs get players to 1st base like BBs

# The reason BBs are more predictive of Rs is b/c of confounding


Teams %>%
  filter(yearID %in% 1961:2001) %>%
  mutate(Singles = (H - HR - X2B - X3B) / G, BB = BB / G, HR = HR / G) %>%
  summarize(cor(BB, HR), cor(Singles, HR), cor(BB, Singles))

#    cor(BB, HR)  cor(Singles, HR)  cor(BB, Singles)
#    0.404        -0.174            -0.056

# Cor b/w BBs and HRs is relatively high
# The reason for this is that, in reality, pitchers that know a team has HR hitters
# will create more BBs to avoid conceding HRs
# Result: HR hitters tend to have more BBs

# Turns out it's primarily HRs that cause more Rs, not BBs as it appeared
# The misconception that BBs cause more Rs is stated as:
  # BBs are CONFOUNDED w/ HRs

# To find out if BBs still have an effect on Rs,
# we have to adjust for the HR effect on Rs through regression.
