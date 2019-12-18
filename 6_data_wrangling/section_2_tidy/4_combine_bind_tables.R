library(dslabs)
library(tidyverse)
library(ggrepel)

data("murders")
head(murders)
data("polls_us_election_2016")
head(results_us_election_2016)

tab = left_join(murders, results_us_election_2016, by =  "state")
head(tab)

tab %>% ggplot(aes(population/10^6, electoral_votes, label = abb)) +
  geom_point() +
  geom_text_repel() +
  scale_x_continuous(trans = 'log2') +
  scale_y_continuous(trans = "log2") +
  geom_smooth(method = "lm", se = FALSE)

tab1 = slice(murders, 1:6) %>% select(state, population)
tab1

tab2 = slice(results_us_election_2016, c(1:3, 5, 7:8)) %>%
  select(state, electoral_votes)
tab2


# left_join()
left_join(tab1, tab2)
tab1 %>% left_join(tab2) # Alt.

# Binding
# Combines cols into a tibble
bind_cols(a = 1:3, b = 4:6) # Must be equal in length, otherwise error

# cbind() creates obj other than tibbles

# bind_cols() also combines DFs
tab1 = tab[, 1:3]
tab2 = tab[, 4:6]
tab3 = tab[, 7:9]

new_tab = bind_cols(tab1, tab2, tab3)
head(new_tab)

# bind_rows() combines rows
tab1 = tab[1:2,]
tab2 = tab[3:4,]
bind_rows(tab1, tab2)

# intersect() takes intersection of vectors, DFs
tab1 = tab[1:5,]
tab2 = tab[3:7,]
intersect(tab1, tab2) # Returns rows 3:5

# union() takes the union of unique vals in vectors, DFs
union(1:10, 6:15)
union(tab1, tab2) # Returns rows 1:7


# setdiff() returns the diffs b/w vectors, DFs. NOT SYMETRIC
setdiff(1:10, 6:15) # [1, 2, 3, 4, 5]
setdiff(6:15, 1:10) # [11, 12, 13, 14, 15]

setdiff(tab1, tab2)


# setequal() tells us if sets are equal REGARDLESS OF ORDER
setequal(1:5, 5:1) # TRUE 

# Much more useful for tables
setequal(tab1, tab2)


