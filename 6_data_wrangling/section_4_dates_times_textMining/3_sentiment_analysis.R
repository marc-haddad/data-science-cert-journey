# Continues from 2_text_mining.R
set.seed(1, sample.kind = "Rounding")
library(broom)


# Sentiment analysis involves associating one or more "sentiments" to a word.

# The object "sentiments" in the tidytext package contains various mappings (AKA lexicons) of words with different params.
sentiments

# "bing" lexicon divides words into positive and negative.
get_sentiments("bing")

# "afinn" lexicon assigns scores b/w -5 (most negative) and 5 (most positive)
get_sentiments("afinn")

# "loughran" and "nrc" are also lexicons (see ?sentiments for more info)
get_sentiments("loughran") %>% count(sentiment)
get_sentiments("nrc") %>% count(sentiment)

# "nrc" lexicon is most appropriate for our analysis
nrc = get_sentiments("nrc")
str(nrc)


# Combine words and sentiments w/ inner_join(), which only keeps words associated w/ a sentiment
tweet_words %>% inner_join(nrc, by = "word") %>%
  select(source, word, sentiment) %>% sample_n(10)

#     source        word    sentiment
# 1  Android incompetent        anger
# 2   iPhone        join     positive
# 3  Android      honest        trust
# 4  Android   president        trust
# 5  Android       money anticipation
# 6  Android       nasty      disgust
# 7  Android   messenger        trust
# 8  Android        bomb      sadness
# 9   iPhone      friend          joy
# 10 Android         bad      sadness


# Performing quantitative analysis comparing Android to iPhone tweets

sentiment_counts = tweet_words %>%
  left_join(nrc, by = "word") %>%
  count(source, sentiment) %>%
  spread(source, n) %>%
  mutate(sentiment = replace_na(sentiment, replace = "none"))
sentiment_counts # Returns the count of all sentiments in the tweets

# A tibble: 11 x 3
#   sentiment     Android  iPhone
#   <chr>           <int>  <int>
# 1 anger            965    527
# 2 anticipation     915    710
# 3 disgust          641    318
# 4 fear             802    486
# 5 joy              698    540
# 6 negative        1668    935
# 7 positive        1834   1497
# 8 sadness          907    514
# 9 surprise         530    365
# 10 trust           1253   1010
# 11 none           11523  10739

tweet_words %>% group_by(source) %>% summarize(n = n()) # This shows that android used more words overall
# A tibble: 2 x 2
#   source    n
#   <chr>   <int>
# 1 Android 15829
# 2 iPhone  13802

# So it would be best to compute the odds of sentiments appearing on each device
# We do this by calc the proportion of words w/ sentiment vs. proportion of words w/o
# then compute odds ratio to compare the devices
sentiment_counts %>%
  mutate(Android = Android / (sum(Android) - Android),
         iPhone = iPhone / (sum(iPhone) - iPhone),
         or = Android / iPhone) %>% # or = Odds Ratio
  arrange(desc(or))

# A tibble: 11 x 4
# sentiment       Android  iPhone  or
# <chr>            <dbl>   <dbl>  <dbl>
# 1 disgust       0.0304  0.0184  1.66 
# 2 anger         0.0465  0.0308  1.51 
# 3 negative      0.0831  0.0560  1.49 
# 4 sadness       0.0435  0.0300  1.45 
# 5 fear          0.0383  0.0283  1.35 
# 6 surprise      0.0250  0.0211  1.18 
# 7 joy           0.0332  0.0316  1.05 
# 8 anticipation  0.0439  0.0419  1.05 
# 9 trust         0.0612  0.0607  1.01 
# 10 positive     0.0922  0.0927 0.994
# 11 none         1.13    1.56   0.725

# The higher the "or" the more likely the sentiment will appear in a tweet from an android


