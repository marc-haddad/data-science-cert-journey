library(dslabs)
data("research_funding_rates")

totals = research_funding_rates %>%
  select(-discipline) %>%
  summarize_all(funs(sum)) %>%
  summarize(yes_men = awards_men,
            no_men = applications_men - awards_men,
            yes_women = awards_women,
            no_women = applications_women - awards_women)
totals %>% summarize(percent_men = yes_men/(yes_men + no_men),
                     percent_women = yes_women/(yes_women + no_women))


# Hypothesis Testing

# Lady Tasting Tea example:
# What are the chances of a
# person picking 3/4 correct teas from a total of 8 teas BY ACCIDENT

# Probability of picking 3 correct teas out of 8 teas (4 correct + 4 incorrect) correctly
ncol(combn(4,3)) * ncol(combn(4,1))/ ncol(combn(8,4)) # 16/70

# Probability of picking 4 teas:
ncol(combn(4,4)) * ncol(combn(4,0))/ncol(combn(8,4)) # 1/70

# Prob of picking 3 or more is thus 16/70 + 1/70 = 17/70
# 17/70 is the p-value

# Data from above example summarized by a "two-by-two table":
tab = matrix(c(3, 1, 1, 3), 2, 2)
rownames(tab) = c("Poured Before", "Poured After")
colnames(tab) = c("Guessed Before", "Guessed After")
tab

fisher.test(tab, alternative = "greater")





