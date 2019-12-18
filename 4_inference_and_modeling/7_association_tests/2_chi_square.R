# Previously established dependencies
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


# Chi-Squared Test

funding_rate = totals %>%
  summarize(percent_total = 
              (yes_men + yes_women)/
              (yes_men + no_men + yes_women + no_women)) %>%
  .$percent_total
funding_rate # 0.165


two_by_two = tibble(awarded = c("no", "yes"),
                    men = c(totals$no_men, totals$yes_men),
                    women = c(totals$no_women, totals$yes_women))
two_by_two

# To find out whether the above discrepencies in funding are due to chance
# we use chi-square to compare the observed two-by-two with the theoretical one.

# Theoretical tibble:
tibble(awarded = c("no", "yes"),
       men = (totals$no_men + totals$yes_men) *
         c(1 - funding_rate, funding_rate),
       women = (totals$no_women + totals$yes_women) *
         c(1 - funding_rate, funding_rate))
# Chi-square
two_by_two %>%
  select(-awarded) %>%
  chisq.test()

# Summary stats for 2X2 is known as "Odds Ratio"

# Odds of getting funded if male:
odds_men = (two_by_two$men[2] / sum(two_by_two$men)) / # (success_men/total_app_men) /
  (two_by_two$men[1] / sum(two_by_two$men))            # (failure_men/total_app_men)


odds_women = (two_by_two$women[2] / sum(two_by_two$women)) / # (success_women/total_app_women) /
  (two_by_two$women[1] / sum(two_by_two$women))              # (failure_women/total_app_women)

# Odds Ratio is the ratio of the two odds above
odds_men/odds_women # 1.23