# Testing our results: How does this tbl compare to randomly assigning sentiments to words? Could it be a fluke?
# We need confidence intervals
log_or = sentiment_counts %>%
  mutate(log_or = log((Android / (sum(Android) - Android)) / (iPhone / (sum(iPhone) - iPhone))),
                      se = sqrt(1 / Android + 1 / (sum(Android) - Android) + 1 / iPhone + 1 / (sum(iPhone) - iPhone)),
                      conf.low = log_or - qnorm(0.975) * se,
                      conf.high = log_or + qnorm(0.975) * se) %>%
           arrange(desc(log_or))
log_or

# A tibble: 11 x 7
#    sentiment    Android   iPhone   log_or   se   conf.low conf.high
#    <chr>          <int>   <int>    <dbl>  <dbl>    <dbl>     <dbl>
# 1  disgust          641    318   0.504   0.0694   0.368     0.640 
# 2  anger            965    527   0.411   0.0551   0.303     0.519 
# 3  negative        1668    935   0.395   0.0422   0.313     0.478 
# 4  sadness          907    514   0.372   0.0562   0.262     0.482 
# 5  fear             802    486   0.302   0.0584   0.187     0.416 
# 6  surprise         530    365   0.168   0.0688   0.0332    0.303 
# 7  joy              698    540   0.0495  0.0582  -0.0647    0.164 
# 8  anticipation     915    710   0.0468  0.0511  -0.0533    0.147 
# 9  trust           1253   1010   0.00726 0.0436  -0.0781    0.0926
# 10 positive        1834   1497  -0.00624 0.0364  -0.0776    0.0651
# 11 none           11523  10739  -0.321   0.0206  -0.362    -0.281 


# Graphical viz of above
log_or %>%
  mutate(sentiment = reorder(sentiment, log_or),) %>%
  ggplot(aes(x = sentiment, ymin = conf.low, ymax = conf.high)) +
  geom_errorbar() +
  geom_point(aes(sentiment, log_or)) +
  ylab("Log odds ratio for association between Android and sentiment") +
  coord_flip()
# Conclusions from graph:
  # The sentiments associated to the Android: disgust, anger, negative, sadness, and fear are very unlikely to have occured by accident
  # iPhone associated with no particular sentiments


# Which words are causing the above conclusion?
android_iphone_or %>% inner_join(nrc) %>%
  filter(sentiment == "disgust" & Android + iPhone > 10) %>%
  arrange(desc(or))

# A tibble: 20 x 5
# word       Android iPhone  or  sentiment
#  <chr>        <dbl> <dbl> <dbl>  <chr>    
# 1 mess         15    2    5.41   disgust  
# 2 finally      12    2    4.36   disgust  
# 3 unfair       12    2    4.36   disgust  
# 4 bad         104   26    3.45   disgust  
# 5 lie          13    3    3.37   disgust  
# 6 terrible     31    8    3.24   disgust  
# 7 lying         9    3    2.37   disgust  
# 8 waste        12    5    1.98   disgust  
# 9 phony        21    9    1.97   disgust  
# 10 illegal     32   14    1.96   disgust  
# 11 nasty       14    6    1.95   disgust  
# 12 pathetic    11    5    1.82   disgust  
# 13 horrible    14    7    1.69   disgust  
# 14 disaster    21   11    1.63   disgust  
# 15 winning     14    9    1.33   disgust  
# 16 liar         6    5    1.03   disgust  
# 17 dishonest   37   32    1.01   disgust  
# 18 john        24   21    0.994  disgust  
# 19 dying        6    6    0.872  disgust  
# 20 terrorism    9    9    0.872  disgust  

# Graphical viz of above (extended w/ other sentiments)
android_iphone_or %>% inner_join(nrc, by = "word") %>%
  mutate(sentiment = factor(sentiment, levels = log_or$sentiment)) %>%
  mutate(log_or = log(or)) %>%
  filter(Android + iPhone > 10 & abs(log_or) > 1) %>%
  mutate(word = reorder(word, log_or)) %>%
  ggplot(aes(word, log_or, fill = log_or < 0)) +
  facet_wrap(~sentiment, scales = "free_x", nrow = 2) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

