library(rvest)

url = "http://en.wikipedia.org/wiki/Murder_in_the_United_States_by_state"
h = read_html(url)
class(h)

# html_nodes() extracts all tags of a specified type
# html_node() extracts the first tag of a specified type

tab = h %>% html_nodes("table")
tab = tab[[2]]
tab

# html_table() converts html to DF
html_table(tab)
# Or
tab = tab %>% html_table()
class(tab) # DF

tab = tab %>% setNames(c("state", "population", "total", "murders", "gun_murders", "gun_ownership"
                         , "total_rate", "murder_rate", "gun_murder_rate"))
head(tab)
