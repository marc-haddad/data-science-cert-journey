
# We use data from only one pollster to ensure changes in predictions are due to time and not pollster to pollster variability
one_pollster = polls_us_election_2016 %>%
  filter(pollster == "Ipsos" & state == "U.S.") %>%
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100)

se = one_pollster %>%
  summarize(empirical = sd(spread),
            theoretical = 2*sqrt(mean(spread) * (1-mean(spread))/min(samplesize)))
se # Here we see that the theoretical error is significantly lower than the empirical one

# This graph shows that, due to the variability, the dist. is not Norm.
one_pollster %>% ggplot(aes(spread)) +
  geom_histogram(binwidth = 0.01, color = "black")

# Trend across time for several pollsters
polls_us_election_2016 %>%
  filter(state == "U.S." & enddate>="2016-07-01") %>%
  group_by(pollster) %>%
  filter(n()>=10) %>%
  ungroup() %>%
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100) %>%
  ggplot(aes(enddate, spread)) +
  geom_smooth(method = 'loess', span = 0.1) +
  geom_point(aes(color=pollster), show.legend = FALSE, alpha=0.6)


# As we can see in the above graph, time affects polling,
# so we need to include time effect in or forecasting model.
# Forecast Model: Y_i_j_t = d + b + h_j + b_t + epsilon_i_j_t
# sd(bt) will change according to time b/c the closer we are to election the lower the variability

# Trends are also accounted for and included in the forcast model
# as f(t) (a func. of time)
# f(t) can be seen in the graph above as the blue line.
# Forecast Model w/ Trends:
#   Y_i_j_t = d + b + h_j + b_t + f(t) + epsilon_i_j_t

polls_us_election_2016 %>%
  filter(state == "U.S." & enddate>="2016-07-01") %>%
  select(enddate, pollster, rawpoll_clinton, rawpoll_trump) %>%
  rename(Clinton = rawpoll_clinton, Trump = rawpoll_trump) %>%
  gather(candidate, percentage, -enddate, -pollster) %>%
  mutate(candidate = factor(candidate, levels = c("Trump", "Clinton"))) %>%
  group_by(pollster) %>%
  filter(n()>=10) %>%
  ungroup() %>%
  ggplot(aes(enddate, percentage, color = candidate)) +
  geom_point(show.legend = FALSE, alpha=0.4) +
  geom_smooth(method = "loess", span = 0.15) +
  scale_y_continuous(limits = c(30,50))




