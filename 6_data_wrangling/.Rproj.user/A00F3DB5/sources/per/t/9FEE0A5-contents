library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

data("reported_heights")

# Find entries where as.numeric() throws an error
reported_heights %>% mutate(new_height = as.numeric(height)) %>%
  filter(is.na(new_height)) %>%
  head(n=10)

# Function to find heights that cannot be converted to inches
not_inches = function(x, smallest = 50, tallest = 84){
  inches = suppressWarnings(as.numeric(x))
  ind = is.na(inches) | inches < smallest | inches > tallest
  ind
}

problems = reported_heights %>%
  filter(not_inches(height)) %>%
  .$height
length(problems)

# By survaying problems, we see 3 common patterns that raise errors:
  # 1. x'y or x'y" or x'y\"
  # 2. x.y or x,y
  # 3. reported in cm

