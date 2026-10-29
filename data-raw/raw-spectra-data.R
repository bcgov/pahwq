# Copyright 2026 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

# Cleans the molar absorption spectra (Appendix F-1 to F-5) and surrogate table
# (F-6) compiled and provided by CCME (2026). The files in
# data-raw/raw-spectra-data/ are unmodified exports of "Appendix
# F_PACs-spectra.xlsx", and include the solvent and literature source for each
# spectrum.
#
# Writes:
# - data-raw/molar-absorption-spectra.csv: one row per chemical and wavelength
# - data-raw/molar-absorption-surrogates.csv: one row per chemical and surrogate

library(readr)
library(dplyr)
library(tidyr)

spectra_names <- c(
  # F-1
  "Fluoranthenea" = "Fluoranthene",
  "Anthraceneb" = "Anthracene",
  "Pyrenec" = "Pyrene",
  "Benzo[a]pyrened" = "Benzo(a)pyrene",
  "Benzo[a]anthracenee" = "Benzo(a)anthracene",
  "Dibenzo[a,h]anthracenef" = "Dibenzo(a,h)anthracene",
  "Chryseneg" = "Chrysene",
  "Benzo[g,h,i]peryleneh" = "Benzo(g,h,i)perylene",
  "Benzo[b]anthracenei" = "Benzo(b)anthracene",
  "Benzo[e]pyrenej" = "Benzo(e)pyrene",
  # F-2
  "Phenanthrenea" = "Phenanthrene",
  "Naphthaleneb" = "Naphthalene",
  "Fluorenec" = "Fluorene",
  "Acenaphthened" = "Acenaphthene",
  "Benzo[b]fluorenee" = "Benzo(b)fluorene",
  "Perylenef" = "Perylene",
  "Bezanthroneg" = "Benzanthrone",
  "Benzo[b]fluorantheneh" = "Benzo(b)fluoranthene",
  "Benzo[k]fluoranthenei" = "Benzo(k)fluoranthene",
  "Benzo[a]fluorene j" = "Benzo(a)fluorene",
  # F-3
  "1-methylnaphthalenea" = "1-Methylnaphthalene",
  "2,6-dimethylnaphthaleneb" = "2,6-Dimethylnaphthalene",
  "1,6,7-trimethylnaphthalenec" = "1,6,7-Trimethylnaphthalene",
  "9-methylphenanthrened" = "9-Methylphenanthrene",
  "9-methylanthracenee" = "9-Methylanthracene",
  "9,10-dimethylanthracenee" = "9,10-Dimethylanthracene",
  "1-methylpyrenef" = "1-Methylpyrene",
  "1-methylchryseneg" = "1-Methylchrysene",
  # F-4
  "Benzothiophenea" = "Benzothiophene",
  "Dibenzothiophene b" = "Dibenzothiophene",
  "Dibenzofuranc" = "Dibenzofuran",
  "Acenaphthylened" = "Acenaphthylene",
  "Carbazolee" = "Carbazole",
  "Indeno[1,2,3-c,d]pyrenef" = "Indeno(1,2,3-cd)pyrene",
  "Reteneg" = "Retene",
  "Acridineh" = "Acridine",
  # F-5
  "Quinolinea" = "Quinoline"
)

read_spectra_table <- function(table) {
  path <- file.path("data-raw/raw-spectra-data", paste0(table, ".csv"))
  header <- trimws(unlist(read_csv(
    path,
    skip = 2,
    n_max = 1,
    col_names = FALSE,
    show_col_types = FALSE
  )))

  unmapped <- setdiff(header[-1], names(spectra_names))
  if (length(unmapped)) {
    stop("Unmapped spectrum names in ", table, ": ", toString(unmapped))
  }

  read_csv(
    path,
    skip = 4,
    col_names = c("wavelength", spectra_names[header[-1]]),
    col_types = cols(.default = col_character()),
    show_col_types = FALSE
  ) |>
    filter(grepl("^[0-9]+$", wavelength)) |>
    pivot_longer(
      -wavelength,
      names_to = "chemical",
      values_to = "molar_absorption",
      values_drop_na = TRUE
    ) |>
    mutate(
      wavelength = as.integer(wavelength),
      molar_absorption = as.numeric(molar_absorption),
      table = table
    )
}

spectra <- paste0("F-", 1:5) |>
  lapply(read_spectra_table) |>
  bind_rows() |>
  arrange(chemical, wavelength)

surrogates <- read_csv(
  "data-raw/raw-spectra-data/F-6.csv",
  skip = 3,
  col_names = c("chemical", "surrogate"),
  show_col_types = FALSE
) |>
  filter(!is.na(chemical)) |>
  mutate(
    chemical = trimws(chemical),
    chemical = sub("^(C[1-4]) ", "\\1-", chemical),
    chemical = sub(
      "Benzo[a]anthracenes",
      "Benz(a)anthracenes",
      chemical,
      fixed = TRUE
    ),
    chemical = chartr("[]", "()", chemical)
  ) |>
  separate_longer_delim(surrogate, "/") |>
  mutate(
    surrogate = trimws(surrogate),
    surrogate = sub("flouranthene", "fluoranthene", surrogate),
    surrogate = sub("pyene$", "pyrene", surrogate),
    surrogate = unname(
      spectra_names[match(
        sanitize_names(surrogate),
        sanitize_names(spectra_names)
      )]
    )
  )

pacs <- read_csv(
  "data-raw/log-KOW.csv",
  col_select = 1,
  show_col_types = FALSE,
  name_repair = "unique_quiet"
)[[1]]

stopifnot(
  !anyDuplicated(spectra[c("chemical", "wavelength")]),
  !anyNA(spectra$molar_absorption),
  !anyNA(surrogates$surrogate),
  !anyDuplicated(surrogates),
  sanitize_names(spectra_names) %in% sanitize_names(pacs),
  sanitize_names(surrogates$chemical) %in% sanitize_names(pacs),
  !sanitize_names(surrogates$chemical) %in% sanitize_names(spectra$chemical),
  setequal(
    sanitize_names(pacs),
    sanitize_names(c(spectra$chemical, surrogates$chemical))
  )
)

write_csv(spectra, "data-raw/molar-absorption-spectra.csv")
write_csv(surrogates, "data-raw/molar-absorption-surrogates.csv")
