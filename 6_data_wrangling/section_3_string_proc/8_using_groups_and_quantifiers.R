library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

 
# Issues yet to be solved:
  
  # 1. Some entries only have 1 number, w/ no sym.
    # Ex: 5

  # 2. Defined pattern requires inches be included to be detected, some entries only have ft.
    # Ex: 6'
  
  # 3. Entries included decimal points for inches. Our pattern as defined only looked for 1 to 2 digits for inches
    # Ex: 5'7.5"

  # 4. Certain entries had spaces between digits.
    # Ex: 5 ' 9

  # 5. Entries in meters, some of which use euro notation for decimals
    # Ex: 1.6 or 1,7

  # 6. The letters "cm" were appended to some entries
    # Ex: 170cm

  # 7. One entry spelled out the numbers.
    # Ex: Five foot eight inches


# Solutions:

# 1
  # Append ' 0
yes = c("5", "6", "7")
no = c("5'", "5''", "5'4")
s = c(yes, no)

str_replace(s, "^([4-7])$", "\\1'0") # Detects entries that begin (^) w/ 4-7, and then end ($)
# "5'0" "6'0" "7'0" "5'"  "5''" "5'4"







