library(gtools)
library(tidyverse)
options(digits = 3)

set.seed(1)

# Jamaica Prob
nrow(permutations(3,3))
3/8 * 2/7 * 1/6

runners <- c("Jamaica", "Jamaica", "Jamaica", "USA", "Ecuador",
             "Netherlands", "France", "South Africa")
B = 10000
jam_triple = replicate(B, {
  win = sample(runners, 3)
  all(win == c("Jamaica", "Jamaica", "Jamaica"))
})
mean(jam_triple)

# Restaurant Prob

entrees = combinations(6, 1, 1:6)
sides = combinations(6, 2, 1:6)
drinks = combinations(2, 1, 1:2)
side_possib = paste(sides[,1], sides[,2])
nrow(expand.grid(entrees, side_possib, drinks))

drinks_expand = combinations(3, 1, 1:3)
drinks_expand
nrow(expand.grid(entrees, side_possib, drinks_expand))

sides_expanded_options = combinations(6, 3, 1:6)
sides_expanded = paste(sides_expanded_options[,1],
                       sides_expanded_options[,2],
                       sides_expanded_options[,3])
nrow(expand.grid(entrees, sides_expanded, drinks_expand))

entree_func = function(ent) {
  entrees_expanded = combinations(ent, 1, 1:ent)
  nrow(expand.grid(entrees_expanded, side_possib, drinks_expand))
}
sapply(1:12, entree_func)

sides_func = function(nside) {
  sides_possible_choices = combinations(nside, 2)
  sides_paste_choices = paste(sides_possible_choices[,1],
                              sides_possible_choices[,2])
  nrow(expand.grid(entrees, sides_paste_choices, drinks_expand))
}
sapply(2:12, sides_func)


# Esophageal Cancer Prob
head(esoph)
nrow(esoph)
all_cases = sum(esoph$ncases)
all_controls = sum(esoph$ncontrols)

highest_alc_consumption_grp = esoph %>%
  filter(alcgp == "120+")
prob_high_alc = sum(highest_alc_consumption_grp$ncases) / 
  (sum(highest_alc_consumption_grp$ncases) +
     sum(highest_alc_consumption_grp$ncontrols))
prob_high_alc

lowest_alc = esoph %>%
  filter(alcgp == "0-39g/day")
prob_lowest_alc = sum(lowest_alc$ncases)/
  (sum(lowest_alc$ncases) + sum(lowest_alc$ncontrols))
prob_lowest_alc

cases = esoph %>%
  filter(ncases > 0)
ncases_10g = cases %>%
  filter(tobgp == "10-19" | tobgp == "20-29" | tobgp == "30+")
ncases_10g_sum = sum(ncases_10g$ncases)
cases_sum = sum(cases$ncases)
prob_10g = ncases_10g_sum/cases_sum
prob_10g

controls = esoph
control_smokers = controls %>%
  filter(tobgp == "10-19" | tobgp == "20-29" | tobgp == "30+")
prob_smoke = sum(control_smokers$ncontrols) / sum(controls$ncontrols)
prob_smoke

highest_alc = esoph %>%
  filter(alcgp == "120+")
prob_cancer_hialc = sum(highest_alc$ncases)/all_cases

highest_tob = esoph %>%
  filter(tobgp == "30+")
prob_cancer_hitob = sum(highest_tob$ncases)/all_cases
prob_cancer_hitob

highest_alctob = esoph %>%
  filter(alcgp == "120+" & tobgp == "30+")
prob_alctob = sum(highest_alctob$ncases)/all_cases
prob_alctob

highest_alc_or_tob_cases = prob_cancer_hialc + prob_cancer_hitob - prob_alctob



hialc_control = esoph %>%
  filter(alcgp == "120+")
prob_hialc_control = sum(hialc_control$ncontrol) / all_controls
prob_hialc_control
prob_cancer_hialc/prob_hialc_control

hitob_control = esoph %>%
  filter(tobgp == "30+")
prob_hitob_control = sum(hitob_control$ncontrol) / all_controls
prob_hitob_control

prob_control_highs = sum(highest_alctob$ncontrols) / all_controls
prob_control_highs

highest_alc_or_tob_controls = prob_hialc_control + prob_hitob_control - prob_control_highs
highest_alc_or_tob_cases / highest_alc_or_tob_controls
