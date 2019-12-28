library(dslabs)
data("research_funding_rates")
research_funding_rates

# Create 2X2 table of awarded(yes/no) vs gender(m/w)
tbl = research_funding_rates %>% summarize(m_awards = sum(awards_men), w_awards = sum(awards_women), m_rejects = sum(applications_men) - m_awards, w_rejects = sum(applications_women) - w_awards, perc_m_awards = m_awards / (m_awards + m_rejects), perc_w_awards = w_awards / (w_awards + w_rejects))
tbl
two_two = data.frame(awarded = c("yes", "no"),
           men = c(tbl$m_awards, tbl$m_rejects),
           women = c(tbl$w_awards, tbl$w_rejects))

# Obtain p-val from chi-sq test
two_two %>% select(-awarded) %>% chisq.test() %>% .$p.value
# 0.0509


dat <- research_funding_rates %>% 
  mutate(discipline = reorder(discipline, success_rates_total)) %>%
  rename(success_total = success_rates_total,
         success_men = success_rates_men,
         success_women = success_rates_women) %>%
  gather(key, value, -discipline) %>%
  separate(key, c("type", "gender")) %>%
  spread(type, value) %>%
  filter(gender != "total")
dat

# Plot success rates vs disciplines, w/ colors to denote genders & size to denote num of applicants.
dat %>% group_by(discipline) %>% ggplot(aes(discipline, success, color = gender, size = applications)) +
  geom_point()

