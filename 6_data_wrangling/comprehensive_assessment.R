library(tidyverse)
library(pdftools)
library(stringr)
options(digits = 3)

# Comprehensive data wrangling assessment: Hurricane Maria


fn <- system.file("extdata", "RD-Mortality-Report_2015-18-180531.pdf", package="dslabs")

# Create tidy dataset from above pdf
txt = pdf_text(fn) # Read in raw data
txt

# Split 9th table in data by \n
x = str_split(txt[[9]], "\n") 

# Isolate first entry for analysis
s = x[[1]]
str(s)

# Trim s
s = str_trim(s)
s

# Find row w/ header
header_index = str_which(s, "2015")[1]

# Extract month and col names from header
header = s[header_index]
header = str_split(header, "\\s+", simplify = TRUE)
month = header[,1]
header = header[,-1]
header

# Find the "Total" row in s, find its index
tail_index = str_which(s, "Total")
tail_index # 35

# Find rows w/ only one entry
(str_count(s, "\\d+") == 1) # 2


# Remove all identified problematic entries so far
s = s[(header_index + 1):(tail_index - 1)]
s = s[-7]
s = s[-4]
s

# Remove anything that isn't a num or a space
s = str_remove_all(s, "[^\\d\\s]") # ^ w/in [] means NOT.
s

# Convert s to a data matrix
s = str_split_fixed(s, "\\s+", n = 6)[,1:5]
s

# Give col names
class(s)
colnames(s) = c("Day", header)
s

# Convert vals to numeric
tab = s %>% data.frame(stringsAsFactors = FALSE) %>% 
  mutate_at(c("Day", "X2015", "X2016", "X2017", "X2018"), parse_number)
tab

# Mean death rates for the month of SEP
mean(tab$X2015) # 75.3
mean(tab$X2016) # 78.9
mean(tab$X2017[1:19]) # Before Maria: 83.7
mean(tab$X2017[20:30]) # After Maria: 122

# Change tab to tidy format
tab = tab %>% gather(year, deaths, -Day) %>%
  mutate(deaths = as.numeric(deaths))
tab
# Plot deaths v day
tab %>% filter(year != "X2018") %>%
  ggplot(aes(Day, deaths, color = year)) +
  geom_point() +
  geom_line() +
  geom_vline(xintercept = 20)







