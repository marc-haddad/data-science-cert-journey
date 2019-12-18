library(tidyverse)
library(dslabs)
data(stars)
options(digits = 3) 

p1 = stars %>%
  ggplot(aes(magnitude)) +
  geom_density(fill = "grey")

p2 = stars %>%
  ggplot(aes(temp, y = ..count..)) +
  geom_density(fill = "grey") +
  scale_x_continuous(trans = "log2")

p3 = stars %>%
  ggplot(aes(x = temp, y = magnitude, label = star)) +
  geom_point(alpha = 0) +
  scale_y_reverse() +
  scale_x_continuous(trans = "log10") +
  geom_text(size = 2)

p4 = stars %>%
  ggplot(aes(x = temp, y = magnitude, color = type)) +
  geom_point() +
  scale_y_reverse() +
  scale_x_continuous(trans = "log10")
p4
