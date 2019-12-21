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

  # 4. Certain entries had spaces at the end of first digit.
    # Ex: 5 '

  # 5. Entries in meters, some of which use euro notation for decimals
    # Ex: 1,7

  # 6. The letters "cm" were appended to some entries
    # Ex: 170cm

  # 7. One entry spelled out the numbers.
    # Ex: Five foot eight inches


# Solutions:

# 1. Problem: Some entries only have 1 number, w/ no sym.
#    Solution: Append ' 0
yes = c("5", "6", "7")
no = c("5'", "5''", "5'4")
s = c(yes, no)

str_replace(s, "^([4-7])$", "\\1'0") # Detects entries that begin (^) w/ 4-7, and then end ($)
# "5'0" "6'0" "7'0" "5'"  "5''" "5'4"


# 2 & 4. Problem: Defined pattern requires inches be included to be detected, some entries only have ft.
#        Solution: Adapt above regex to detect one or none ('). This will allow us to include entries from case 2.
yes = c("5'", "6 ", "6")
no = c("4'", "5'4", "7'")
s = c(yes, no)

# We only count entries that have either 5 or 6 because we assume that entries above or below were entered in error.
str_replace(s, "^([56])\\s*'?$", "\\1'0") 
# "5'0" "6'0" "6'0" "4'"  "5'4" "7'" 


# 3. Problem: Entries included decimal points for inches. Our pattern as defined only looked for 1 to 2 digits for inches
#    Solution: Allow second digit to have decimals using quantifiers

pattern = "^[4-7]\\s*'\\s*(\\d+\\.?\\d*)$"

# 5. Problem: Entries in meters, some of which use euro notation for decimals
#    Solution: Define pattern to detect "," b/w 1st and 2nd digit (w/ optional spaces)
yes = c("1,7", "1 ,8", "2, ")
no = c("5,8", "5,3,2", "1.7")
s = c(yes, no)

str_replace(s, "^([1,2])\\s*,\\s*(\\d*)$", "\\1\\.\\2") # To be checked later if meters by numeric val
# "1.7"   "1.8"   "2."    "5,8"   "5,3,2"   "1.7" 

# 6 & 7. Problem: Non-numeric entries
#        Solution: Trim spaces at the ends of strs and use to_upper or to_lower to standardize words for easier conversion
# Trim spaces w/ str_trim()
s = "4 ' 7 "
str_trim(s) # "4 ' 7"

# Use to_lower() to standardize strs
s = "Five feet Eleven inches"
str_to_lower(s) # "five feet eleven inches"
# We can now design a func to convert our standardized words to numbers



# Now we can incorporate all these fixes in 2 funcs

convert_format = function(s) {
  s %>%
    str_replace("feet|foot|ft", "'") %>% # Replace feet units w/ syms
    str_replace_all("inches|in|''|\"|cm|and", "") %>% # Remove trailing units
    str_replace("^([4-7])\\s*[,\\.\\s+]\\s*(\\d*)$", "\\1'\\2") %>% # Replace "num,num", "num.num", "num num" formats with "num'num"
    str_replace("^([56])'?$", "\\1'0") %>% # add 0 when just 5 or 6
    str_replace("^([1,2])\\s*,\\s*(\\d*)$", "\\1\\.\\2") %>% # Replace euro decimal with "." for entries in meters
    str_trim() # Remove extra spaces from the ends of strs
}

# Second func converts word entries to numbers (NOTE: This way is not recommended, we will learn better ways to do this later)
words_to_numbers = function(s) {
  str_to_lower(s) %>% # Standardize all strs
    str_replace_all("zero", "0") %>%
    str_replace_all("one", "1") %>%
    str_replace_all("two", "2") %>%
    str_replace_all("three", "3") %>%
    str_replace_all("four", "4") %>%
    str_replace_all("five", "5") %>%
    str_replace_all("six", "6") %>%
    str_replace_all("seven", "7") %>%
    str_replace_all("eight", "8") %>%
    str_replace_all("nine", "9") %>%
    str_replace_all("ten", "10") %>%
    str_replace_all("eleven", "11")
}


# Now we can see which probs remain:

converted = problems %>% words_to_numbers %>% convert_format
remaining_problems = converted[not_inches(converted)]
remaining_problems
pattern = "^[4-7]\\s*'\\s*\\d+\\.?\\d*$"
index = str_detect(remaining_problems, pattern)
remaining_problems[!index]


# Putting everything together and applying changes to the "heights" dataset

pattern = "^([4-7])\\s*'\\s*(\\d+\\.?\\d*)$"
smallest = 50
tallest = 84
new_heights = reported_heights %>%
  mutate(original = height,
         height = words_to_numbers(height) %>% convert_format()) %>%
  extract(height, c("feet", "inches"), regex = pattern, remove = FALSE) %>%
  mutate_at(c("height", "feet", "inches"), as.numeric) %>%
  mutate(guess = 12*feet + inches) %>%
  mutate(height = case_when(
    !is.na(height) & between(height, smallest, tallest) ~ height, # Inches
    !is.na(height) & between(height / 2.54, smallest, tallest) ~ height / 2.54, # Centimeters
    !is.na(height) & between(height * 100 / 2.54, smallest, tallest) ~ height * 100 / 2.54, # Meters
    !is.na(guess) & inches < 12 & between(guess, smallest, tallest) ~ guess, # feet'inches
    TRUE ~ as.numeric(NA))) %>%
  select(-guess)

new_heights %>%
  filter(not_inches(original)) %>%
  select(original, height) %>%
  arrange(height) %>%
  View()

new_heights %>% arrange(height) %>% head(n=50)
  
