#' ---
#' title: "Assessment: Logistic Regression"
#' author: "Marc Haddad"
#' ---

library(tidyverse)
library(caret)
library(dslabs)

# Setup:
set.seed(2, sample.kind="Rounding") #if you are using R 3.6 or later
make_data <- function(n = 1000, p = 0.5, 
                      mu_0 = 0, mu_1 = 2, 
                      sigma_0 = 1,  sigma_1 = 1){
  
  y <- rbinom(n, 1, p)
  f_0 <- rnorm(n, mu_0, sigma_0)
  f_1 <- rnorm(n, mu_1, sigma_1)
  x <- ifelse(y == 1, f_1, f_0)
  
  test_index <- createDataPartition(y, times = 1, p = 0.5, list = FALSE)
  
  list(train = data.frame(x = x, y = as.factor(y)) %>% slice(-test_index),
       test = data.frame(x = x, y = as.factor(y)) %>% slice(test_index))
}
dat <- make_data()
  
# Problem:
  # Create 25 datasets for varying values of mu_1 in our make_data() function.
  # Calculate logistic regression for each data set and plot the resulting accuracies vs. mu_1.

# Solution:
set.seed(1, sample.kind = "Rounding")
mu_1 = seq(0, 3, len=25)

accuracies = sapply(mu_1, function(z) {
  data = make_data(mu_1 = z)
  fit = data$train %>% glm(y ~ x, data = ., family = "binomial")
  p_hat = predict(fit, newdata = data$test, type = "response")
  y_hat = ifelse(p_hat > 0.5, 1, 0)
  mean(y_hat == data$test$y)
})

data.frame(delta = mu_1, res = accuracies) %>% 
  ggplot(aes(delta, res)) +
  geom_point()



