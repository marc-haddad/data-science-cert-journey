set.seed(1989, sample.kind="Rounding") #if you are using R 3.6 or later
library(HistData)
data("GaltonFamilies")

female_heights <- GaltonFamilies%>%    
  filter(gender == "female") %>%    
  group_by(family) %>%    
  sample_n(1) %>%    
  ungroup() %>%    
  select(mother, childHeight) %>%    
  rename(daughter = childHeight) 

mu_x = mean(female_heights$mother)
sd_x = sd(female_heights$mother)

mu_y = mean(female_heights$daughter)
sd_y = sd(female_heights$daughter)

r = cor(female_heights$mother, female_heights$daughter)

m = r * sd_y / sd_x

b = mu_y - m * mu_x
b

# Percent of var in daughter height explained by mom height
var = r^2 * 100


# conditional expected val:
y = m * 60 + b
y



