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

# Molar absorption coefficients (L/mol/cm) for multiple PAHs at different wavelengths.
# Taken from Molar absorption spectra \eqn{\epsilon}(\eqn{\lambda}) at different
# wavelength \eqn{\lambda} (nm) in:
#
# Karcher W, Fordham R, Dubois J, Glaude P, Ligthart J. 1985. Spectral atlas of
# polycyclic 489 aromatic compounds. D. Reidel Publishing Company: Dordrecht.
#
# AND
#
# Friedel RA, Orchin M. 1952. Ultraviolet Spectra of Aromatic Compounds. Wiley New 491 York.

library(readr)
library(dplyr)
library(tidyr)

ma_SW31 <- read_csv("data-raw/molar_absorption_SW3-1.csv")
ma_SW32 <- read_csv("data-raw/molar_absorption_SW3-2.csv")
ma_SW33 <- read_csv("data-raw/molar_absorption_SW3-3.csv")
ma_SW34 <- read_csv("data-raw/molar_absorption_SW3-4.csv")

molar_absorption <- left_join(ma_SW31, ma_SW32, by = "wavelength") |>
  left_join(ma_SW33, by = "wavelength") |>
  left_join(ma_SW34, by = "wavelength") |>
  pivot_longer(cols = -wavelength, names_to = "chemical", values_to = "molar_absorption",
               values_drop_na = TRUE) |>
  mutate(chemical = sanitize_names(chemical))

if (anyNA(molar_absorption)) {
  stop("NA values found in molar absorption data.")
}

if (any(molar_absorption$wavelength > 500 | molar_absorption$wavelength < 280)) {
  stop("Wavelengths outside of 280-500 nm range found in molar absorption data.")
}
