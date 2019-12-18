set.seed(16, sample.kind = "Rounding")

mean = 20.9
sd = 5.7
act_scores = rnorm(10000, mean, sd)
sd(act_scores)
perfs = act_scores >= 36
sum(perfs)
1 - pnorm(30, mean(act_scores), sd(act_scores))
pnorm(10, mean(act_scores), sd(act_scores))


x = 1:36
meanx = 20.9
sdx = 5.7
f_x = dnorm(x, meanx, sdx)
plot(x, f_x)

z = function(x){
  (x - mean(act_scores)) / sd(act_scores)
}
z_scores = sapply(act_scores, z)


1 - pnorm(2, mean(z_scores), sd(z_scores))
x_func = function(z){
  z * sd(act_scores) + mean(act_scores)
}
x_func(2)

qnorm(.95, mean(act_scores), sd(act_scores))


p <- seq(0.01, 0.99, 0.01)
sample_quantiles = qnorm(p, mean(act_scores), sd(act_scores))

theoretical_quantiles = qnorm(p, 20.9, 5.7)
qqplot(theoretical_quantiles, sample_quantiles)


