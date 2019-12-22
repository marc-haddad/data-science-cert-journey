library(dslabs)
library(lubridate)
library(gutenbergr)
library(tidyverse)
library(tidytext)
options(digits = 3)

# Dates, Times, and Text Mining Assessment

# Datetime section

data("brexit_polls")


# How many polls had a start date in April
brexit_polls %>% filter(month(startdate) == 4) %>%
  nrow() # 25


# How many polls ended on the week of 2016-06-12
brexit_polls %>% filter(round_date(enddate, unit = "week") == "2016-06-12") %>%
  nrow() # 13


# Which weekday did most polls end on?
table(weekdays(brexit_polls$enddate)) 
# Sunday


data("movielens")
head(movielens)


# Convert timestamp col into dates
max(table(year(as_datetime(movielens$timestamp))))
# The year 2000 had the most movie reviews
max(table(hour(as_datetime(movielens$timestamp))))
# 20th hour had the most reviews



# Text mining / sentiment analysis section

gutenberg_metadata


# How many diff IDs returned when searching for Pride and Prejudice?
gutenberg_metadata %>% filter(str_detect(title, "Pride and Prejudice")) %>%
  distinct() %>% nrow()
# 6


# Find the correct ID for P & P by filtering for the english version
gutenberg_works(title == "Pride and Prejudice")
# ID is 1342


# Download P & P
gutenberg_download(1342)


# How many words in P & P?
words = gutenberg_download(1342) %>% unnest_tokens(word, text)
nrow(words)
# 122,204 words


# Filter stop words; How many words left?
words = words %>% filter(!word %in% stop_words$word)
nrow(words)
# 37,246 words left


# Remove digits from words; How many left?
words = words %>% filter(!word %in% stop_words$word &
                   !str_detect(word, "\\d+"))
nrow(words)
# 37,180 words remain


# How many words appear more than 100 times?
words %>% count(word) %>% filter(n > 100) %>% arrange(desc(n))
# Num of words repeated > 100: 23, Most freq word: Elizabeth (n = 597)


# How many words have sentiments in afinn lexicon?
afinn = get_sentiments("afinn")

afinn_sentiments = words %>% inner_join(afinn, by = "word")
# 6,065 words have sentiments


# Proportion of positive affin vals
positive_vals = afinn_sentiments %>% filter(value > 0) %>% nrow()
positive_vals / 6065
# 0.563


# How many elements in afinn_sentiments have a value of 4?
afinn_sentiments %>% filter(value == 4) %>% nrow()
# 51 words have a value of 4







