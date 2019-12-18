
years = c(1962, 1980, 1990, 2000, 2012)
continents = c("Asia", "Europe")

gapminder %>%
  filter(year %in% years, continent %in% continents) %>% 
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point() +
  facet_wrap(~year)