library(HistData)
library(tidyverse)
data("GaltonFamilies")
set.seed(1983)
galton_heights <- GaltonFamilies %>%
  filter(gender == "male") %>%
  group_by(family) %>%
  sample_n(1) %>%
  ungroup() %>%
  select(father, childHeight) %>%
  rename(son = childHeight)
options(digits = 3)


# Least squares equation quantifies the values that minimize the distance of the fitted model to the data.

# Residual sum of squares (RSS)
# The value that minimizes the RSS is called the Least Squares Estimate (LSE)

# Compute RSS for any pair of beta0 and beta1 in Galton's data
rss = function(beta0, beta1, data){
  resid = galton_heights$son - (beta0 + beta1 * galton_heights$father)
  return(sum(resid^2))
}

# Since we have an RSS value for any pair of vals beta0 and beta1, we can make a 3d plot, w/ RSS as the Z axis, to find the minimum val
# To represent it in 2d we will keep beta0 fixed to 25, that way we are only analyzing the changes of beta1 and RSS
beta1 = seq(0, 1, len = nrow(galton_heights))
results = data.frame(beta1 = beta1,
                     rss = sapply(beta1, rss, beta0 = 25))
results %>% ggplot(aes(beta1, rss)) +
  geom_line() +
  geom_line(aes(beta1, rss), col=2)
# The min is around 0.65. 
# It is important to remember that this minimum was caculated while beta0 was fixed;
# In order to find the true min, we need some calculus. This can be done w/ funcs in R.

# lm() finds the LSE
fit = lm(son ~ father, data = galton_heights)
fit
# The ~ symbol allows us to define the val we are predicting (left side) according to the variable given (right side)
# summary() lets us extract more details
summary(fit)


# The LSE are derived from the data Y1,..., Yn, which are random
# This means our estimates are random vars

# Run a monte carlo sim that assumes the data given on sons and fathers reps the entire population.
# Take rand samples of size 50 and compute the regression slope coesfficient for each one

B = 1000
N = 50
lse = replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>% 
    lm(son ~ father, data = .) %>% .$coef # coef extracts model coefficient
})
lse = data.frame(beta_0 = lse[1,], beta_1 = lse[2,])
lse

# See the variability of the above estimates
library(gridExtra)
p1 = lse %>% ggplot(aes(beta_0)) + geom_histogram(binwidth = 5, color = "black")
p2 = lse %>% ggplot(aes(beta_1)) + geom_histogram(binwidth = 0.1, color = "black")
grid.arrange(p1, p2, ncol = 2)
# As can be seen in the above plots, the CLT applies.
# For a large enough N, the LSEs will be approx. normal w/ expected vals beta_0 & beta_1

# lm() also calcs the estimated std error
sample_n(galton_heights, N, replace = TRUE) %>% 
  lm(son ~ father, data = .) %>% summary

# Call:
# lm(formula = son ~ father, data = .)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -4.7286 -1.7574 -0.0287  1.5340  4.9437 
# 
# Coefficients:
#                Estimate   Std. Error t value   Pr(>|t|)    
#   (Intercept)  36.6818     9.4505    3.881     0.000316 ***
#   father        0.4713     0.1366    3.450     0.001179 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 2.233 on 48 degrees of freedom
# Multiple R-squared:  0.1987,	Adjusted R-squared:  0.182 
# F-statistic:  11.9 on 1 and 48 DF,  p-value: 0.001179

lse %>% summarize(se_0 = sd(beta_0), se_1 = sd(beta_1))
# se_0  se_1
# 9.76  0.142

# Summary above also reports t stat (t value) and p val (Pr(>|t|))


# LSE can be strongly correlated
lse %>% summarize(cor(beta_0, beta_1))
# cor(beta_0, beta_1)
#        -0.999

# Corr depends on how the predictors are defined or transformed

# Here we will standardize father heights, which changes from x_i to x_i - mu_x
B = 1000
N = 50
lse = replicate(B, {
  sample_n(galton_heights, N, replace = TRUE) %>% 
    mutate(father = father - mean(father)) %>% 
    lm(son ~ father, data = .) %>% .$coef
})
cor(lse[1,], lse[2,])
# 0.112
# As you can see above, the corr has significantly decreased when standardizing father's height



# Plugging in different vals of father's height into our constructed formula, we can predict the son's height given the father's height and obtain conf intervs.
# ggplot library (specifically geom_smooth()) does this for us when we define method as "lm"
galton_heights %>% ggplot(aes(son, father)) +
  geom_point() +
  geom_smooth(method = "lm")

# predict() takes in an lm object and returns the predictions derived from it
galton_heights %>% 
  mutate(Y_hat = predict(lm(son ~ father, data = .))) %>% 
  ggplot(aes(father, Y_hat)) +
  geom_line()

# We can also calc the std errors w/ predict()
fit = galton_heights %>% lm(son ~ father, data = .)
Y_hat = predict(fit, se.fit = TRUE)
names(Y_hat)
# "fit"            "se.fit"         "df"             "residual.scale"


