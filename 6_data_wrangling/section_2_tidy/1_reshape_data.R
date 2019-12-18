library(dslabs)
library(tidyverse)
data("gapminder")


tidy_data = gapminder %>% 
  filter(country %in% c("South Korea", "Germany")) %>%
  select(country, year, fertility)
head(tidy_data)

tidy_data %>%
  ggplot(aes(year, fertility, color = country)) +
  geom_point()

path = system.file("extdata", package = "dslabs")
filename = file.path(path, "fertility-two-countries-example.csv")
wide_data = read_csv(filename)

# The wide data above needs to be reshaped
# gather() transforms wide data into tidy data
# First arg of gather(): sets the name of new column to be converted from horiz.
# Second arg of gather(): sets the name of the new column that represents the data in the cells.
# Third arg of gather(): The columns/range of the wide data we want to convert
new_tidy_data = wide_data %>%
  gather(year, fertility, `1960`:`2015`)

# Quicker implementation of above: specify which columns NOT to gather
new_tidy_data = wide_data %>%
  gather(year, fertility, -country)

# In the new_tidy_data, the years are automatically stored as chars
# We need to change them to ints like in tidy_data
# gather() has arg to convert
new_tidy_data = wide_data %>%
  gather(year, fertility, -country, convert = TRUE)

# spread() is the opposite of gather()
# First arg: column that contains data we want to become multiple cols.
# Second arg: The data to be placed within the new cols
new_wide_data = new_tidy_data %>% spread(year, fertility)
select(new_wide_data, country, `1960`:`1967`)




