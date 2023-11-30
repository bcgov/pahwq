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

#' Calculate the Light absorption of a PAH from results of the TUV model.
#'
#' @param tuv_results data.frame of TUV results
#' @param PAH name of PAH to calculate light absorption for
#' @param time_delta the number of hours between each time step in the TUV
#'   results
#' @param time_multiplier multiplier to get the total exposure time. I.e., if
#'   the tuv_results contains 24 hours of data, and you need a 48 exposure, the
#'   multiplier would be 2. (this is the default)
#'
#' @return The value of `Pabs` for the TUV results.
#' @export
p_abs <- function(tuv_results, PAH, time_delta = 1, time_multiplier = 2) {

  if (!inherits(tuv_results, c("tuv_results", "data.frame"))) {
    stop("tuv_results must be a data.frame of class 'tuv_results'", call. = FALSE)
  }

  if (!PAH %in% molar_absorption$PAH) {
    stop(
      "PAH must be one of:\n  ",
      paste(unique(molar_absorption$PAH), collapse = "\n  "),
      call. = FALSE
    )
  }

  delta_wavelength <- max(diff(tuv_results$wl))

  # conversion constants from Appendix D of ARIS report
  unit_conversion_constant <- 3.01e-08 # (mol photon cm3)/(uW h nm L). Eq 3-2
  unit_conversion <- 100 # (uW cm-2)/(W m-2). TUV output to Eq 3-2 units

  pah_ma <- molar_absorption[
    molar_absorption$PAH == PAH,
    c("wavelength", "molar_absorption")
  ]

  tuv_results <- merge(
    tuv_results,
    pah_ma,
    by.x = "wl",
    by.y = "wavelength"
  )

  res_mat <- as.matrix(tuv_results)

  # Eq 3-2, ARIS report
  Pabs_mat <- res_mat[, grepl("t_", colnames(res_mat))] *
    res_mat[, "wl"] * # wavelength
    res_mat[, "molar_absorption"] # molar absorption of PAH

  sum(Pabs_mat) *
    unit_conversion_constant *
    unit_conversion *
    delta_wavelength *
    time_delta *
    time_multiplier
}

#' Calculate the PLC50 for a given Pabs and NLC50.
#'
#' PLC50 is the LC50 of a phototoxic PAH based on calculations of site-specific
#' or field-level light absorption.
#'
#' You can either supply a specific PAH, so the NLC50 can be looked up for that chemical,
#' or supply a NLC50 value directly.
#'
#' @param p_abs light absorption, calculated from `p_abs()`
#' @param pah The PAH of interest, which is used to look up the NLC50.
#' @param NLC50 (optional) the narcotic toxicity (i.e., in the absence of light)
#'   of the PAH in ug/L. If supplied, takes precedence over the PAH lookup.
#'
#' @return the PLC50 of the PAH.
#' @export
#'
#' @examples
#' plc_50(590, pah = "Benzo[a]pyrene")
#' plc_50(590, NLC50 = 450)
plc_50 <- function(p_abs, pah = NULL, NLC50 = NULL) {

  NLC50 <- NLC50 %||%
    nlc50(pah) %||%
    stop("You must provide a valid 'pah' or supply your own NLC50 value", call. = FALSE)

  # a' and R' from Marzooghi et al 2017
  TLM_a	<- 0.426
  TLM_R	<- 0.511

  # Eqn 2-2, ARIS report
  NLC50 / (1 + p_abs^TLM_a/TLM_R)
}

#' Calculate the NLC50 value for a PAH using the Target Lipid Model (TLM)
#'
#' This uses the equation and default values from McGrath et al. 2018.
#'
#' @param pah The PAH of interest
#' @param slope Slope in Equation 1 in McGrath et al. 2018. Default `-0.94`.
#' @param HC5 The critical target lipid body burden above which 95% of species
#'    should be protected in μmol/g octanol. Default `9.3`.
#'
#' @return NLC50 value, in ug/L
#' @export
#' @references
#'  McGrath, J.A., Fanelli, C.J., Di Toro, D.M., Parkerton, T.F., Redman, A.D.,
#'  Paumen, M.L., Comber, M., Eadsforth, C.V. and den Haan, K. (2018),
#'  Re-evaluation of target lipid model–derived HC5 predictions for hydrocarbons.
#'  Environ Toxicol Chem, 37: 1579-1593. https://doi.org/10.1002/etc.4100
#'
#' @examples
#' nlc50("anthracene")
nlc50 <- function(pah, slope = -0.94, HC5 = 9.3) {
  if (is.null(pah)) return(NULL)
  pah <- tolower(pah)

  if (!pah %in% tolower(nlc50_lookup$Chemical)) {
    stop("You have supplied an invalid PAH", call. = FALSE)
  }

  nlcdata <- nlc50_lookup[tolower(nlc50_lookup$Chemical) == pah, ]

  10^(slope * nlcdata$log_Kow + log10(HC5) + nlcdata$chem_class_corr_acute) *
    nlcdata$mol_w_g_mol * 1000
}
