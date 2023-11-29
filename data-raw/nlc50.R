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

library(readr)

nlc50 <- read_csv("data-raw/nlc50_mcgrath_2018.csv")

nlc50
