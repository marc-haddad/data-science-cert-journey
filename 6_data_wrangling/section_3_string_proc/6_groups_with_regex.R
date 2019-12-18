library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

# Other formats not accounted for in prev patterns: 
  # num.num
  # num,num
  # num num

# We want to change the above to the format:
  # num'num


# Groups in regex allow us to identify and extract specfic values
# Defined by ()

# Process to define groups in "num,num":
  # First digit b/w 4 and 7: [4-7]
  # Second digit none or more digits: \\d*
pattern_without_groups = "^[4-7],\\d*$"

  # We want to extract digits from above, so we () around each of the 2 digit "groups"
pattern_with_groups = "^([4-7]),(\\d*)$"

# str_match() allows us to extract groups
yes = c("5,9", "5,11", "6,", "6,1")
no = c("5'9", ",", "2,8", "6.1.1")
s = c(yes, no)

str_match(s, pattern_with_groups)

#      [,1]   [,2] [,3]
# [1,] "5,9"  "5"  "9" 
# [2,] "5,11" "5"  "11"
# [3,] "6,"   "6"  ""  
# [4,] "6,1"  "6"  "1" 
# [5,] NA     NA   NA  
# [6,] NA     NA   NA  
# [7,] NA     NA   NA  
# [8,] NA     NA   NA  

# [,1] = pattern detected, [,2] = group1, [,3] = group2

# NOTE: str_match() is diff. from str_extract()
# str_match() returns pattern detected, and the group values
# str_extract() returns ONLY pattern detected (e.g col [,1] above)

str_extract(s, pattern_with_groups)
# "5,9"  "5,11" "6,"   "6,1"  NA     NA     NA     NA 


# To refer to vals of groups we use the format: \\i (where i=integer)
# Ex: \\1 = group1, \\2 = group2

# Example: converting num,num to num'num
pattern_with_groups = "^([4-7]),(\\d*)$"
yes # "5,9"   "5,11"  "6,"   "6,1" 
no  # "5'9"   ","   "2,8"   "6.1.1"

s   # "5,9"   "5,11"   "6,"   "6,1"    "5'9"   ","   "2,8"  "6.1.1"
str_replace(s, pattern_with_groups, "\\1'\\2")
    # "5'9"   "5'11"   "6'"   "6'1"    "5'9"   ","   "2,8"  "6.1.1"


# Our pattern should, thus, now be:
pattern_with_groups = "^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$"

# Breakdown of above:
  # ^ = start of str
  # ([4-7]) = first digit is either 4, 5, 6, 7; grouped with () for later extraction
  # \\s* = none or more spaces
  # [,\\.\\s+] = this char is going to be either , or . or contain AT LEAST one space
  # \\s* = none or more spaces
  # (\\d*) = none or more digits; grouped with () for later extraction
  # $ = end of str

# Finally, locate and format values to be num'num
str_subset(problems, pattern_with_groups) %>%
  str_replace(pattern_with_groups, "\\1'\\2")





















