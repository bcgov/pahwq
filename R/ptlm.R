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

#' Calculate the total light absorption of a PAH using the results of the TUV model
#'
#' @param tuv_results data.frame of TUV results
#' @param pah name of PAH to calculate light absorption for
#' @param time_multiplier multiplier to get the total exposure time. I.e., if
#'   the tuv_results contains 24 hours of data, and you need a 48h exposure, the
#'   multiplier would be 2. (this is the default)
#'
#' @return The value of `Pabs` for the TUV results.
#' @export
p_abs <- function(tuv_results, pah, time_multiplier = 2) {

  if (!inherits(tuv_results, c("tuv_results", "data.frame"))) {
    stop("tuv_results must be a data.frame of class 'tuv_results'", call. = FALSE)
  }

  pah <- sanitize_names(pah)

  if (!pah %in% molar_absorption$chemical) {
    stop(
      "pah must be one of:\n  ",
      paste(unique(molar_absorption$chemical), collapse = "\n  "),
      call. = FALSE
    )
  }

  time_delta <- calc_time_delta(tuv_results)

  delta_wavelength <- max(diff(tuv_results$wl))

  # conversion constants from Appendix D of ARIS report
  unit_conversion_constant <- 3.01e-08 # (mol photon cm3)/(uW h nm L). Eq 3-2
  unit_conversion <- 100 # (uW cm-2)/(W m-2). TUV output to Eq 3-2 units

  pah_ma <- molar_absorption[
    molar_absorption$chemical == pah,
    c("wavelength", "molar_absorption")
  ]

  report_surrogate(pah)

  tuv_results <- merge(
    tuv_results,
    pah_ma,
    by.x = "wl",
    by.y = "wavelength"
  )

  res_mat <- as.matrix(tuv_results)

  # Eq 3-2, ARIS report
  Pabs_mat <- res_mat[, grepl("t_", colnames(res_mat))] * # irradiance
    res_mat[, "wl"] * # wavelength
    res_mat[, "molar_absorption"] # molar absorption of pah

  sum(Pabs_mat) *
    unit_conversion_constant *
    unit_conversion *
    delta_wavelength *
    time_delta *
    time_multiplier
}

report_surrogate <- function(pah) {
  surrogate <- molar_absorption$surrogate[
    molar_absorption$chemical == pah &
      !is.na(molar_absorption$surrogate)
    ]
  if (length(surrogate) > 0) {
    message("No measured absorption spectra for ", pah, ". Using ", surrogate[1],
            " as a surrogate")
  }
}

#' Calculate the PLC50 for a given P~abs~ and PAH chemical using the PTLM
#'
#' PLC50 is the LC50 of a phototoxic PAH based on calculations of site-specific
#' or field-level light absorption.
#'
#' You can either supply a specific PAH, so the NLC50 can be calculated for
#' that chemical, or supply a NLC50 value directly.
#'
#' @param x light absorption, calculated from [p_abs()], or a `tuv_results` data.frame
#'   from [tuv()] or [get_tuv_results()].
#' @param pah The PAH of interest, which is used to look up the NLC50.
#' @param NLC50 (optional) the narcotic toxicity (i.e., in the absence of light)
#'   of the PAH in ug/L. If supplied, takes precedence over the PAH lookup.
#'
#' @return the PLC50 of the PAH in ug/L.
#' @export
#'
#' @references
#' Marzooghi, S., Finch, B.E., Stubblefield, W.A., Dmitrenko, O., Neal, S.L. and
#' Di Toro, D.M. (2017), Phototoxic target lipid model of single polycyclic
#' aromatic hydrocarbons. Environ Toxicol Chem, 36: 926-937.
#' https://doi.org/10.1002/etc.3601
#'
#' @examples
#' plc50(590, pah = "Benzo[a]pyrene")
#' plc50(590, NLC50 = 450)
plc50 <- function(x, pah = NULL, NLC50 = NULL) {
  pah <- sanitize_names(pah)
  UseMethod("plc50")
}

