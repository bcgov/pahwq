source("data-raw/molar-absorption.R")
source("data-raw/o3.R")

usethis::use_data(o3, molar_absorption, internal = TRUE, overwrite = TRUE)
