library(caret)
library(dslabs)
library(tidyverse)

options(digits = 3)
data("heights")
set.seed(2, sample.kind = "Rounding")

# Predict sex (F or M) using height


# Define outcome and predictors
y = heights$sex # Categorical outcome
x = heights$height

# To mimic the real world application of the ML algorithm
# we split the data into 2 parts and act as if we don't know the outcome of 1 of them
  # Training Set: the known data with which we use to train our algorithm
  # Test Set: the (pretend) unknown data group with which we use to verify algorithm accuracy

# We randomly split the data to get our 2 groups
# createDataPartition(): func that gens indexes for randomly splitting datasets
test_index = createDataPartition(y, times = 1, p = 0.5, list = FALSE)

# Use index to define training and test sets
train_set = heights[-test_index,]
test_set = heights[test_index,]

# Now we will develop an algorithm w/ ONLY the training set.
# When we are done developing the algorithm we will freeze it and eval using test set

# Simple way to test algorithm: calc proportion of "correct" guesses for vals in test set
# AKA Overall Accuracy


# First ML algorithm: ignoring predictor and guessing the outcome
y_hat = sample(c("Male", "Female"),
               length(test_index), replace = TRUE)

# Use factors to rep categorical outcomes
y_hat = sample(c("Male", "Female"), 
               length(test_index), replace = TRUE) %>% 
  factor(levels = levels(test_set$sex))

# Predict proportion of correct guesses
mean(y_hat == test_set$sex) # 0.524


# We can do better. We know males are on avg taller than females.
heights %>% group_by(sex) %>% summarize(mean(height), sd(height))

# A tibble: 2 x 3
# sex    `mean(height)` `sd(height)`
# <fct>           <dbl>        <dbl>
# Female           64.9         3.76
# Male             69.3         3.61


# W/ this data we can predict "Male" if height is w/in 2 sd of male avg height
y_hat = ifelse(x > 62, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex))
mean(y_hat == test_set$sex) # 0.723, a much better %

# We can do even better by testing cutoffs other than "62" and take the val that provides the best result
# Reminder, pick the best val ON THE TRAINING SET not the test set (I'm not sure why the above ex uses the test set but w/e)
cutoff = seq(61, 70)
accuracy = map_dbl(cutoff, function(x){
  y_hat = ifelse(train_set$height > x, "Male", "Female") %>% 
    factor(levels = levels(test_set$sex))
  mean(y_hat == train_set$sex)
})
accuracy
# 0.787 0.800 0.815 0.836 0.829 0.804 0.743 0.691 0.594 0.510

# Here is a plot showing the varying cutoffs
data.frame(cutoff, accuracy) %>% ggplot(aes(cutoff, accuracy)) +
  geom_point() +
  geom_line()

# We see that the max val is 83.6%
best_cutoff = cutoff[which.max(accuracy)]
best_cutoff # obtained at a cutoff of 64

# Now we test our cutoff on our test set
y_hat = ifelse(test_set$height > best_cutoff, "Male", "Female") %>% 
  factor(levels = levels(test_set$sex))
mean(y_hat == test_set$sex) # 81.7%
# Therefore, our results from the training set were NOT overfitted,
# and thus our algorithm is significantly better than simply guessing


