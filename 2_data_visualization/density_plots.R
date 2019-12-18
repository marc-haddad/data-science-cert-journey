data(gapminder)
gapminder = gapminder %>%
  mutate(dollars_per_day = gdp/population/365)

country_list1 = filter(gapminder, year == 1970 & !is.na(dollars_per_day)) %>%
  .$country

country_list2 = filter(gapminder, year == 2010 & !is.na(dollars_per_day)) %>%
  .$country

country_list = intersect(country_list1, country_list2)

p = filter(gapminder, year %in% c(1970, 2010) & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(x = dollars_per_day, y = ..count.., fill = group)) +
  geom_density(alpha = 0.2, bw = 0.75) +
  scale_x_continuous(trans = "log2") +
  facet_grid(year~.)


gapminder = gapminder %>%
  mutate(group = case_when(
    .$region %in% west ~ "West",
    .$region %in% c("Eastern Asia", "South-Eastern Asia") ~ "East Asia",
    .$region %in% c("Carribbean", "Central America", "South America") ~ "Latin America",
    .$continent == "Africa" & .$region != "Northern Africa" ~ "Sub-Saharan Africa",
    TRUE ~ "Others")) %>%
  mutate(group = factor(group, levels = c("Others", "Latin America",
                                          "East Asia", "Sub-Saharan Africa",
                                          "West")))
p1 = gapminder %>%
  filter(year %in% c(1970, 2010) & country %in% country_list) %>%
  ggplot(aes(x = dollars_per_day, y = ..count.., fill = group, color = group)) +
  geom_density(alpha = 0.2, bw = 0.75, position = "stack") +
  scale_x_continuous(trans = "log2") +
  facet_grid(year~.)

p2 = gapminder %>%
  filter(year %in% c(1970, 2010) & country %in% country_list) %>%
  group_by(year) %>%
  mutate(weight = population/sum(population) * 2) %>%
  ungroup() %>%
  ggplot(aes(dollars_per_day, fill = group, color = group, weight = weight)) +
  scale_x_continuous(trans = "log2") +
  geom_density(alpha = 0.2, bw = 0.75, position = "stack") +
  facet_grid(year~.) 
p2
