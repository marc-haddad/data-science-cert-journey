library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

# regex is a way to describe specific patterns of a char of text,
# used to determine if given str matches pattern
# For more info on regex: https://regexone.com/

# str_subset() to show entries with "cm"
str_subset(reported_heights$height, "cm") # "165cm"  "170 cm"

# Ask which str satisfy pattern
yes = c("180 cm", "70 inches")
no = c("180", "70''")
s = c(yes, no)

str_detect(s, "cm") | str_detect(s, "inches")
# Above procedure is unnecesarry

# | = "or"
str_detect(s, "cm|inches")

# \d = any digit 0:9
# We need to escape the "\" in R, so 2 are needed

# \\d = any digit 0:9
yes = c("5", "6", "5'10", "5 feet", "4'11")
no = c("", ".", "Five", "six")
s = c(yes, no)
pattern = "\\d"
str_detect(s, pattern) # TRUE TRUE TRUE TRUE TRUE FALSE FALSE FALSE FALSE


# str_view() shows the first time digit was found in each value
str_view(s, pattern)

# str_view_all() shows all matches
str_view_all(s, pattern)





