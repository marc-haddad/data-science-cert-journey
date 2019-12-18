options(digits = 3)    # report 3 significant digits
library(tidyverse)
library(titanic)

titanic <- titanic_train %>%
  select(Survived, Pclass, Sex, Age, SibSp, Parch, Fare) %>%
  mutate(Survived = factor(Survived),
         Pclass = factor(Pclass),
         Sex = factor(Sex))

p1 = titanic %>%
  filter(!is.na(Age)) %>%
  ggplot(aes(round(Age), color = Sex, fill = Sex)) +
  geom_density(aes(y = ..count..), bw = 3, alpha = 0.2)

params = titanic %>%
  filter(!is.na(Age)) %>%
  summarize(mean = mean(Age), sd = sd(Age))

p2 = titanic %>%
  filter(!is.na(Age)) %>%
  ggplot(aes(sample = Age)) +
  geom_qq(dparams = params) +
  geom_abline()

p3 = titanic %>%
  ggplot(aes(Sex, fill = Survived)) +
  geom_bar(position = position_dodge())

p4 = titanic %>%
  filter(!is.na(Age)) %>%
  ggplot(aes(x = Age, y = ..count.., fill = Survived)) +
  geom_density(alpha = 0.2)

p5 = titanic %>%
  filter(!is.na(Fare) & Fare != 0) %>%
  ggplot(aes(Survived, Fare)) +
  geom_boxplot() +
  scale_y_continuous(trans = "log2") +
  geom_point(position = "jitter", alpha = 0.2)

p6 = titanic %>%
  ggplot(aes(Survived, fill = Pclass)) +
  geom_bar(position = position_fill())

p7 = titanic %>%
  filter(!is.na(Age)) %>%
  ggplot(aes(x = Age, y = ..count.., fill = Survived)) +
  geom_density(alpha = 0.2) +
  facet_grid(Pclass~Sex)
p7