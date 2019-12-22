library(rvest)
library(tidyverse)
library(stringr)
url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
tab <- read_html(url) %>% html_nodes("table")
polls <- tab[[5]] %>% html_table(fill = TRUE)

polls %>% head()

filtered_polls = polls %>%
  setNames(c("dates", "remain", "leave", "undecided", "lead", "samplesize", "pollster", "poll_type", "notes")) %>%
  slice(-1) %>% filter(grepl("%", remain))
# Find num of rows
str(filtered_polls)

# Convert "remain" col into proportion b/w 0 & 1
as.numeric(str_replace(filtered_polls$remain, "%", ""))/100
# Or
parse_number(filtered_polls$remain)/100


# Replace "N/A" in "undecided" w/ 0
str_replace(filtered_polls$undecided, "N/A", "0")

# Plug in regex that would extract end day from format "start-end Month"
temp = str_extract_all(filtered_polls$dates, "\\d+\\s[a-zA-Z]+")
end_date <- sapply(temp, function(x) x[length(x)]) # take last element (handles polls that cross month boundaries)
temp

temp = str_extract_all(filtered_polls$dates, "[0-9]+\\s[a-zA-Z]+")
end_date <- sapply(temp, function(x) x[length(x)]) # take last element (handles polls that cross month boundaries)
temp

temp = str_extract_all(filtered_polls$dates, "\\d{1,2}\\s[a-zA-Z]+")
end_date <- sapply(temp, function(x) x[length(x)]) # take last element (handles polls that cross month boundaries)
temp

temp = str_extract_all(filtered_polls$dates, "\\d+\\s[a-zA-Z]{3,5}")
end_date <- sapply(temp, function(x) x[length(x)]) # take last element (handles polls that cross month boundaries)
temp
