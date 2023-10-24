## code to prepare `DATASET` dataset goes here

molar_absorption <- read.csv("data-raw/molar_absorption.csv")
usethis::use_data(molar_absorption, internal = TRUE, overwrite = TRUE)
