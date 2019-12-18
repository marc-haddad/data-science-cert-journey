
color = rep(c("Black", "Red", "Green"), c(18, 18, 2))
color

n = 1000
X = sample(ifelse(color == "Red", -1, 1), n, replace = TRUE)

S = sum(X)
S

# Another way to do the above
x <- sample(c(-1, 1), n, replace = TRUE, prob = c(9/19, 10/19))    # 1000 independent draws
S <- sum(x)    # total winnings = sum of draws
S

B = 10000

S = replicate(B, {
  x = sample(c(-1, 1), n, replace = TRUE, prob = c(9/19, 10/19))
  sum(x)
})
mean(S < 0)

