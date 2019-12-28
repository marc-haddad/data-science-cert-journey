library(tidyverse)
library(broom)
library(HistData)
data("GaltonFamilies")
set.seed(1, sample.kind = "Rounding")


# Sometimes people incorrectly attribute a result as a cause and vice versa.
# Example: 
  # Claim: Tutoring children causes lower grades.
  # Reality: Children who struggle in school tend to get tutors

# We can construct an example of cause and effect reversal using father-son height from the Galton dataset
GaltonFamilies %>% 
  filter(childNum == 1 & gender == "male") %>% 
  select(father, childHeight) %>% 
  rename(son = childHeight) %>% 
  do(tidy(lm(father ~ son, data = .)))
# This model produces a statistically significant result indicating that sons' heights cause fathers' heights
# A tibble: 2 x 5
# term        estimate  std.error statistic  p.value
# <chr>          <dbl>     <dbl>     <dbl>    <dbl>
# (Intercept)   34.0      4.57        7.44 4.31e-12
# son            0.499    0.0648      7.70 9.47e-13

# This is important b/c: The model is correct, estimates and p-val were obtained correctly;
# It is instead the INTERPRETATION that is incorrect given what we know about genetics and the flow of time.