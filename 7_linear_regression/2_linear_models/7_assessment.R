library(tidyverse)
library(HistData)
data("GaltonFamilies")
set.seed(1, sample.kind = "Rounding") # if you are using R 3.6 or later
galton <- GaltonFamilies %>%
  group_by(family, gender) %>%
  sample_n(1) %>%
  ungroup() %>% 
  gather(parent, parentHeight, father:mother) %>%
  mutate(child = ifelse(gender == "female", "daughter", "son")) %>%
  unite(pair, c("parent", "child"))

galton %>% group_by(pair) %>% count(pair)

# Find strongest & weakest coeff. b/w parent-child pairs
galton %>% filter(pair == "father_daughter") %>% 
  summarize(cor = cor(childHeight, parentHeight))
# Coeff = 0.401

galton %>% filter(pair == "father_son") %>% 
  summarize(cor = cor(childHeight, parentHeight))
# Coeff = 0.430

galton %>% filter(pair == "mother_daughter") %>% 
  summarize(cor = cor(childHeight, parentHeight))
# Coeff = 0.383

galton %>% filter(pair == "mother_son") %>% 
  summarize(cor = cor(childHeight, parentHeight))
# Coeff = 0.343




# Find lse, se, conf.int, p-vals for all pairs using lm
galton %>% filter(pair == "father_daughter") %>% 
  do(tidy(lm(childHeight ~ parentHeight, data = .)))
# Coeff = 0.345

galton %>% filter(pair == "father_son") %>% 
  do(tidy(lm(childHeight ~ parentHeight, data = .)))
# Coeff = 0.443

galton %>% filter(pair == "mother_daughter") %>% 
  do(tidy(lm(childHeight ~ parentHeight, data = .)))
# Coeff = 0.394

galton %>% filter(pair == "mother_son") %>% 
  do(tidy(lm(childHeight ~ parentHeight, data = .)))
# Coeff = 0.38



galton %>% 
  group_by(pair) %>% 
  do(tidy(lm(childHeight ~ parentHeight, data = .), conf.int = TRUE)) %>% 
  filter(term == "parentHeight") %>% 
  select(pair, estimate, conf.low, conf.high) %>% 
  ggplot(aes(pair, y = estimate, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point()





