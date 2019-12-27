library(Lahman)
library(tidyverse)
library(broom)
library(ggrepel)
library(reshape2)
library(lpSolve)

options(digits = 3)

# Extends 8_better_offense_metric.R

# Defining params
players = players %>% filter(debut <= "1997-01-01" & debut > "1988-01-01")

constraint_matrix = acast(players, POS ~ playerID, fun.aggregate = length)

npos = nrow(constraint_matrix)

constraint_matrix = rbind(constraint_matrix, salary = players$salary)

constraint_dir = c(rep("==", npos), "<=")

constraint_limit = c(rep(1, npos), 50 * 10^6)

# This algorithm chooses all the best players for our budget
lp_solution = lp("max", players$R_hat,
                 constraint_matrix, constraint_dir, constraint_limit,
                 all.int = TRUE)
lp_solution$solution

# This algorithm chooses the actual team
our_team = players %>% 
  filter(lp_solution$solution == 1) %>% 
  arrange(desc(R_hat))

our_team %>% select(nameFirst, nameLast, POS, salary, R_hat)

#    nameFirst    nameLast POS   salary R_hat
# 1     Jason      Giambi  1B 10428571  7.99
# 2     Nomar Garciaparra  SS  9000000  7.51
# 3      Mike      Piazza   C 10571429  7.16
# 4      Phil       Nevin  3B  2600000  6.75
# 5      Jeff        Kent  2B  6000000  6.68
# IMPORTANT NOTE: For some reason the team here is not the same as the team in the example
#                 b/c three positions (CF, LF, RF) were filtered out when players was defined.


# Our team generally has above avg BB and HR rates,
# but below avg for singles.
my_scale = function(x) (x - median(x)) / mad(x)
players %>% mutate(BB = my_scale(BB),
                   singles = my_scale(singles),
                   doubles = my_scale(doubles),
                   triples = my_scale(triples),
                   HR = my_scale(HR),
                   AVG = my_scale(AVG),
                   R_hat = my_scale(R_hat)) %>% 
  filter(playerID %in% our_team$playerID) %>% 
  select(nameFirst, nameLast, BB, singles, doubles, triples, HR, AVG, R_hat) %>% 
  arrange(desc(R_hat))

# nameFirst nameLast     BB     singles  doubles  triples HR      AVG    R_hat
# Jason     Giambi       3.118 -0.5382   0.908   -0.633   1.905   2.496  3.67
# Nomar     Garciaparra  0.154  1.6114   3.141    0.467   0.917   3.795  3.06
# Mike      Piazza       0.459 -0.0811  -0.188   -1.266   2.476   1.584  2.63
# Phil      Nevin        0.649 -0.6745   0.809   -1.076   1.938   0.989  2.11
# Jeff      Kent         0.732 -0.2916   2.178    1.176   0.883   1.548  2.03

