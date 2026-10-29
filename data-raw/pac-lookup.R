# Copyright 2023 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

# Chemical class, log KOW (EPI Suite KOWWIN) and molecular weight for 70 PACs,
# compiled and provided by CCME (2026). The PACs listed in exclude-from-app.csv
# are retained in the package but not displayed in the Shiny app.

library(readr)
library(dplyr)

# Uppercase the first letter, after any locant prefix (e.g., "1,2-")
capitalize_pac <- function(x) {
  sub("^([0-9,]+-)?([a-z])", "\\1\\U\\2", x, perl = TRUE)
}

pacs <- read_csv(
  "data-raw/log-KOW.csv",
  col_select = 1:4,
  show_col_types = FALSE,
  name_repair = "unique_quiet"
) |>
  setNames(c("pac", "chem_class", "log_kow", "mol_weight")) |>
  mutate(pac = capitalize_pac(pac))

exclude_from_app <- read_csv(
  "data-raw/exclude-from-app.csv",
  col_names = c("n", "pac"),
  show_col_types = FALSE
) |>
  mutate(pac = capitalize_pac(pac))

stopifnot(
  nrow(pacs) == 70,
  !anyDuplicated(sanitize_names(pacs$pac)),
  all(sanitize_names(exclude_from_app$pac) %in% sanitize_names(pacs$pac))
)

pac_lookup <- pacs |>
  mutate(
    app = !sanitize_names(pac) %in% sanitize_names(exclude_from_app$pac),
    # Add the Cx- prefix to the second chemical in the combo rows
    chemical = gsub("^(C[1-4]-)(.+)/(.+)", "\\1\\2/\\1\\3", pac),
    ref = "EPI Suite KOWWIN, via CCME (2026)"
  ) |>
  tidyr::separate_longer_delim("chemical", "/") |>
  mutate(chemical = sanitize_names(chemical)) |>
  select(chemical, pac, chem_class, log_kow, mol_weight, app, ref)

stopifnot(
  sum(!duplicated(pac_lookup$pac[pac_lookup$app])) == 47,
  !anyDuplicated(pac_lookup$chemical)
)

pac_lookup