#' @export
plc50.default <- function(x, pah = NULL, NLC50 = NULL) {
  stop("plc50 can only be called on a single numeric value (calculated via `p_abs()`)
       or a data.frame of class `tuv_results`", call. = FALSE)
}

#' @export
plc50.tuv_results <- function(x, pah = NULL, NLC50 = NULL) {
  pabs <- p_abs(x, pah = pah)
  plc50(pabs, pah = pah, NLC50 = NLC50)
}

#' @export
plc50.numeric <- function(x, pah = NULL, NLC50 = NULL) {

  NLC50 <- NLC50 %||%
    nlc50(pah) %||%
    stop("You must provide a valid 'pah' or supply your own NLC50 value", call. = FALSE)

  # a' and R' from Marzooghi et al 2017
  TLM_a	<- 0.426
  TLM_R	<- 0.511

  # Eqn 2-2, ARIS report
  NLC50 / (1 + x^TLM_a/TLM_R)
}

#' Calculate the NLC50 value for a PAH or HAC using the Target Lipid Model (TLM)
#'
#' This uses the equation and default values from McGrath et al. 2018.
#'
#' @param chemical The chemical (a HAC or PAH) of interest
#' @param slope The slope in Equation 1 in McGrath et al. 2018. The default
#'   value is -0.94, which is taken from Table 3 in McGrath et al. 2018. It
#'   is not recommended to adjust this without good justification.
#' @param HC5 The 5th percentile of the SSD of critical body burdens predicted
#'   to be hazardous for no more than 5% of the species. Default value is 9.3
#'   umol/g, which was calculated using Equation 3 in McGrath et al 2018. It is
#'   not recommended to adjust this without good justification.
#' @param dc_pah Chemical class correction (Δc) for PAHs, as reported in McGrath et al. 2018.
#' @param dc_hac Chemical class correction (Δc) for HACs, as reported in McGrath et al. 2021.
#'
#' @return NLC50 value, in ug/L
#' @export
#' @references
#'  McGrath, J.A., Fanelli, C.J., Di Toro, D.M., Parkerton, T.F., Redman, A.D.,
#'  Paumen, M.L., Comber, M., Eadsforth, C.V. and den Haan, K. (2018),
#'  Re-evaluation of target lipid model–derived HC5 predictions for hydrocarbons.
#'  Environ Toxicol Chem, 37: 1579-1593. https://doi.org/10.1002/etc.4100
#'
#'  McGrath, J., Getzinger, G., Redman, A.D., Edwards, M., Martin Aparicio, A.
#'  and Vaiopoulou, E. (2021), Application of the Target Lipid Model to Assess
#'  Toxicity of Heterocyclic Aromatic Compounds to Aquatic Organisms. Environ
#'  Toxicol Chem, 40: 3000-3009. https://doi.org/10.1002/etc.5194
#'
#' @examples
#' nlc50("anthracene")
nlc50 <- function(chemical, slope = -0.94, HC5 = 9.3, dc_pah = -0.364,
                  dc_hac = -0.471) {
  if (is.null(chemical)) return(NULL)
  chemical <- sanitize_names(chemical)

  if (!chemical %in% nlc50_lookup$chemical) {
    stop("You have supplied an invalid chemical", call. = FALSE)
  }

  nlcdata <- nlc50_lookup[nlc50_lookup$chemical == chemical, ]

  if (nrow(nlcdata) != 1) {
    stop("More than one chemical matched", call. = FALSE)
  }

  dc <- ifelse(nlcdata$chem_class == "PAH", dc_pah, dc_hac)

  10^(slope * nlcdata$log_kow + log10(HC5) + dc) *
    nlcdata$mol_weight * 1000
}

calc_time_delta <- function(tuv_results) {
  inp_aq <- attr(tuv_results, "inp_aq")
  start <- as.numeric(inp_aq[["tstart, hours local time"]])
  stop <- as.numeric(inp_aq[["tstop, hours local time"]])
  steps <- as.numeric(inp_aq[["number of time steps"]])

  max(diff(seq(start, stop, length.out = steps)))
}
