
# Monte Carlo simulation to find experimental prob
compute_prob = function(n, B=10000) {
  same_bday = replicate(B, {
    bdays = sample(1:365, n, replace = TRUE)
    any(duplicated(bdays))
  })
  mean(same_bday)
}

n = 1:60
prob = sapply(n, compute_prob)
prob

prob_df = data.frame(prob)
prob_df

p = prob_df %>%
  ggplot(aes(n, prob)) +
  geom_point()

p

# Computes exact prob
exact_prob = function(n) {
  prob_unique = seq(365, 365 - n + 1)/365 # Prob of unique bday given 'n' people
  1 - prod(prob_unique)
}
# Need to use 'sapply()' to apply func to entire vector
eprob = sapply(n, exact_prob)

plot(n, prob)
lines(n, eprob, col = "red")

