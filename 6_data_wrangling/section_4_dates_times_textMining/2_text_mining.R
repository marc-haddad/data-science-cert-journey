library(tidyverse)
library(tidytext)
library(ggplot2)
library(lubridate)
library(tidyr)
library(scales)
library(dslabs)


data("trump_tweets")

# tidytext helps convert free form text into a tidy table


# unnest_tokens() extracts individual words or chunks of text

# Sentiment analysis assigns emotions or a positive/negative score to tokens (WTF does this even mean?)
# get_sentiments() extracts sentiments

# Here we will learn how to generate useful numerical summaries from text data
# For more info on text mining: https://www.tidytextmining.com/

head(trump_tweets)
names(trump_tweets) # Col names

trump_tweets %>% select(text) %>% head # Actual text of tweets

trump_tweets %>% count(source) %>% arrange(desc(n)) # Devices that were used to write tweet

# Clean up source names by removing "Twitter for"
trump_tweets %>%
  extract(source, "source", "Twitter for (.*)") %>% # Args: Col we want our data from (source), Name of new object to store filtered data ("source"), and regex.
  count(source)

# A tibble: 6 x 2
#   source         n
#   <chr>      <int>
# 1 Android     4652
# 2 BlackBerry    78
# 3 iPad          39
# 4 iPhone      3962
# 5 Websites       1
# 6 NA         12029


# Define tweets b/w campaign announcement and election day
campaign_tweets = trump_tweets %>%
  extract(source, "source", "Twitter for (.*)") %>%
  filter(source %in% c("Android", "iPhone") &
           created_at >= ymd("2015-06-17") &
           created_at < ymd("2016-11-08")) %>%
  filter(!is_retweet) %>%
  arrange(created_at)
campaign_tweets

# Now we use data visualization to explore possibility of 2 different groups tweeting on Trumps account (him and his staff)
ds_theme_set()
campaign_tweets %>%
  mutate(hour = hour(with_tz(created_at, "EST"))) %>%
  count(source, hour) %>%
  group_by(source) %>%
  mutate(percent = n / sum(n)) %>%
  ungroup %>%
  ggplot(aes(hour, percent, color = source)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(labels = percent_format()) +
  labs(x = "Hour of day (EST)",
       y = "% of Tweets",
       color = "")
# The plot above shows 2 significant peaks in tweet sources:
# Around 5 am to 6 am, Android was mostly used
# and around 3 pm to 8 pm, iPhone was mostly used

# We can conclude that there appears to be two separate entities tweeting from Trump's account



# Using the tidytext package we can analyze the text further

# unnest_tokens() helps us convert free form text into a tidy table
# "Token" refers to the units we are considering to be a data point; most common token is words.
# The helper functions in tidytext will extract tokens and place each in its own row.
example = data_frame(line = c(1, 2, 3, 4),
                     text = c("Roses are red,", "Violets are blue,", "Sugar is sweet,", "It'll give you diabetes"))
example

# A tibble: 4 x 2
# line text                   
# <dbl> <chr>                  
# 1     Roses are red,         
# 2     Violets are blue,      
# 3     Sugar is sweet,        
# 4     It'll give you diabetes

example %>% unnest_tokens(word, text) # Example w/ unnested tokens

# A tibble: 13 x 2
# line word    
# <dbl> <chr>   
# 1     roses   
# 2     are     
# 3     red     
# 4     violets 
# 5     are     
# 6     blue    
# 7     sugar   
# 8     is      
# 9     sweet   
# 10    it'll   
# 11    give    
# 12    you     
# 13    diabetes


# Looking at tweet # 3008:
i = 3008
campaign_tweets$text[i]
campaign_tweets[i,] %>%
  unnest_tokens(word, text) %>%
  select(word)
# The above creates an issue b/c the default action of unnest_tokens(word, )
# removes syms such as # and @; which are important for twitter's context
# To solve this we use regex:
pattern = "([^A-Za-z\\d#@']|'(?![A-Za-z\\d#@]))"

campaign_tweets[i,] %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  select(word)

#               word
# 1            great
# 2               to
# 3               be
# 4             back
# 5               in
# 6             iowa
# 7             #tbt
# 8             with
# 9  @jerryjrfalwell
# 10         joining
# 11              me
# 12              in
# 13       davenport
# 14            this
# 15            past
# 16          winter
# 17           #maga
# 18           https
# 19               t
# 20              co
# 21      a5if0qhnic

# Remove links to pics
campaign_tweets[i,] %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern)

