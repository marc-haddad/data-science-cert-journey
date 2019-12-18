
# Monte Carlo sim to see if our estimates are correct
B = 10000
N = 1000
p = 0.45
X_hat = replicate(B, {
  X = sample(c(1,0), N, replace = TRUE, prob = c(p, 1-p))
  mean(X)
})
X_bar = mean(X_hat)
se = sd(X_hat) # IMPORTANT NOTE: This sd gives us the theoretical se
          # we calculated in previous doc

library(gridExtra)
p1 = data.frame(X_hat=X_hat) %>% ggplot(aes(X_hat)) +
  geom_histogram(binwidth = 0.005, color = "black")
p2 = data.frame(X_hat=X_hat) %>% ggplot(aes(sample=X_hat)) +
  stat_qq(dparams = list(mean=mean(X_hat), sd=sd(X_hat))) +
  geom_abline() +
  ylab("X_hat") +
  xlab("Theoretical normal")
grid.arrange(p1, p2, nrow=1)

# "spread" is calc as p - (1 - p) = 2*p - 1
# Therefore, our spread is 2*X_hat - 1 according to theoretical models
# Standard error becomes 2*se since we are doubling p
spread = 2 * X_bar - 1
spread 

SE = 2 * se
SE
