set.seed(1986, sample.kind = "Rounding")
beads = rep( c("red", "blue"), times = c(2, 3))
sample(beads, 1)

B = 10000

events = replicate(B, sample(beads, 1))
tab = table(events)

# No need for 'replicate', can be done with just 'sample'
events = sample(beads, B, replace = TRUE)
prop.table(table(events))