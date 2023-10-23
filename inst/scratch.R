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

## Set these in `tuv_dir/AQUA/inp_aq`:
305 #reference lambda
0.018 # Sk
DOC <- 5	# g C m-3
kd_305(DOC)
#> 20.11

0.25 # depth, m

options(tuv_dir = "~/dev/TUV/V5.4")

PAH <- "anthracene"
delta_wavelength <- 1 # 1 nm between steps
delta_time <- 1 # 1 hr between steps
unit_conversion_constant <- 3.01e-08 # (mol photon cm3)/(𝝁W h nm L)
unit_conversion <- 100 # (𝝁W cm-2)/(W m-2)
time_multiplier <- 2 # results are for 1 24h period, we want 2)

tuv()

ma <- read.csv(system.file("data/molar_absorption.csv", package = "bcPAHwqg"))

res <- get_tuv_results(file = "out_irrad_y")

res$wl <- (res$wavelength_start + res$wavelength_end) / 2

res <- merge(res, ma[, c("wavelength", PAH)], by.x = "wl", by.y = "wavelength")

res_mat <- as.matrix(res)
Pabs_mat <- res_mat[, grepl("t_", colnames(res_mat))] * res$wl * res[[PAH]]

Pabs <- sum(Pabs_mat) *
  unit_conversion_constant *
  unit_conversion *
  time_multiplier *
  delta_wavelength *
  delta_time

# Calculate PLC50

NLC50 <- 450 # 𝝁g/L
TLM_a	<- 0.426
TLM_R	<- 0.511

NLC50 / (1 + Pabs^TLM_a/TLM_R)