# Extract words from tweet into tidy table
tweet_words = campaign_tweets %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern)
tweet_words # This covers ALL tweets

# What are the most commonly used words?
tweet_words %>%
  count(word) %>%
  arrange(desc(n))

# A tibble: 6,211 x 2
#  word      n
#  <chr>   <int>
# 1 the    2335
# 2 to     1413
# 3 and    1246
# 4 a      1210
# 5 in     1189
# 6 i      1161
# 7 you    1000
# 8 of      983
# 9 is      944
# 10 on      880
# … with 6,201 more rows

# The above is not very useful
# Tidytext has database of most commonly used words, known as "stop words"
# stop_words (class: table)

# Filter out stop words
tweet_words = campaign_tweets %>%
  mutate(text = str_replace_all(text, "https://t.co/[A-Za-z\\d]+|&amp;", "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  filter(!word %in% stop_words$word)

tweet_words %>%
  count(word) %>%
  top_n(10, n) %>%
  mutate(word = reorder(word, n)) %>%
  arrange(desc(n))

# Top 10 most commonly tweeted words:
# A tibble: 10 x 2
#   word                      n
#   <fct>                  <int>
# 1 #trump2016               415
# 2 hillary                  407
# 3 people                   303
# 4 #makeamericagreatagain   296
# 5 america                  254
# 6 clinton                  239
# 7 poll                     220
# 8 crooked                  206
# 9 trump                    199
# 10 cruz                     162

# We need a couple more tweeks to our table:
# Remove words that are just nums
# Remove single quotes from the start of words (for some reason, idfk)
tweet_words = campaign_tweets %>%
  mutate(text = str_replace_all(text, "https://t.co.[A-Za-z\\d]+|&amp;", "")) %>%
  unnest_tokens(word, text, token = "regex", pattern = pattern) %>%
  filter(!word %in% stop_words$word &
           !str_detect(word, "^\\d+$")) %>%
  mutate(word = str_replace(word, "^'", ""))


# Now we can look for which words are most common when using Android or iPhone

# To know if certain words are more likely to appear in either device we use the ODDS RATIO
android_iphone_or = tweet_words %>%
  count(word, source) %>%
  spread(source, n, fill = 0) %>% # This step creates tibble w/ rows for each word w/ cols for Android and iPhone
  mutate(or = (Android + 0.5) / (sum(Android) - Android + 0.5) /
           ((iPhone + 0.5) / (sum(iPhone) - iPhone + 0.5))) # 0.5s are used as a correction for any potential 0's

android_iphone_or %>% arrange(desc(or))
android_iphone_or %>% arrange(or)

# Filter according to the most frequent words

android_iphone_or %>% filter(Android + iPhone > 100) %>%
  arrange(desc(or)) 

# Words most likely to come from Android

# A tibble: 30 x 4
# word          Android  iPhone   or
# <chr>            <dbl>  <dbl> <dbl>
# 1 @cnn            104     18  4.95
# 2 bad             104     26  3.45
# 3 crooked         157     49  2.79
# 4 ted              85     28  2.62
# 5 interviewed      76     25  2.62
# 6 media            77     26  2.56
# 7 cruz            116     46  2.19
# 8 hillary         290    119  2.14
# 9 win              74     30  2.14
# 10 president       84     35  2.08
# … with 20 more rows


android_iphone_or %>% filter(Android + iPhone > 100) %>%
  arrange(or)

# Words most likely to come from iPhone

# A tibble: 30 x 4
#   word                   Android iPhone    or
#   <chr>                    <dbl>  <dbl>   <dbl>
# 1 #makeamericagreatagain       0    296  0.00144
# 2 #trump2016                   3    412  0.00718
# 3 join                         1    157  0.00821
# 4 tomorrow                    25    101  0.218  
# 5 vote                        46     67  0.600  
# 6 america                    114    141  0.703  
# 7 tonight                     71     84  0.737  
# 8 iowa                        62     65  0.831  
# 9 poll                       117    103  0.990  
# 10 trump                     112     92  1.06   
# … with 20 more rows



