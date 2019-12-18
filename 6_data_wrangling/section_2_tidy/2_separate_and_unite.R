# seperate() and unite()

path = system.file("extdata", package = "dslabs")
filename = file.path(path, "life-expectancy-and-fertility-two-countries-example.csv")

raw_dat = read_csv(filename)

# Convention is to write "key" b/c it contains more than one var
dat = raw_dat %>% gather(key, value, -country)
head(dat)

# Now we must separate the "key" column into year and var type

# separate() takes 3 args:
  # Name of col to be sep
  # Names to be used for the new cols
  # Char that sep the vars
# First Attempt:
dat %>% separate(key, c("year", "variable_name"), "_")
# We have a prob, col name comes out as "life" and not "life_expectancy"

# Second Attempt:
dat %>% separate(key, c("year", "first_var_name", "second_var_name"), fill = "right")

# Third Attempt:
dat %>% separate(key, c("year", "variable_name"), sep = "_", extra = "merge")
# The above code tells R that when it encounters extra "_" after first one, just merge on last

# Fourth Attempt: Best
# Now we need to create a col for each var instead of both in 1 col
dat %>% separate(key, c("year", "variable_name"), sep = "_", extra = "merge") %>%
  spread(variable_name, value) # Expands var_name by its val.
