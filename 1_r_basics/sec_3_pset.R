
avg = mean(heights$height)
ind = sum(heights$height > avg & heights$sex == "Female")
fem = mean(heights$height & heights$sex == "Female")

min = min(heights$height)
ind = match(min, heights$height)
heights$sex[ind]

max = max(heights$height)

int_val = 50:82

sum(!int_val %in% heights$height)

heights2 = mutate(heights, ht_cm = 2.54 * height)

female_df = filter(heights2, sex == "Female")
mean(female_df$ht_cm)
