# Copyright 2023 Province of British Columbia
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

# Molar absorption coefficients (L/mol/cm) for PACs at wavelengths 280-500 nm,
# from the measured spectra (Appendix F-1 to F-5) and surrogate table (F-6)
# compiled and provided by CCME (2026). These are cleaned by
# data-raw/raw-spectra-data.R, which lists the literature sources.
#
# PACs without a measured spectrum use the mean of their surrogates' spectra at
# each wavelength. Where a surrogate has no value at a wavelength, the mean is
# of the surrogates that do. This reproduces CCME's averaged-spectra.csv.

library(readr)
library(dplyr)
library(tidyr)

source("data-raw/helpers.R")

measured <- read_csv(
  "data-raw/molar-absorption-spectra.csv",
  show_col_types = FALSE
) |>
  rename(pac_id = chemical) |>
  mutate(
    pac_id = sanitize_names(pac_id),
    wavelength = as.numeric(wavelength)
  ) |>
  select(wavelength, pac_id, molar_absorption)

surrogates <- read_csv(
  "data-raw/molar-absorption-surrogates.csv",
  show_col_types = FALSE
) |>
  rename(pac_id = chemical) |>
  mutate(pac_id = prefix_groups(pac_id)) |>
  separate_longer_delim(pac_id, "/") |>
  mutate(across(everything(), sanitize_names))

surrogate_spectra <- surrogates |>
  inner_join(
    measured,
    by = c("surrogate" = "pac_id"),
    relationship = "many-to-many"
  ) |>
  summarise(
    molar_absorption = mean(molar_absorption),
    .by = c(pac_id, wavelength)
  ) |>
  left_join(
    summarise(
      surrogates,
      surrogate = paste(surrogate, collapse = ", "),
      .by = pac_id
    ),
    by = "pac_id"
  )

molar_absorption <- bind_rows(measured, surrogate_spectra) |>
  arrange(pac_id, wavelength)

ccme_averages <- local({
  path <- "data-raw/raw-spectra-data/averaged-spectra.csv"
  header <- unlist(read_csv(
    path,
    skip = 1,
    n_max = 1,
    col_names = FALSE,
    show_col_types = FALSE
  ))[-1]
  sets <- vapply(
    strsplit(sub("flouranthene", "fluoranthene", header), "/"),
    \(x) paste(sort(sanitize_names(trimws(x))), collapse = ", "),
    character(1)
  )
  read_csv(
    path,
    skip = 3,
    col_names = c("wavelength", sets),
    show_col_types = FALSE
  ) |>
    pivot_longer(
      -wavelength,
      names_to = "surrogate_set",
      values_to = "ccme",
      values_drop_na = TRUE
    )
})

# Check against provided surrogate averages from CCME
ccme_check <- surrogates |>
  summarise(
    surrogate_set = paste(sort(surrogate), collapse = ", "),
    .by = pac_id
  ) |>
  inner_join(
    ccme_averages,
    by = "surrogate_set",
    relationship = "many-to-many"
  ) |>
  left_join(molar_absorption, by = c("pac_id", "wavelength"))

multi_surrogate_pacs <- surrogates$pac_id[
  duplicated(surrogates$pac_id)
]

stopifnot(
  !anyNA(molar_absorption$molar_absorption),
  !anyDuplicated(molar_absorption[c("pac_id", "wavelength")]),
  all(molar_absorption$wavelength >= 280 & molar_absorption$wavelength <= 500),
  all(surrogates$surrogate %in% measured$pac_id),
  setequal(pac_lookup$pac_id, molar_absorption$pac_id),
  setequal(unique(ccme_check$pac_id), multi_surrogate_pacs),
  !anyNA(ccme_check$molar_absorption),
  all(abs(ccme_check$molar_absorption - ccme_check$ccme) <= 0.5)
)

molar_absorption
