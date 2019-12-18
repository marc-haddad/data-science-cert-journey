
r = murders %>%
  summarise(rate = sum(total) / sum(population) * 10^6) %>%
  .$rate

p = murders %>% ggplot(aes(population / 10^6, total, label = abb)) +
  scale_x_log10() +
  scale_y_log10() +
  geom_text_repel() +
  ggtitle("US State Murders per Population") +
  xlab("Population per million (log10)") +
  ylab("Murders(log10)") +
  geom_point(aes(col=region), size = 3) +
  geom_abline(intercept = log10(r), lty = 2, color = "darkgrey") +
  scale_color_discrete(name = "Region") + theme_economist()

p