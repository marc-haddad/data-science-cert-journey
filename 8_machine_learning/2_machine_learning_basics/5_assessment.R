# Part 1

library(dslabs)
library(dplyr)
library(lubridate)

data("reported_heights")

dat <- mutate(reported_heights, date_time = ymd_hms(time_stamp)) %>%
  filter(date_time >= make_date(2016, 01, 25) & date_time < make_date(2016, 02, 1)) %>%
  mutate(type = ifelse(day(date_time) == 25 & hour(date_time) == 8 & between(minute(date_time), 15, 30), "inclass","online")) %>%
  select(sex, type)

y <- factor(dat$sex, c("Female", "Male"))
x <- dat$type

dat %>% filter(type == "online") %>% 
  summarize(female_p = mean(sex == "Female"))

types = c("inclass", "online")
types

# B/c we found earlier that 66% of inclass were female, we will train our algo to guess "Female" when type == "inclass"
y_hat = ifelse(dat$type == "inclass", "Female", "Male") 
mean(y_hat == dat$sex)

# Table to show confusion matrix b/w predicted y_hat and actual y
table(y_hat, dat$sex) # dat$sex here is "y"

# Find sens.
sensitivity(factor(y_hat), factor(dat$sex)) # 0.382

# Find speci.
specificity(factor(y_hat), factor(dat$sex)) # 0.841

# Find prevalence of Females in orig. dat
mean(dat$sex == "Female")





# Part 2

library(dslabs)
library(datasets)
library(caret)
data(iris)
iris <- iris[-which(iris$Species=='setosa'),]
y <- iris$Species
y
set.seed(2, sample.kind = "Rounding")

# Create even split for train and test sets
test_index = createDataPartition(y, times = 1, p = 0.5, list = FALSE)

test = iris[test_index,]

train = iris[-test_index,]

# Create cutoffs
sepal_len_cutoffs = seq(min(train$Sepal.Length),
                        max(train$Sepal.Length),
                        0.1)
sepal_wid_cutoffs = seq(min(train$Sepal.Width),
                        max(train$Sepal.Width),
                        0.1)

petal_len_cutoffs = seq(min(train$Petal.Length), 
                        max(train$Petal.Length),
                        0.1)
petal_wid_cutoffs = seq(min(train$Petal.Width),
                        max(train$Petal.Width),
                        0.1)

# Find max accuracy for each set of cutoffs and pick the predictor that yields the highest accuracy
  
  # Sepal Length
accuracy = map_dbl(sepal_len_cutoffs, function(x) {
  y_hat = ifelse(train$Sepal.Length > x, "virginica", "versicolor") %>% 
    factor(levels = levels(train$Species))
  print(y_hat)
  mean(y_hat == train$Species)
})
accuracy
max(accuracy) # 0.7

  # Sepal Width
accuracy = map_dbl(sepal_wid_cutoffs, function(x) {
  y_hat = ifelse(train$Sepal.Width > x, "virginica", "versicolor") %>% 
    factor(levels = levels(train$Species))
  mean(y_hat == train$Species)
})
max(accuracy) # 0.62


  # Petal Width
accuracy = map_dbl(petal_wid_cutoffs, function(x) {
  y_hat = ifelse(train$Petal.Width > x, "virginica", "versicolor") %>% 
    factor(levels = levels(train$Species))
  mean(y_hat == train$Species)
})
max(accuracy) # 0.94

  # Petal Length
accuracy = map_dbl(petal_len_cutoffs, function(x) {
  y_hat = ifelse(train$Petal.Length > x, "virginica", "versicolor") %>% 
    factor(levels = levels(train$Species))
  mean(y_hat == train$Species)
})
max(accuracy) # 0.96
# Petal length is the most accurate predictor for our training set

# Find smart cutoff val
best = petal_len_cutoffs[which.max(accuracy)]
best # Length of 4.7

# Test smart cutoff val in test set
prediction = ifelse(test$Petal.Length > best, "virginica", "versicolor") %>% 
  factor(levels = levels(train$Species))
mean(prediction == test$Species) # 0.9


# Which is the actual best predictor for our TEST set?

  # Sepal Width
accuracy = map_dbl(sepal_wid_cutoffs, function(x) {
  y_hat = ifelse(test$Sepal.Width > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == test$Species)
})
max(accuracy) # 0.64

  # Sepal Length
accuracy = map_dbl(sepal_len_cutoffs, function(x) {
  y_hat = ifelse(test$Sepal.Length > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == test$Species)
})
max(accuracy) # 0.78

  # Petal Width
accuracy = map_dbl(petal_wid_cutoffs, function(x) {
  y_hat = ifelse(test$Petal.Width > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == test$Species)
})
max(accuracy) # 0.94

  # Petal Length
accuracy = map_dbl(petal_len_cutoffs, function(x) {
  y_hat = ifelse(test$Petal.Length > x, "virginica", "versicolor") %>% 
    factor(levels = levels(test$Species))
  mean(y_hat == test$Species)
})
max(accuracy) # 0.9

# In the case of the test set, petal WIDTH is the most accurate predictor

# Exploratory analysis of dataset
plot(iris, pch = 21, bg = iris$Species)

# Best cutoff for length = 4.7, best for Width = 1.5, combine
prediction = ifelse((test$Petal.Width > 1.5) & (test$Petal.Length > 4.7) , "virginica", "versicolor") %>% 
  factor(levels = levels(train$Species))
mean(prediction == test$Species) # 0.92



