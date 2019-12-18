d = 0.039
Ns = c(1298, 533, 1342, 897, 774, 254, 812, 324, 1291, 1056, 2172, 516)
p = (d + 1)/2

confidence_intervals = sapply(Ns, function(N){
  X = sample(c(0, 1), N, replace = TRUE, prob = c(1-p, p))
  X_hat = mean(X)
  SE_hat = sqrt(X_hat * (1-X_hat)/N)
  2*c(X_hat, X_hat - 2*SE_hat, X_hat + 2*SE_hat) - 1
})

polls = data.frame(poll=1:ncol(confidence_intervals),
                   t(confidence_intervals), # 't()' transposes matrix data into DF
                   sample_size=Ns)
names(polls) = c("poll", "estimate", "low", "high", "sample_size")
polls

# Plot showing the simulated 12 pollster results
polls %>% ggplot(aes(x = estimate, y = poll, xmin = low, xmax = high)) +
  geom_errorbarh(color="skyblue") +
  geom_point(color="skyblue") +
  geom_vline(aes(xintercept = d), linetype = "dashed") +
  geom_vline(aes(xintercept = 0))

# Estimate of the spread i.e 'd'
d_hat = polls %>%
  summarize(avg = sum(estimate*sample_size) / sum(sample_size)) %>%
  .$avg

p_hat = (1 + d_hat)/2
moe = 2*1.96*sqrt(p * (1-p)/sum(polls$sample_size))
moe

# Estimate of spread
round(d_hat*100, 1)
# Margin of error = +-
round(moe*100, 1)
head(polls)
# Note: Our d_hat +- moe range is much smaller than the other polls
  
  