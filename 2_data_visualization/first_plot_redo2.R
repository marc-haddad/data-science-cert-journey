
r = murders %>%
  summarize(rate = sum(total) / sum(population) * 10 ^ 6) %>%
  .$rate

p = murders %>% 
  ggplot(aes(population / 10 ^ 6, total, label = abb)) +
  geom_text_repel() +
  theme_economist() +
  scale_x_log10() + 
  scale_y_log10() +
  #scale_color_discrete(name = "Region") +
  ggtitle("US State Murders per Population") +
  xlab("Population in millions (log10)") +
  ylab("Total murders") +
  geom_abline(intercept = log10(r), lty = 2, color = "darkgray") +
  geom_point(aes(col = region), size = 3) 

  
p
  