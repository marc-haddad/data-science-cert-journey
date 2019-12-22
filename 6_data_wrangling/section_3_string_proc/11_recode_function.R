
library(dslabs)
library(tidyverse)

data("gapminder")

# Plot Example
gapminder %>%
  filter(region=="Caribbean") %>%
  ggplot(aes(year, life_expectancy, color = country)) +
  geom_line()
# The above plot shows an inefficient use of space to accomodate long country names

# Here are the longest ones:
gapminder %>%
  filter(region=="Caribbean") %>%
  filter(str_length(country) >= 12) %>%
  distinct(country)
# Antigua and Barbuda
# Dominican Republic
# St. Vincent and the Grenadines
# Trinidad and Tobago

# b/c the above names appear multiple times in the dataset
# we need to pick nicknames and apply them to all instances of these countries

# recode()
gapminder %>% filter(region=="Caribbean") %>%
  mutate(country = recode(country,
                          "Antigua and Barbuda" = "Barbuda",
                          "Dominican Republic" = "DR",
                          "St. Vincent and the Grenadines" = "St. Vincent",
                          "Trinidad and Tobago" = "Trinidad")) %>%
  ggplot(aes(year, life_expectancy, color = country)) +
  geom_line()

