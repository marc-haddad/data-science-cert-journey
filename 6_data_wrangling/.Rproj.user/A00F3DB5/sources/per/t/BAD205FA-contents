library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)


# read in raw murders data from Wikipedia
url <- "https://en.wikipedia.org/w/index.php?title=Gun_violence_in_the_United_States_by_state&direction=prev&oldid=810166167"
murders_raw <- read_html(url) %>%
  html_node("table") %>%
  html_table() %>%
  setNames(c("state", "population", "total", "murder_rate"))

# inspect data and column classes
head(murders_raw)
class(murders_raw$population)
class(murders_raw$total)

murders_raw$population[1:3] # Nums represented as char

# str_detect() parses for specified chars
commas = function(x) any(str_detect(x, ","))
murders_raw %>% summarize_all(funs(commas))

# str_replace_all() replaces chars
test_1 = str_replace_all(murders_raw$population, ",", "") 
test_1 = as.numeric(test_1)
test_1

# parse_number() simplifies the above
test_2 = parse_number(murders_raw$population)
identical(test_1, test_2)

# Clean cols 
murders_new = murders_raw %>% mutate_at(2:3, parse_number)
head(murders_new)





