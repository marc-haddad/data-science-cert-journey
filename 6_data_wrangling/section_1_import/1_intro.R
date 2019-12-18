library(tidyverse)
library(dslabs)
getwd()
path = system.file("extdata", package="dslabs")
list.files(path)

# Example of finding path
filename = "murders.csv"
fullpath = file.path("extdata", filename)
fullpath

