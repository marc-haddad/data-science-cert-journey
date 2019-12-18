
countries = c("South Korea", "Lebanon")
labels = data.frame(country = countries, x = c(1972, 1966), y = c(6.2, 3))

gapminder %>%
  filter(country %in% countries) %>%
  ggplot(aes(year, fertility, color = country)) +
  geom_line() +
  geom_text(data = labels, aes(x, y, label = country), size = 6) +
  theme(legend.position = "none")