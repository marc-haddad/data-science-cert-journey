gapminder = gapminder %>%
  mutate(dollars_per_day = gdp/population/365)
p = filter(gapminder, year == 1970 & !is.na(gdp)) %>%
  mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
  ggplot(aes(region, dollars_per_day, fill = continent))

p + geom_boxplot() +
  theme_linedraw() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  xlab("") +
  ylab("Dollars per Day") +
  scale_y_continuous(trans = "log2") +
  geom_point(show.legend = FALSE, size = 0.5)