library(Lahman)
library(tidyverse)
library(broom)
library(ggrepel)
library(reshape2)
library(lpSolve)

options(digits = 3)


# Is the "Sophomore Slump" real?


# Create a table of all players that recieved "Rookie of the Year"

# First create a table of all players w/ respective POS
playerInfo = Fielding %>% 
  group_by(playerID) %>% 
  arrange(desc(G)) %>% 
  slice(1) %>% 
  ungroup %>% 
  left_join(Master, by = "playerID") %>% 
  select(playerID, nameFirst, nameLast, POS)
playerInfo

# Filter for rookie award winners and add batting stats
# Focus on batting avg to see if sophomore slump holds
ROY = AwardsPlayers %>% 
  filter(awardID == "Rookie of the Year") %>% 
  left_join(playerInfo, by = "playerID") %>% 
  rename(rookie_year = yearID) %>% 
  right_join(Batting, by = "playerID") %>% 
  mutate(AVG = H / AB) %>% 
  filter(POS != "P")
ROY

# Now we keep only the rookie and sophomore seasons for comparison
ROY = ROY %>% 
  filter(yearID == rookie_year | yearID == rookie_year + 1) %>% 
  group_by(playerID) %>% 
  mutate(rookie = ifelse(yearID == min(yearID), "rookie", "sophomore")) %>% 
  filter(n() == 2) %>% # Removes players that didn't play a sophomore season
  ungroup() %>% 
  select(playerID, rookie_year, rookie, nameFirst, nameLast, AVG)

# Use spread() to make one column for rookies and another for AVG
ROY = ROY %>% spread(rookie, AVG) %>% arrange(desc(rookie))
ROY 
# A tibble: 102 x 6
# playerID  rookie_year  nameFirst nameLast rookie sophomore
#  <chr>       <int>     <chr>     <chr>     <dbl>     <dbl>
# mccovwi01     1959     Willie    McCovey   0.354     0.238
# suzukic01     2001     Ichiro    Suzuki    0.350     0.321
# bumbral01     1973     Al        Bumbry    0.337     0.233
# lynnfr01      1975     Fred      Lynn      0.331     0.314
# pujolal01     2001     Albert    Pujols    0.329     0.314
# troutmi01     2012     Mike      Trout     0.326     0.323
# braunry02     2007     Ryan      Braun     0.324     0.285
# olivato01     1964     Tony      Oliva     0.323     0.321
# hargrmi01     1974     Mike      Hargrove  0.323     0.303
# darkal01      1948     Al        Dark      0.322     0.276
# … with 92 more rows

# The tibble above shows the rookies of the year for each year w/ batting stats (rookie and sophomore),
# ordered by rookie batting stats.

# From the data above we deduce that the "Sophomore Slump" does appear to be real.
# 68% of players have a lower batting avg in their sophomore yr compared to their rookie yr.


# Why does this happen? We need to turn our attention to all players for the answer

# Construct dataset of 2013 & 2014 season player stats
two_years = Batting %>% 
  filter(yearID %in% 2013:2014) %>% 
  group_by(playerID, yearID) %>% 
  filter(sum(AB) >= 130) %>% # This is the min num of at bats to be considered for ROY
  summarize(AVG = sum(H) / sum(AB)) %>% 
  ungroup() %>% 
  spread(yearID, AVG) %>% 
  filter(!is.na(`2013`) & !is.na(`2014`)) %>% 
  left_join(playerInfo, by = "playerID") %>% 
  filter(POS != "P") %>% 
  select(-POS) %>% 
  arrange(desc(`2013`)) %>% 
  select(-playerID)
two_years
# A tibble: 312 x 4
# `2013` `2014` nameFirst nameLast
# <dbl>  <dbl>  <chr>     <chr>   
# 0.348  0.313  Miguel    Cabrera 
# 0.345  0.283  Hanley    Ramirez 
# 0.331  0.332  Michael   Cuddyer 
# 0.324  0.289  Scooter   Gennett 
# 0.324  0.277  Joe       Mauer   
# 0.323  0.287  Mike      Trout   
# 0.321  0.263  Chris     Johnson 
# 0.319  0.288  Freddie   Freeman 
# 0.319  0.296  Yasiel    Puig    
# 0.319  0.282  Yadier    Molina  
# … with 302 more rows

# The above is sorted in desc order by 2013 performance.

# When comparing 2013 and 2014 we see that the "sophomore slump" also applies to these top performing players;
# even though they aren't rookies. Therefore, the decrease b/w years can't be explained by the sophomore slump.

# Notice what happens to the worst performers of 2013:
arrange(two_years, `2013`)
# A tibble: 312 x 4
# `2013` `2014` nameFirst nameLast 
# <dbl>  <dbl>  <chr>     <chr>    
# 0.158  0.219  Danny     Espinosa 
# 0.179  0.149  Dan       Uggla    
# 0.181  0.2    Jeff      Mathis   
# 0.184  0.208  Melvin    Upton    
# 0.190  0.262  Adam      Rosales  
# 0.192  0.215  Aaron     Hicks    
# 0.194  0.229  Chris     Colabello
# 0.194  0.177  J. P.     Arencibia
# 0.195  0.241  Tyler     Flowers  
# 0.198  0.218  Ryan      Hanigan  
# … with 302 more rows

# The worst performers actually performed better in 2014


# THERE IS NO SUCH THING AS A SOPHOMORE SLUMP

# The difference is explained by a simple stat fact:
# Correl. for performance in 2 separate yrs is high but not perfect

# Plot that shows high correl. but not perfect:
two_years %>% ggplot(aes(`2013`, `2014`)) + geom_point()
# Calc of correl.
summarize(two_years, cor(`2013`, `2014`)) # = 0.46

# The above shows us that the data looks like a bivariate normal dist.
# This means we can use the regression equation to predict vals


# B/c the correl. is not perfect, regression tells us that: 
# On avg high performers in one year will perform worse in the next, and
# On avg low performers in one year will perform better in the next

# AKA Regression to the mean

