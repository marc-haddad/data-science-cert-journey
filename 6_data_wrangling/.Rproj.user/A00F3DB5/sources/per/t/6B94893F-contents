library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

# Character Classes are used to define a series of chars that can be matched
# Char classes defined with []
str_view(s, "[56]") # Search for str containing "5" or "6"

# Find ranges with "[num-num]" or "[char-char]"
str_view(s, "[4-7]") # Only works with single digits

str_view(s, "[a-z]") # looks for the first lower-case chars from every val

# "[a-zA-Z]" gives ALL letters


# Anchors let us define chars that must start or end at specific places
# Most common anchors: "^" and "$"
# ^ = beginning of str
# $ = end of str

# Example: "^\\d$" means "find start of str, followed by 1 digit, followed by the end of str"
# The above lets us find vals that are only 1 digit long

# Quantifiers: {} specify things like "1 or 2 digits"
# "^\\d{1,2}" finds vals with 1 or 2 digits.
pattern = "^\\d{1,2}$"
yes = c("1", "5", "9", "12")
no = c("123", "a4", "b")
s = c(yes, no)
str_view(s, pattern)


# Finding strs that contain format num'num"
pattern = "^[4-7]'\\d{1,2}\"$"
# Breakdown of above:
  # ^ = start of str
  # [4-7] = chars "4" or "5" or "6" or "7"
  # ' = strs that contain single quotes after the prev char
  # \\d = full range of digits (I guess like doing [0-9])
  # {1,2} = prev char can be repeated 1 or 2 times
  # \" = str should now have a " after the 1 or 2 digits. \ is so we dont close openning quotes
  # $ = the end of str should occur after everything preceding







