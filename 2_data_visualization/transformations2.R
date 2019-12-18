gapminder = gapminder %>%
  mutate(dollars_per_day = gdp/population/365)

filter(gapminder, year %in%c(1970, 2010) & !is.na(gdp)) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, color = "black") +
  facet_grid(.~year) +
  scale_x_continuous(trans = "log2")