devtools::load_all()
source("data-raw/molar-absorption.R")
source("data-raw/nlc50.R")
source("data-raw/marine-kd.R")

## Only run these if you've updated them, they take a long time to run
# source("data-raw/o3.R")
# source("data-raw/aerosol-optical-thickness.R")

usethis::use_data(
  o3,
  aerosol,
  molar_absorption,
  nlc50_lookup,
  marine_kd_models,
  marine_kd_polygons,
  internal = TRUE,
  overwrite = TRUE
)
