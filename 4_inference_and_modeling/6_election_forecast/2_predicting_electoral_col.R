
results = polls_us_election_2016 %>%
  filter(state!="U.S." &
           !grepl("CD", state) &
           enddate >= "2016-10-31" &
           (grade %in% c("A+", "A", "A-", "B+") | is.na(grade))) %>%
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100) %>%
  group_by(state) %>%
  summarize(avg = mean(spread), sd = sd(spread), n = n()) %>%
  mutate(state = as.character(state))

# Closest races:
results %>% arrange(abs(avg))

# Use left_join() to add electoral college
results = left_join(results, results_us_election_2016, by = "state")
results

# Since we can't find the sd of states that only had 1 poll, we assume they have the median sd of all polls
results = results %>%
  mutate(sd = ifelse(is.na(sd), median(results$sd, na.rm=TRUE), sd))


# Now we use monte carlo sims to sim elections in order to make probability statements
# Use Bayesian calc to generate d for each state

mu = 0 # Here we are assuming we have no idea about previous elections, saying it could go either way
tau = 0.02 # Here we are assuming that states do not significantly change from election year to election year
results %>% mutate(sigma = sd/sqrt(n), 
                   B = sigma^2/(sd^2 + tau^2),
                   posterior_mean = B*mu + (1-B)*avg,
                   posterior_se = sqrt(1/(1/sigma^2 + 1/tau^2))) %>%
  arrange(abs(posterior_mean))

# Now we simulate 10,000 election night results
clinton_EV = replicate(10000, {
  results %>% mutate(sigma = sd/sqrt(n),
                     B = sigma^2/(sigma^2 + tau^2),
                     posterior_mean = B*mu + (1-B)*avg,
                     posterior_se = sqrt(1/(1/sigma^2 + 1/tau^2)),
                     simulated_result = rnorm(length(posterior_mean), posterior_mean, posterior_se),
                     clinton = ifelse(simulated_result > 0, electoral_votes, 0)) %>%
    summarize(clinton = sum(clinton)) %>%
    .$clinton + 7 # The 7 is for Rhode Island and D.C
})
mean(clinton_EV>269) # 99.8% chance clinton wins electoral college
hist(clinton_EV)

# The reason the above perc is high is b/c we did not account for general bias

tau = 0.02
bias_sd = 0.03 # Here we assume a higher effect of state to state bias

clinton_EV_2 = replicate(10000, {         # We account for bias here
  results %>% mutate(sigma = sqrt(sd^2/n + bias_sd^2),
                     B = sigma^2/(sigma^2+tau^2),
                     posterior_mean = B*mu + (1-B)*avg,
                     posterior_se = sqrt(1/(1/sigma^2 + 1/tau^2)),
                     simulated_result = rnorm(length(posterior_mean), posterior_mean, posterior_se),
                     clinton = ifelse(simulated_result>0, electoral_votes, 0)) %>%
    summarize(clinton = sum(clinton) + 7) %>% .$clinton
})

mean(clinton_EV_2>269) # 82%, much lower percent chance of clinton win if general bias acounted for
hist(clinton_EV_2)









