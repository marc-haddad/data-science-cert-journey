library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

# How to separate and save vals with regex

# Simple example using vals in desired format
s = c("5'10", "6'1")
tab = data.frame(x = s)


tab %>% separate(x, c("feet", "inches"), sep = "'")

# Equivalent code:
tab %>% extract(x, c("feet", "inches"), regex = "^(\\d)'(\\d{1,2})$")

# Regex is preferred over separate() because it allows for more flexibility
s = c("5'10", "6'1\"", "5'8inches")
tab = data.frame(x = s)

# My regex attempt
tab %>% extract(x, c("feet", "inches"), regex = "^(\\d)'(\\d{1,2})[\"a-z]*$")
#   feet inches
#     5     10
#     6      1
#     5      8


# Prof.'s regex
tab %>% extract(x, c("feet", "inches"), regex = "(\\d)'(\\d{1,2})")
#   feet inches
#     5     10
#     6      1
#     5      8



