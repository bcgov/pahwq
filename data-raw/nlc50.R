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

## Supplemental data from:
# McGrath, J.A., Fanelli, C.J., Di Toro, D.M., Parkerton, T.F., Redman, A.D.,
# Paumen, M.L., Comber, M., Eadsforth, C.V. and den Haan, K. (2018),
# Re-evaluation of target lipid model–derived HC5 predictions for hydrocarbons.
# Environ Toxicol Chem, 37: 1579-1593. https://doi.org/10.1002/etc.4100
#
# and:
# McGrath, J., Getzinger, G., Redman, A.D., Edwards, M., Martin Aparicio, A. and
# Vaiopoulou, E. (2021), Application of the Target Lipid Model to Assess
# Toxicity of Heterocyclic Aromatic Compounds to Aquatic Organisms. Environ
# Toxicol Chem, 40: 3000-3009. https://doi.org/10.1002/etc.5194

library(readr)

nlc50 <- read_csv("data-raw/nlc50_lookup.csv")

# Add the Cx- prefix to the second chemical in the combo rows
nlc50$chemical <- tolower(gsub("^(C[1-4][-0]+)(.+)/(.+)", "\\1\\2/\\1\\3", nlc50$chemical))

nlc50_lookup <- tidyr::separate_longer_delim(nlc50, "chemical", "/")

# replace square brackets with parentheses and benz with benzo
nlc50_lookup$chemical <- sanitize_names(nlc50_lookup$chemical)

nlc50_lookup
