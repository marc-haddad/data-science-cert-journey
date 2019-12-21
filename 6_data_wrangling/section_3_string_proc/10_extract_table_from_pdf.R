library(tidyverse)
library(dslabs)
library(readr)
library(rvest)
library(stringr)
library(pdftools)

data("research_funding_rates")

research_funding_rates %>% head()

# Download data
temp_file = tempfile()
url = "http://www.pnas.org/content/suppl/2015/09/16/1510159112.DCSupplemental/pnas.201510159SI.pdf"
download.file(url, temp_file)
txt = pdf_text(temp_file) # pdf_text() converts pdfs to strs
file.remove(temp_file)

txt %>% View() # We see that it is 2 char vectors, 1 for each page

# Page we want is the 2nd
raw_data_research_funding_rates = txt[2]

raw_data_research_funding_rates %>% head() # From this we see that every line in the page (incl table rows) is separated by newline \n

# Create list with each line being an element
tab = str_split(raw_data_research_funding_rates, "\n")

# There is only 1 element in the str, it contains list of all other strs, therefore:
tab = tab[[1]]
tab %>% head() 
# We see col names located in rows [3] and [4]
the_names_1 = tab[3]
the_names_2 = tab[4]

# Extracting and combining col names from the 2 lines
the_names_1 = the_names_1 %>%
  str_trim() %>%
  str_replace_all(",\\s.", "") %>% # ",\\s." means "find pattern comma, space, followed by ANY char (represented as ".")
  str_split("\\s{2,}", simplify = TRUE) # \\s{2,} means find at least 2 or more spaces and split by them                                        
                                        # i.e Leave only one space between each match; this way, this is due to the existence of the col "Success rates"
the_names_1

the_names_2 = the_names_2 %>%
  str_trim() %>%
  str_split("\\s+", simplify = TRUE) # No need for 2nd step above b/c there are no extra chars appended to each word
the_names_2

# Now we combine both to generate 1 name per col
tmp_names = str_c(rep(the_names_1, each = 3), the_names_2[-1], sep = "_") 
# Above, we replicated (rep) each name in the_names_1 then
# appended the_names_2 (without the entry "Discipline"), separated by "_":

# [1] "Applications_Total" "Applications_Men"   "Applications_Women"
# [4] "Awards_Total"       "Awards_Men"         "Awards_Women"      
# [7] "Success_Total"      "Success_Men"        "Success_Women"     
# [10] "rates_Total"        "rates_Men"          "rates_Women"   

the_names = c(the_names_2[1], tmp_names) %>% # We add "Discipline" field back
  str_to_lower() %>%
  str_replace_all("\\s", "_") # Here we replace space in "Success rates" w/ "_"
the_names


# Getting the actual data 

# By examining the "tab" object we find that the data we want is in lines 6-14
new_research_funding_rates = tab[6:14] %>%
  str_trim() %>%
  str_split("\\s{2,}", simplify = TRUE) %>%
  data.frame(stringsAsFactors = FALSE) %>%
  setNames(the_names) %>%
  mutate_at(-1, parse_number) # Here we convert all cols (except col 1) from str format to int
new_research_funding_rates %>% head()


# Final check showing that the new table created is accurate
identical(research_funding_rates, new_research_funding_rates)


