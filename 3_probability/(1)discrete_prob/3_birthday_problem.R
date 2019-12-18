n = 50
bdays = sample(1:365, n, replace = TRUE)
bdays

# "duplicated()" returns "True" for any repeated element in a vector
duplicated(bdays)
# "any()" returns "True" if at least one element is "True"
any(duplicated(bdays))

# Find probability by repeating above steps and measuring avg 'True' answers
B = 10000
results = replicate(B, {
  bdays = sample(1:365, n, replace = TRUE)
  any(duplicated(bdays))
})
mean(results)
