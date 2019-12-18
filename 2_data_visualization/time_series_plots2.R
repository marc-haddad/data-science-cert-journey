countries = c("Germany", "South Korea")
labels = data.frame(country = countries, x = c(1970, 1984), y = c(1.5, 3))
filter(gapminder, country %in% countries) %>%
  ggplot(aes(year, fertility, color = country)) +
  geom_line() +
  geom_text(data = labels, aes(x, y, label = country), size = 5) +
  theme(legend.position = "none")
