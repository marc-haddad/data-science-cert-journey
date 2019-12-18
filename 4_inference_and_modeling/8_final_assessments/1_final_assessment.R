# Final Assessment

library(dslabs)
library(tidyverse)
options(digits = 3)

data("brexit_polls")

# Actual % voted "remain"
p = 0.481
# Actual spread of Brexit
d = 2*p - 1 # -0.038


N = 1500

# Expected number of "Remain" voters
R = p*N

# SE of total number of remain voters
sqrt(N*p*(1-p))

# Expected value X_bar, the proportion of "Remain"
p

# Standard Error of X_bar
sqrt(p * (1-p)/N)

# Expected value of d
p - (1-p)

# Standard Error of d
2 * sqrt(p * (1-p)/N)


# x_hat = (observed spread + 1)/2
head(brexit_polls)
brexit_polls = brexit_polls %>%
  mutate(x_hat = (spread+1)/2)

x_hat_avg = mean(brexit_polls$x_hat)
se = sd(brexit_polls$x_hat)

# SE of one poll:
brexit_polls[1,]
# The above gives us: x_hat = 0.52, (n = samplesize) = 4772
se1 = sqrt(0.52*(1-0.52)/4772)
se1

error = qnorm(0.975) * se1
lower = 0.52 - error
upper = 0.52 + error


# Q4
june_polls = brexit_polls %>%
  filter(enddate >= "2016-06-01")


june_polls = june_polls %>%
  mutate(se_x_hat = 2 * sqrt(x_hat * (1-x_hat)/samplesize)) %>%
  mutate(error = se_x_hat * qnorm(0.975)) %>%
  mutate(lower = spread - error, upper = spread + error) %>%
  mutate(hit = ifelse(lower <= d & upper >= d, TRUE, FALSE))
nrow(june_polls)
june_polls

sum(sign(june_polls$lower) == sign(june_polls$upper))
(nrow(june_polls) - 12)/nrow(june_polls)

mean(ifelse(june_polls$lower > 0, TRUE, FALSE))
24/32

mean(june_polls$hit)

june_polls %>% group_by(pollster) %>%
  summarize(n = n(), avg = mean(hit)) %>%
  arrange(desc(avg))



june_polls %>% group_by(poll_type) %>% ggplot(aes(poll_type, spread)) +
  geom_boxplot()


combined_by_type <- june_polls %>%
  group_by(poll_type) %>%
  summarize(N = sum(samplesize),
            spread = sum(spread*samplesize)/N,
            p_hat = (spread + 1)/2,
            error = 2 * sqrt(p_hat * (1-p_hat)/N),
            lower = spread - qnorm(0.975)*error,
            upper = spread + qnorm(0.975)*error,
            difference = upper - lower)
combined_by_type


brexit_hit <- brexit_polls %>%
  mutate(p_hat = (spread + 1)/2,
         se_spread = 2*sqrt(p_hat*(1-p_hat)/samplesize),
         spread_lower = spread - qnorm(.975)*se_spread,
         spread_upper = spread + qnorm(.975)*se_spread,
         hit = spread_lower < -0.038 & spread_upper > -0.038) %>%
  select(poll_type, hit)
nrow(brexit_hit)

two_two = brexit_hit %>% group_by(poll_type) %>% summarize(hits = sum(hit), misses = n() - sum(hit))
two_two
two_two %>% select(-poll_type) %>% chisq.test()

# Odds of getting funded if male:
odds_online = (two_two[[2]][1] / (two_two[[2]][1] + two_two[[3]][1])) / # (success_men/total_app_men) /
  (two_two[[3]][1] / (two_two[[2]][1] + two_two[[3]][1]))            # (failure_men/total_app_men)
odds_online

odds_tel = (two_two[[2]][2] / (two_two[[2]][2] + two_two[[3]][2])) / # (success_men/total_app_men) /
  (two_two[[3]][2] / (two_two[[2]][2] + two_two[[3]][2]))
odds_tel
# Odds Ratio is the ratio of the two odds above
odds_online/odds_tel # 1.23

tail(brexit_polls)

brexit_polls %>%
  ggplot(aes(enddate, spread, color = poll_type)) +
  geom_smooth(method = "loess", span = 0.4) +
  geom_point() +
  geom_hline(yintercept = -0.038)

brexit_long <- brexit_polls %>%
  gather(vote, proportion, "remain":"undecided") %>%
  mutate(vote = factor(vote))

brexit_long %>% ggplot(aes(enddate, proportion, color = vote)) +
  geom_smooth(method = "loess", span = 0.3)





