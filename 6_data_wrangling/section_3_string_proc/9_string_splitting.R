library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)

# We assume we don't have the func "read_csv()" and have to manually code a way to read a csv

filename = system.file("extdata/murders.csv", package = "dslabs")
lines = readLines(filename)

lines %>% head() # We can see that csv gets converted to a vector of strs, line by line

# "state,abb,region,population,total", "Alabama,AL,South,4779736,135", "Alaska,AK,West,710231,19", 
# "Arizona,AZ,West,6392017,232", "Arkansas,AR,South,2915918,93", "California,CA,West,37253956,1257"


# str_split() allows us to extract vals with a delimiter
x = str_split(lines, ",")
x %>% head()

# [[1]]
# [1] "state"      "abb"        "region"     "population" "total"     
# 
# [[2]]
# [1] "Alabama" "AL"      "South"   "4779736" "135"    
# 
# [[3]]
# [1] "Alaska" "AK"     "West"   "710231" "19"    
# 
# [[4]]
# [1] "Arizona" "AZ"      "West"    "6392017" "232"    
# 
# [[5]]
# [1] "Arkansas" "AR"       "South"    "2915918"  "93"      
# 
# [[6]]
# [1] "California" "CA"         "West"       "37253956"   "1257"


col_names = x[[1]] # First entry has col names
x = x[-1] # remove col names from data

# map() applies the same func to each element in a list
library(purrr) # Located in purrr lib
map(x, function(y) y[1]) %>% head() # Extracts first entry of each element in x

# More efficient way to do the above:
map(x, 1) %>% head()

# map_chr() to return char vector from a list
# map_int() to return int vector from a list

# The following returns a dataframe:
dat = data.frame(map_chr(x, 1),
                 map_chr(x, 2),
                 map_chr(x, 3),
                 map_chr(x, 4),
                 map_chr(x, 5)) %>%
  mutate_all(parse_guess) %>% # Parses vector and guesses datatype
  setNames(col_names)

dat %>% head()
# NOTE: Above codeblock from instructor not working for some reason, possibly bug in library

# We can do the above block more efficiently:
dat = x %>%
  transpose() %>%
  map( ~ parse_guess(unlist(.))) %>%
  setNames(col_names) %>%
  as.data.frame()


# ALL of the above is useless because we can simply force str_split() to return a matrix instead of a list via simplify
x = str_split(lines, ",", simplify = TRUE)
col_names = x[1,]
x = x[-1,]
x %>% as_data_frame() %>%
  setNames(col_names) %>%
  mutate_all(parse_guess)
# This is the most efficient way to convert a csv to a dataframe w/o read_csv()



