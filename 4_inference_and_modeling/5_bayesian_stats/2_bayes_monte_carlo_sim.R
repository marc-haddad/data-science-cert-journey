
# Proof of Bayes theorem via Monte Carlo

prev = 0.00025
N = 100000
outcome = sample(c("Disease", "Healthy"), N, replace = TRUE, prob = c(prev, 1 - prev))

N_D = sum(outcome == "Disease")
N_D

N_H = sum(outcome == "Healthy")
N_H

accuracy = 0.99
test = vector("character", N)

# From those who are actually "Diseased" we are conducting a random test with the given accuracy 0.99
test[outcome == "Disease"] = sample(c("+", "-"), N_D, replace = TRUE, prob = c(accuracy, 1-accuracy))

# From those who are actually "Healthy" we are conducting a random test with the given accuracy 0.99
# Any positives from this test are "false-positives" because the subjects are actually healthy
test[outcome == "Healthy"] = sample(c("-", "+"), N_H, replace = TRUE, prob = c(accuracy, 1-accuracy))

# This table illustrates the large number of false positives,
# making the prob of actually having the disease given a positive test result
# to be 0.02
table(outcome, test)
