library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

# Not all issues were found with the defined pattern
pattern = "^[4-7]'\\d{1,2}\"$"
sum(str_detect(problems, pattern)) # Only 14

# This shows some examples of strs that have pattern and strs that don't
problems[c(2, 10, 11, 12, 15)] %>% str_view(pattern)


# Problems our initial pattern does not account for:
  # Students wrote the words "inches" and "feet"
str_subset(problems, "inches")

  # Students represented inches with two ' rather than one "
str_subset(problems, "''")


# A way to address above issues:
  # Replace feet/symbols with single ', remove any representations of inches
  # So, format is: num'num
# New pattern, w/o inches:
pattern = "^[4-7]'\\d{1,2}$"
problems %>% 
  str_replace("feet|ft|foot", "'") %>%
  str_replace("inches|in|''|\"", "") %>%
  str_detect(pattern) %>%
  sum # Now we have 48 matches instead of 14
problems

# White spaces are represented as "\\s"
# To find entries that have a space b/w feet sym and inch num:
pattern_2 = "^[4-7]'\\s\\d{1,2}$"
str_subset(problems, pattern_2)

# Instead of requiring 2 separate patterns we can use quantifiers

# * = none or more instances
# Example:
yes = c("AB", "A1B", "A11B", "A111B", "A1111B")
no = c("A2B", "A21B")
str_detect(yes, "A1*B") # TRUE TRUE TRUE TRUE TRUE
str_detect(no, "A1*B") # FALSE FALSE
  
# ? = none or once

# + = once or more

# Example:
data.frame(string = yes,
           none_or_more = str_detect(yes, "A1*B"),
           none_or_once = str_detect(yes, "A1?B"),
           once_or_more = str_detect(yes, "A1+B"))

#     string  none_or_more  none_or_once  once_or_more
# 1     AB         TRUE         TRUE        FALSE
# 2    A1B         TRUE         TRUE         TRUE
# 3   A11B         TRUE        FALSE         TRUE
# 4  A111B         TRUE        FALSE         TRUE
# 5 A1111B         TRUE        FALSE         TRUE


# New pattern:
pattern = "^[4-7]\\s*'\\s*\\d{1,2}$"
problems %>%
  str_replace("feet|ft|foot", "'") %>% # Replace ft repres. w/ '
  str_replace("inches|in|''|\"", "") %>% # Remove all repres. of inches
  str_detect(pattern) %>%
  sum # 53


















