# Read data directly from web

url = "https://raw.githubusercontent.com/rafalab/dslabs/master/inst/extdata/murders.csv"

dat = read_csv(url) # Read w/o download

download.file(url, "murders.csv") # Download to local files

# Using tmpfile() and tempdir()
tmp_filename = tempfile()
download.file(url, tmp_filename)
dat = read_csv(tmp_filename)
file.remove(tmp_filename)

url <- "http://mlr.cs.umass.edu/ml/machine-learning-databases/breast-cancer-wisconsin/wdbc.data"

data = read_csv(url, col_names = FALSE)
head(data)

url = "ftp://aftp.cmdl.noaa.gov/products/trends/co2/co2_annmean_mlo.txt"
co2_mauna_loa = read_table(url, skip = 56)
co2_mauna_loa = co2_mauna_loa %>% select(-"#")

