library(dslabs)
library(tidyverse)
library(lubridate)

data("polls_us_election_2016")
# So far we have worked w/ numeric, char, and logical vector types

# Dates is another data type/vector type

# Comp langs use something called an "epoch" as an anchor to calc dates as numbers
# (Usually set to 1970-01-01)
# Ex: Starting from our epoch, 2017-11-02 would be converted to day 17,204



# Date data type can be seen in polls dataset
polls_us_election_2016$startdate %>% head
# "2016-11-03" "2016-11-01" "2016-11-02" "2016-11-04" "2016-11-03"
# The above look like strs, however they have a data type of "date"
class(polls_us_election_2016$startdate) # "Date"



# Dates can be converted to numeric formats showing num of days since epoch
as.numeric(polls_us_election_2016$startdate) %>% head
# 17108 17106 17107 17109 17108 17108



# "lubridate" package: Contains helpful funcs to calc and manipulate dates/times

set.seed(2)
dates = sample(polls_us_election_2016$startdate, 10) %>% sort # Sample rand dates 
dates
#  [1] "2016-01-19" "2016-08-06" "2016-08-26" "2016-09-09" "2016-09-14"
#  [6] "2016-09-16" "2016-09-29" "2016-10-04" "2016-10-12" "2016-10-23"

data.frame(date = days(dates), # days(): Absolute numeric val of dates from epoch
           month = month(dates), # month(): Numeric val of month (1-12)
           day = day(dates), # day(): Numeric val of day (1-31)
           year = year(dates)) # year(): Numeric val of year (1970- )

#     date            month day year
# 1  16819d 0H 0M 0S     1  19 2016
# 2  17019d 0H 0M 0S     8   6 2016
# 3  17039d 0H 0M 0S     8  26 2016
# 4  17053d 0H 0M 0S     9   9 2016
# 5  17058d 0H 0M 0S     9  14 2016
# 6  17060d 0H 0M 0S     9  16 2016
# 7  17073d 0H 0M 0S     9  29 2016
# 8  17078d 0H 0M 0S    10   4 2016
# 9  17086d 0H 0M 0S    10  12 2016
# 10 17097d 0H 0M 0S    10  23 2016



# Extracting month labels:
month(dates, label = TRUE)
# [1] Jan Aug Aug Sep Sep Sep Sep Oct Oct Oct
 # 12 Levels: Jan < Feb < Mar < Apr < May < Jun < Jul < Aug < Sep < Oct < Nov < Dec


# Parsers convert any data type to dates
x = c(20090101, "2009-01-02", "2009 01 03", "2009-1-4",
      "2009-1, 5", "Created on 2009 1 6", "200901 !!! 07")

ymd(x) # ymd() = year, month, day
# "2009-01-01" "2009-01-02" "2009-01-03" "2009-01-04" "2009-01-05"
# "2009-01-06" "2009-01-07"

# Different combos of ymd() exist
x = "09/01/02"
ydm(x) # "2009-02-01"
myd(x) # "2001-09-02"
dmy(x) # "2002-01-09"
dym(x) # "2001-02-09"


# Dealing w/ time

# now() gives current time on sys, and can take an arg to specify timezone
now() # Current time for my timezone
now("GMT") # Current time in London

OlsonNames() # Displays the names of all timezones

# Extract hours, mins, secs
now() %>% hour() # 21
now() %>% minute() # 8
now() %>% second() # 54.0602

# hms() is like ymd(), but for time
x = c("12:34:56")
hms(x) # "12H 34M 56S"

# We can also parse strs that have both date and time
x = "Nov/2/2012 12:34:56"
mdy_hms(x) # "2012-11-02 12:34:56 UTC"

