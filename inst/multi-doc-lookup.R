library(dplyr)
library(purrr)
library(readr)
library(pahwq)

# Find all chemicals for which we have required chemical properties, and spectra
chems <- intersect(
  pahwq:::nlc50_lookup$chemical,
  pahwq:::molar_absorption$chemical
)

# FRESHWATER -------------------------------------------------------------------

# Freshwater: Basin Lake, Saskatchewan
# Lat: 52.60453
# Long: -105.28278
# Elevation: 515m
# Depth: 0.25m
# Date: 2024-06-21
loc_fw <- c(lat = 52.60453, lon = -105.28278, elev = 515)

# Set a range of DOC values
fw_docs <- c(0.2, seq(0.5, 61.5, 1))

# Run the tuv model for each DOC value; store in a list
tuv_res_fw <- map(set_names(fw_docs), \(x) {
  tuv(
    depth_m = 0.50,
    lat = loc_fw["lat"],
    lon = loc_fw["lon"],
    elev_m = loc_fw["elev"],
    date = as.Date("2024-06-21"),
    DOC = x,
    quiet = TRUE
  )
})

# for each tuv result, calculate the benchmarks and guidelines, and
# assemble into a table
doc_pah_fw_lookup <- map(tuv_res_fw, \(x) {
  pb_multi(x, chems)
}) |>
  list_rbind(names_to = "DOC") |>
  select(chemical = pah, DOC, everything()) |>
  mutate(
    chemical = tools::toTitleCase(chemical),
    DOC = as.numeric(DOC)
  ) |>
  arrange(chemical, DOC)

# MARINE -----------------------------------------------------------------------

# Marine: Tofino, BC
# Lat: 49.15085
# Lon: -125.91427
# Elevation: 0m
# Depth: 0.01m
# Date: 2024-06-21
loc_marine <- c(lat = 49.15085, lon = -125.91427, elev = 0)

# Only need to run tuv once for marine, since Kd is not dependent on DOC
tuv_res_marine <- tuv(
  depth_m = 0.01,
  lat = loc_marine["lat"],
  lon = loc_marine["lon"],
  elev_m = loc_marine["elev"],
  date = as.Date("2024-06-21"),
  aq_env = "marine",
  quiet = TRUE
)

# Calculate benchmarks and guidelines
pah_marine_lookup <- pb_multi(tuv_res_marine, chems) |>
  select(chemical = pah, everything()) |>
  mutate(
    chemical = tools::toTitleCase(chemical)
  ) |>
  arrange(chemical)

# Save to file
dir.create("inst/doc-guideline-lookup")
write_csv(
  doc_pah_fw_lookup,
  "inst/doc-guideline-lookup/PAH-DOC_freshwater-guidelines.csv"
)
write_csv(
  pah_marine_lookup,
  "inst/doc-guideline-lookup/PAH_marine-guidelines.csv"
)
