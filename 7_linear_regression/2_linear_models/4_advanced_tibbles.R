library(Lahman)
library(tidyverse)


# Initial way we learned to calc regression line
dat = Teams %>% filter(yearID %in% 1961:2001) %>% 
  mutate(HR = round(HR / G, 1),
         BB = BB / G,
         R = R / G) %>% 
  select(HR, BB, R) %>% 
  filter(HR >= 0.4 & HR <= 1.2)
names(dat)

dat %>% 
  group_by(HR) %>% 
  summarize(slope = cor(BB, R) * sd(R) / sd(BB))


# If we want to use the lm() to get the slope,
# we SHOULD NOT use this approach:
dat %>% 
  group_by(HR) %>% 
  lm(R ~ BB, data = .) %>% 
  .$coef
# The lm() IGNORED the group_by b/c it doesn't know how to deal
# w/ tidyverse's grouped tibble (created by group_by())

# summarize(), on the other hand, knows which rows of the tibble belong to which groups
dat %>% group_by(HR) %>% head
# A tibble: 6 x 3
# Groups:   HR [5]
#  HR    BB     R
# <dbl> <dbl> <dbl>
#  0.9  3.56  4.24
#  0.7  3.97  4.47
#  0.8  3.37  4.69
#  1.1  3.46  4.42
#  1    2.75  4.61
#  0.9  3.06  4.58

# Inspect the class of the above
dat %>% group_by(HR) %>% class
# "grouped_df" "tbl_df"   "tbl"   "data.frame"

# "tbl" = tibble
# A tibble is a special kind of dataframe
# group_by() & summarize() always return tibbles
# group_by() returns a special tibble named grouped_df AKA a grouped tibble

# Tibbles are the default dataframe of tidverse library


# Differences b/w tibbles and regular dataframes

# 1. Tibbles display better
Teams # A regular df... so ugly
as_tibble(Teams) # Sexy tibble

# 2. Subsets of tibbles are tibbles
class(Teams[,20]) # Class of regular df col: integer
class(as_tibble(Teams)[,20]) # Class of tibble col: tibble
# Subsets of tibbles useful b/c funcs in tidyverse require dfs as inputs
# However, if we REALLY need to access the original vector of a col, we access it w/ $
class(as_tibble(Teams)$HR) # Integer
# Also, regular dfs don't give warnings when trying to access a col that doesn't exist
Teams$hr # NULL
# Tibbles throw a warning indicating what went wrong
as_tibble(Teams)$hr
# Warning message: Unknown or uninitialised column: 'hr'. 

# 3. Tibbles can have complex entries
# Tibbles can have entries that are lists or funcs
tibble(id = c(1, 2, 3), func = c(mean, median, sd))
# A tibble: 3 x 2
#  id    func  
# <dbl> <list>
#   1    <fn>  
#   2    <fn>  
#   3    <fn>  

# 4. Tibbles can be grouped

# Since lm() does not recognize tibbles, we need to use another function: do()






