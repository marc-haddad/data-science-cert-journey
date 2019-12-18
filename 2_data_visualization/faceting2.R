ds_theme_set()
filter(gapminder, year %in% c(1962, 1970, 1980, 1990, 2010, 2015)) %>%
  ggplot(aes(fertility, life_expectancy, color = continent)) +
  geom_point() +
  facet_wrap(.~year)