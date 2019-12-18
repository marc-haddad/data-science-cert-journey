library(dslabs)
names(polls_us_election_2016)


polls = polls_us_election_2016 %>%
  filter(state == "U.S." & enddate >= "2016-10-31" &
           (grade %in% c("A+", "A", "A-", "B+") | is.na(grade)))

polls = polls %>% 
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100)

head(polls)

d_hat = polls %>%
  summarize(d_hat = sum(spread * samplesize)/sum(samplesize)) %>%
  .$d_hat

p_hat = (d_hat + 1)/2 # Standard error
moe = 1.96 * 2 * sqrt(p_hat * (1-p_hat)/sum(polls$samplesize))
moe

d_hat # Estimated spread: 1.43%
moe # Margin of error: 0.66%

# Note: Actual spread on election night was 2.1%, which is
# actually outside of our 95% confidence interval

polls %>%
  ggplot(aes(spread)) +
  geom_histogram(color = "black", binwidth = 0.01)

# As the above graph shows, the results are clearly not normal,
# and the moe is much higher than 0.066

polls %>% group_by(pollster) %>%
  filter(n() >= 6) %>%
  ggplot(aes(pollster, spread)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# The graph above illustrates the effect of pollster bias.
# The theoretical model says that the spread should for each pollster
# should be the same whereas in the above we see what are called
# "house effects" i.e pollster bias.




