# Read first 3 lines of csv
read_lines("extdata/murders.csv", n_max = 3)

dat = read_csv("extdata/murders.csv")

head(dat)

# Diff. b/w tidy (above) and R Base
dat2 = read.csv("extdata/murders.csv")
class(dat2) # Importing with R Base results in DF
class(dat) # Importing with tidy results in tible
# Another diff., chars are converted to factors in dat2


