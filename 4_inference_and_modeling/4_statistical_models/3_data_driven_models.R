
# Extract poll results on the last day by each pollster
one_poll_per_pollster = polls %>% group_by(pollster) %>%
  filter(enddate == max(enddate)) %>%
  ungroup()

one_poll_per_pollster %>% 
  ggplot(aes(spread)) + geom_histogram(color = "black", binwidth = 0.01)

# Hypothetical "urn" containing data no longer just 0's and 1's
# "Urn" now contains different pollsters varying from -1 to 1.
# The standard deviation of this new "urn" is no longer sqrt(p * 1 - p).
# Instead SE now includes pollster to pollster variability.
# We now have 2 unknown params: Expected Value 'd', and standard deviation 'sigma'


# "sigma" can be estimated with the Sample Standard Deviation:
# s = 1/(N-1) * sum(X_observed - X_bar)^2 or simply:
s = sd(one_poll_per_pollster$spread)
s

results = one_poll_per_pollster %>% 
  summarize(avg = mean(spread), se = sd(spread)/sqrt(length(spread))) %>%
  mutate(start = avg - 1.96*se, end = avg + 1.96*se)

round(results*100,1)

# The above is a data-driven approach that incorporates pollster variability
