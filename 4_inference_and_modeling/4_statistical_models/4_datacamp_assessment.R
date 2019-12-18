# Load the 'dslabs' package and data contained in 'heights'
library(dslabs)
data(heights)

#E1

# Make a vector of heights from all males in the population
x <- heights %>% filter(sex == "Male") %>%
  .$height
x

# Calculate the population average. Print this value to the console.
mean(x)

# Calculate the population standard deviation. Print this value to the console.
sd(x)




#E2

# The vector of all male heights in our population `x` has already been loaded for you. You can examine the first six elements using `head`.
head(x)

# Use the `set.seed` function to make sure your answer matches the expected result after random sampling
set.seed(1)

# Define `N` as the number of people measured
N <- 50

# Define `X` as a random sample from our population `x`
X = sample(x, N, replace = TRUE)

# Calculate the sample average. Print this value to the console.
mean(X)

# Calculate the sample standard deviation. Print this value to the console.
sd(X)




#E4

# The vector of all male heights in our population `x` has already been loaded for you. You can examine the first six elements using `head`.
head(x)

# Use the `set.seed` function to make sure your answer matches the expected result after random sampling
set.seed(1)

# Define `N` as the number of people measured
N <- 50

# Define `X` as a random sample from our population `x`
X <- sample(x, N, replace = TRUE)

# Define `se` as the standard error of the estimate. Print this value to the console.
se = sd(X)/sqrt(N)
se

# Construct a 95% confidence interval for the population average based on our sample. Save the lower and then the upper confidence interval to a variable called `ci`.
error = qnorm(0.975) * se
lower = mean(X) - error
upper = mean(X) + error
ci = c(lower, upper)
ci



#E5

# Define `mu` as the population average
mu <- mean(x)

# Use the `set.seed` function to make sure your answer matches the expected result after random sampling
set.seed(1)

# Define `N` as the number of people measured
N <- 50

# Define `B` as the number of times to run the model
B <- 10000

# Define an object `res` that contains a logical vector for simulated intervals that contain mu
res = replicate(B, {
  X = sample(x, N, replace = TRUE)
  interval = c(mean(X) - sd(X)/sqrt(N) * qnorm(0.975), mean(X) + sd(X)/sqrt(N) * qnorm(0.975))
  between(mu, interval[1], interval[2])
})

# Calculate the proportion of results in `res` that include mu. Print this value to the console.
mean(res)




#E6


# Load the libraries and data you need for the following exercises
library(dslabs)
library(dplyr)
library(ggplot2)
data("polls_us_election_2016")

# These lines of code filter for the polls we want and calculate the spreads
polls <- polls_us_election_2016 %>% 
  filter(pollster %in% c("Rasmussen Reports/Pulse Opinion Research","The Times-Picayune/Lucid") &
           enddate >= "2016-10-15" &
           state == "U.S.") %>% 
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100) 

# Make a boxplot with points of the spread for each pollster
polls %>% ggplot(aes(x = pollster, y = spread)) +
  geom_boxplot() +
  geom_point()



#E13

# The `polls` data have already been loaded for you. Use the `head` function to examine them.
head(polls)

# Create an object called `sigma` that contains a column for `pollster` and a column for `s`, the standard deviation of the spread
sigma = polls %>% group_by(pollster) %>%
  summarize(s = sd(spread))



# Print the contents of sigma to the console
sigma




#E15

# The `polls` data have already been loaded for you. Use the `head` function to examine them.
head(polls)

# Create an object called `res` that summarizes the average, standard deviation, and number of polls for the two pollsters.
res = polls %>% group_by(pollster) %>%
  summarize(mean(spread), sd(spread), n())
res


# Store the difference between the larger average and the smaller in a variable called `estimate`. Print this value to the console.
estimate = res[[2]][2] - res[[2]][1]
estimate

# Store the standard error of the estimates as a variable called `se_hat`. Print this value to the console.
se_hat = sqrt(res[[3]][2]^2/res[[4]][2] + res[[3]][1]^2/res[[4]][1])
se_hat

# Calculate the 95% confidence interval of the spreads. Save the lower and then the upper confidence interval to a variable called `ci`.
error = se_hat * qnorm(0.975)
lower = estimate - error
upper = estimate + error
ci = c(lower, upper)
ci



#E16

# We made an object `res` to summarize the average, standard deviation, and number of polls for the two pollsters.
res <- polls %>% group_by(pollster) %>% 
  summarize(avg = mean(spread), s = sd(spread), N = n()) 

# The variables `estimate` and `se_hat` contain the spread estimates and standard error, respectively.
estimate <- res$avg[2] - res$avg[1]
se_hat <- sqrt(res$s[2]^2/res$N[2] + res$s[1]^2/res$N[1])

# Calculate the p-value
(1 - pnorm(estimate/se_hat)) * 2



#E17

# Execute the following lines of code to filter the polling data and calculate the spread
polls <- polls_us_election_2016 %>% 
  filter(enddate >= "2016-10-15" &
           state == "U.S.") %>%
  group_by(pollster) %>%
  filter(n() >= 5) %>% 
  mutate(spread = rawpoll_clinton/100 - rawpoll_trump/100) %>%
  ungroup()

# Create an object called `var` that contains columns for the pollster, mean spread, and standard deviation. Print the contents of this object to the console.
var = polls %>% group_by(pollster) %>% summarize(avg = mean(spread), s = sd(spread))
var








