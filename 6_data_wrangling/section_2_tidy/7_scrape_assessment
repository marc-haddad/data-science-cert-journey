library(rvest)

url <- "https://web.archive.org/web/20181024132313/http://www.stevetheump.com/Payrolls.htm"
h <- read_html(url)
nodes = html_nodes(h, "table")
html_table(nodes[[1]])
html_table(nodes[[2]])
html_table(nodes[[3]])
html_table(nodes[[4]])

tab_1 = html_table(nodes[[10]]) %>% select(-X1) %>%
  setNames(c("team", "payroll", "avg")) %>%
  slice(-1)


tab_2 = html_table(nodes[[19]]) %>% setNames(c("team", "payroll", "avg")) %>%
  slice(-1)

combined = full_join(tab_1, tab_2, by = "team")
str(combined)


url <- "https://en.wikipedia.org/w/index.php?title=Opinion_polling_for_the_United_Kingdom_European_Union_membership_referendum&oldid=896735054"
h = read_html(url)
nodes = html_nodes(h, "table")
nodes

head(html_table(nodes[[5]], fill = TRUE))



