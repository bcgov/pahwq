source("data-raw/molar-absorption.R")
source("data-raw/nlc50.R")
source("data-raw/o3.R")
source("data-raw/aerosol-optical-thickness.R")

usethis::use_data(
  o3,
  aerosol,
  molar_absorption,
  nlc50_lookup,
  internal = TRUE,
  overwrite = TRUE
)
