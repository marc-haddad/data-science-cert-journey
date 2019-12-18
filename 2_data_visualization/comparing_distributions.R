gapminder = gapminder %>%
  mutate(dollars_per_day = gdp/population/365)

west = c("Western Europe", "Northern Europe", "Southern Europe",
         "Northern America", "Australia and New Zealand")

country_list1 = filter(gapminder, year == 1970 & !is.na(dollars_per_day)) %>%
  .$country
country_list2 = filter(gapminder, year == 2010 & !is.na(dollars_per_day)) %>%
  .$country
country_list = intersect(country_list1, country_list2)

 graph1 = gapminder %>%
  filter(year %in%c(1970, 2010) & country %in% country_list) %>%
  mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
  ggplot(aes(dollars_per_day)) +
  geom_histogram(binwidth = 1, aes(fill = group), color = "black") +
  scale_x_continuous(trans = "log2") +
  facet_grid(year~group)
 
 graph2 = gapminder %>%
   filter(year %in% c(1970, 2010) & country %in% country_list) %>%
   mutate(group = ifelse(region %in% west, "West", "Developing")) %>%
   mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
   ggplot(aes(region, dollars_per_day, fill = continent)) +
   geom_boxplot() +
   facet_grid(year~.) +
   scale_y_continuous(trans = "log2") +
   theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
   xlab("")
 
 
 
 
 
 
 
 graph3 = gapminder %>%
   filter(year %in% c(1970, 2010) & country %in% country_list) %>%
   mutate(region = reorder(region, dollars_per_day, FUN = median)) %>%
   ggplot() +
   geom_boxplot(aes(region, dollars_per_day, fill = factor(year))) +
   scale_y_continuous(trans = "log2") +
   theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
   xlab('')
 graph3
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 