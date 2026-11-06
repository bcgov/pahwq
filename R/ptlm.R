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

#' Calculate the total light absorption of a PAC using the results of the TUV model
#'
#' @param tuv_results data.frame of TUV results
#' @param pac name of PAC to calculate light absorption for, as a `pac_id` from
#'   [pac_list()]
#' @param time_multiplier multiplier to get the total exposure time. I.e., if
#'   the tuv_results contains 24 hours of data, and you need a 48h exposure, the
#'   multiplier would be 2. (this is the default)
#'
#' @return The value of `Pabs` for the TUV results.
#' @export
p_abs <- function(tuv_results, pac, time_multiplier = 2) {
  if (!inherits(tuv_results, c("tuv_results", "data.frame"))) {
    stop(
      "tuv_results must be a data.frame of class 'tuv_results'",
      call. = FALSE
    )
  }

  pac <- sanitize_names(pac)

  if (!pac %in% molar_absorption$pac_id) {
    stop(
      "pac must be one of:\n  ",
      paste(unique(molar_absorption$pac_id), collapse = "\n  "),
      call. = FALSE
    )
  }

  time_delta <- calc_time_delta(tuv_results)

  delta_wavelength <- max(diff(tuv_results$wl))

  # conversion constants from Appendix D of ARIS report
  unit_conversion_constant <- 3.01e-08 # (mol photon cm3)/(uW h nm L). Eq 3-2
  unit_conversion <- 100 # (uW cm-2)/(W m-2). TUV output to Eq 3-2 units

  pac_ma <- molar_absorption[
    molar_absorption$pac_id == pac,
    c("wavelength", "molar_absorption")
  ]

  report_surrogate(pac)

  tuv_results <- merge(
    tuv_results,
    pac_ma,
    by.x = "wl",
    by.y = "wavelength"
  )

  res_mat <- as.matrix(tuv_results)

  # Eq 3-2, ARIS report
  Pabs_mat <- res_mat[, grepl("t_", colnames(res_mat))] * # irradiance
    res_mat[, "wl"] * # wavelength
    res_mat[, "molar_absorption"] # molar absorption of pac

  sum(Pabs_mat) *
    unit_conversion_constant *
    unit_conversion *
    delta_wavelength *
    time_delta *
    time_multiplier
}

#' Calculate the light absorption of a PAC from a single exposure experiment
#'
#' @param exposure two-column data.frame of exposure results. The first column
#'   must contain the wavelengths and be called `wl`, the second column
#'   must contain the irradiance values at each wavelength expressed in
#'   units defined in the `units` parameter.
#' @param pac name of PAC to calculate light absorption for, as a `pac_id` from
#'   [pac_list()]
#' @param time_multiplier multiplier to get the total exposure over a time
#'   period. I.e., if the exposure was one second, and you need a 16h exposure,
#'   the multiplier would be 3600 * 16
#' @param irrad_units The units in which irradiance is recorded. One of
#'   `"uW / cm^2 / nm"` (default) or `"W / m^2 / nm"`
#'
#' @return The value of `Pabs` for the exposure results.
#' @export
p_abs_single <- function(
  exposure,
  pac,
  time_multiplier = 1,
  irrad_units = c("uW / cm^2 / nm", "W / m^2 / nm")
) {
  irrad_units <- match.arg(irrad_units)

  if (
    !inherits(exposure, "data.frame") ||
      ncol(exposure) != 2 ||
      names(exposure)[1] != "wl"
  ) {
    stop(
      "'exposure' must be a two-column data frame; the first column must be named 'wl'",
      call. = FALSE
    )
  }

  if (!is.numeric(exposure$wl)) {
    stop(
      "'wl' column must be numeric (containing wavelength values)",
      call. = FALSE
    )
  }

  if (!is.numeric(exposure[[2]])) {
    stop(
      "Column 2 must be numeric (containing irradiance values)",
      call. = FALSE
    )
  }

  pac <- sanitize_names(pac)

  if (!pac %in% molar_absorption$pac_id) {
    stop(
      "pac must be one of:\n  ",
      paste(unique(molar_absorption$pac_id), collapse = "\n  "),
      call. = FALSE
    )
  }

  # Eqn. 3-1 in ARIS 2023
  unit_conversion_constant <- 8.3594e-12 # μW/cm2/nm -> mole photon/mole chem/sec

  if (irrad_units == "W / m^2 / nm") {
    unit_conversion_constant <- unit_conversion_constant * 100
  }

  pac_ma <- molar_absorption[
    molar_absorption$pac_id == pac,
    c("wavelength", "molar_absorption")
  ]

  report_surrogate(pac)

  exposure <- merge(
    exposure,
    pac_ma,
    by.x = "wl",
    by.y = "wavelength"
  )

  delta_wavelength <- c(1, diff(exposure$wl))

  res_mat <- as.matrix(exposure)

  # Eq 3-2, ARIS report
  Pabs_mat <- res_mat[,
    setdiff(colnames(res_mat), c("wl", "molar_absorption"))
  ] * # irradiance
    res_mat[, "wl"] * # wavelength
    res_mat[, "molar_absorption"] * # molar absorption of pac
    delta_wavelength

  sum(Pabs_mat) *
    unit_conversion_constant *
    time_multiplier
}

report_surrogate <- function(pac) {
  surrogate <- molar_absorption$surrogate[
    molar_absorption$pac_id == pac &
      !is.na(molar_absorption$surrogate)
  ]
  if (length(surrogate) == 0) {
    return(invisible())
  }
  surrogates <- pac_name_from_id(strsplit(surrogate[1], ", ", fixed = TRUE)[[
    1
  ]])
  n <- length(surrogates)
  if (n == 1) {
    using <- paste("the spectrum of", surrogates)
  } else {
    using <- paste0(
      "the mean of the spectra of ",
      paste(surrogates[-n], collapse = ", "),
      " and ",
      surrogates[n]
    )
  }
  message(
    "No measured absorption spectrum for ",
    pac_name_from_id(pac),
    ". Using ",
    using,
    " as a surrogate."
  )
}

#' Calculate the phototoxic benchmark for a given P~abs~ and PAC chemical using
#' the PTLM
#'
#' The phototoxic benchmark is the acute benchmark concentration of a phototoxic
#' PAC based on its narcotic toxicity (narcotic benchmark) and calculations of
#' site-specific or field-level light absorption.
#'
#' You can either supply a specific PAC, so the narcotic benchmark can be
#' calculated for that chemical, or supply a narcotic benchmark value directly.
#'
#' @param x light absorption, calculated from [p_abs()], or a `tuv_results`
#'   data.frame from [tuv()] or [get_tuv_results()].
#' @param pac The PAC of interest, as a `pac_id` from [pac_list()], which is
#'   used to calculate the narcotic benchmark value.
#' @param narc_bench (optional) the narcotic toxicity (i.e., in the
#'   absence of light) of the PAC in ug/L. If supplied, takes precedence over
#'   the PAC lookup.
#' @param time_multiplier If x is a `tuv_results` data frame, this is the
#'   multiplier to get the total exposure time. I.e., if the tuv_results
#'   contains 24 hours of data, and you need a 48h exposure, the
#'   multiplier would be 2 (this is the default). Ignored if `x` is a numeric
#'   value of light absorption.
#'
#' @return the phototoxic benchmark value of the PAC in ug/L.
#' @export
#'
#' @references
#' Marzooghi, S., Finch, B.E., Stubblefield, W.A., Dmitrenko, O., Neal, S.L. and
#' Di Toro, D.M. (2017), Phototoxic target lipid model of single polycyclic
#' aromatic hydrocarbons. Environ Toxicol Chem, 36: 926-937.
#' https://doi.org/10.1002/etc.3601
#'
#' @examples
#' phototoxic_benchmark(590, pac = "Benzo[a]pyrene")
#' phototoxic_benchmark(590, narc_bench = 450)
phototoxic_benchmark <- function(
  x,
  pac = NULL,
  narc_bench = NULL,
  time_multiplier
) {
  pac <- sanitize_names(pac)
  UseMethod("phototoxic_benchmark")
}

#' @export
phototoxic_benchmark.default <- function(
  x,
  pac = NULL,
  narc_bench = NULL,
  time_multiplier
) {
  stop(
    "phototoxic_benchmark can only be called on a single numeric value (calculated via `p_abs()`)
       or a data.frame of class `tuv_results`",
    call. = FALSE
  )
}

#' @export
phototoxic_benchmark.tuv_results <- function(
  x,
  pac = NULL,
  narc_bench = NULL,
  time_multiplier = 2
) {
  pabs <- p_abs(x, pac = pac, time_multiplier = time_multiplier)
  phototoxic_benchmark(pabs, pac = pac, narc_bench = narc_bench)
}

#' @export
phototoxic_benchmark.numeric <- function(
  x,
  pac = NULL,
  narc_bench = NULL,
  time_multiplier = NULL
) {
  if (!is.null(time_multiplier)) {
    warning("Time multiplier not valid for numeric input; it will be ignored.")
  }

  narc_bench <- narc_bench %||%
    narcotic_benchmark(pac) %||%
    stop(
      "You must provide a valid 'pac' or supply your own narc_bench value",
      call. = FALSE
    )

  # a' and R'* from Unpublished Report, derived from Tillmanns et al 2024,
  # corrected for solubility limit
  TLM_a <- 0.47919
  TLM_R <- 1.01052

  # Eqn 2-2, ARIS report
  narc_bench / (1 + x^TLM_a / TLM_R)
}

#' Calculate the narcotic benchmark (acute) concentration for a PAC using
#' the Target Lipid Model (TLM)
#'
#' This calculates the acute water quality benchmark using the equation and
#' default values from Tillmanns et al 2024.
#'
#' @param pac The PAC of interest, as a `pac_id` from [pac_list()]
#'
#' @details
#'
#' The values used in the calculation are:
#'
#' * **slope** The slope in Equation 2 in Tillmanns et al 2024. The default
#'   value is -0.922.
#' * **HC5** The 5th percentile of the SSD of critical body burdens predicted
#'   to be hazardous for no more than 5% of the species. Default value is 9.7
#'   umol/g, from Equation 2 in Tillmanns et al 2024.
#' * **dc_pah** Chemical class correction (Δc) for PAHs, as reported in
#'   Tillmanns et al 2024. The default value is -0.420. It is also used for
#'   oxy-PAHs (e.g., benzanthrone).
#' * **dc_hac** Chemical class correction (Δc) for HACs, as reported in
#'   Tillmanns et al 2024. The default value is -0.467.
#'
#' The chemical class of each PAC is given by [pac_list()].
#'
#' @return the narcotic benchmark value of the PAC in ug/L.
#' @export
#' @references
#'  Tillmanns, A. R., McGrath, J. A., & Di Toro, D. M. (2024). International
#'  Water Quality Guidelines for Polycyclic Aromatic Hydrocarbons: Advances to
#' Improve Jurisdictional Uptake of Guidelines Derived Using The Target Lipid
#' Model. Environmental Toxicology and Chemistry, 43(4), 686-700.
#'
#' @examples
#' narcotic_benchmark("anthracene")
narcotic_benchmark <- function(pac) {
  narcotic_guideline(
    pac,
    slope = -0.922,
    HC5 = 9.70,
    dc_pah = -0.420,
    dc_hac = -0.467
  )
}

#' Calculate the narcotic guideline (chronic) concentration for a PAC using
#' the Target Lipid Model (TLM)
#'
#' This calculates the narcotic chronic water quality guideline using the equation and
#' default values from Tillmanns et al 2024.
#'
#' @param pac The PAC of interest, as a `pac_id` from [pac_list()]
#'
#' @details
#'
#' The values used in the calculation are:
#'
#' * **slope** The slope in Equation 3 in Tillmanns et al 2024. The default
#'   value is -0.951.
#' * **HC5** The 5th percentile of the SSD of critical body burdens predicted
#'   to be hazardous for no more than 5% of the species. Default value is 3.14
#'   umol/g, from Equation 2 in Tillmanns et al 2024.
#' * **dc_pah** Chemical class correction (Δc) for PAHs, as reported in
#'   Tillmanns et al 2024. The default value is -0.659. It is also used for
#'   oxy-PAHs (e.g., benzanthrone).
#' * **dc_hac** Chemical class correction (Δc) for HACs, as reported in
#'   Tillmanns et al 2024. The default value is -0.398.
#'
#' The chemical class of each PAC is given by [pac_list()].
#'
#' @return the narcotic chronic water quality guideline value of the PAC in ug/L.
#' @export
#' @references
#'  Tillmanns, A. R., McGrath, J. A., & Di Toro, D. M. (2024). International
#'  Water Quality Guidelines for Polycyclic Aromatic Hydrocarbons: Advances to
#' Improve Jurisdictional Uptake of Guidelines Derived Using The Target Lipid
#' Model. Environmental Toxicology and Chemistry, 43(4), 686-700.
#'
#' @examples
#' narcotic_cwqg("anthracene")
narcotic_cwqg <- function(pac) {
  narcotic_guideline(
    pac,
    slope = -0.951,
    HC5 = 3.14,
    dc_pah = -0.659,
    dc_hac = -0.398
  )
}

narcotic_guideline <- function(pac, slope, HC5, dc_pah, dc_hac) {
  if (is.null(pac)) {
    return(NULL)
  }
  pac <- sanitize_names(pac)

  if (!pac %in% pac_lookup$pac_id) {
    stop("You have supplied an invalid PAC", call. = FALSE)
  }

  nlcdata <- pac_lookup[pac_lookup$pac_id == pac, ]

  if (nrow(nlcdata) != 1) {
    stop("More than one PAC matched", call. = FALSE)
  }

  dc <- switch(
    nlcdata$chem_class,
    "PAH" = ,
    "oxy-PAH" = dc_pah,
    "He" = dc_hac,
    stop("Unknown chemical class: ", nlcdata$chem_class, call. = FALSE)
  )

  10^(slope * nlcdata$log_kow + log10(HC5) + dc) *
    nlcdata$mol_weight *
    1000 # convert from mmol/L to ug/L
}

#' Calculate the phototoxic CWQG for a given P~abs~ and PAC chemical using
#' the PTLM
#'
#' The phototoxic CWQG is the chronic guideline concentration of a phototoxic
#' PAC based on its narcotic toxicity (narcotic benchmark) and calculations of
#' site-specific or field-level light absorption.
#'
#' It is calculated as the phototoxic benchmark concentration (acute, calculated
#' with [phototoxic_benchmark()] divided by an Acute-to-Chronic Ratio (ACR).
#'
#' You can either supply a specific PAC, so the narcotic benchmark can be
#' calculated for that chemical, or supply a narcotic benchmark value directly.
#'
#' @inheritParams phototoxic_benchmark
#' @param acr Acute-to-Chronic Ratio that the phototoxic benchmark is divided
#'   by. Default 11.6.
#'
#' @return the phototoxic CWQG value of the PAC in ug/L.
#' @export
#'
#' @references
#' Marzooghi, S., Finch, B.E., Stubblefield, W.A., Dmitrenko, O., Neal, S.L. and
#' Di Toro, D.M. (2017), Phototoxic target lipid model of single polycyclic
#' aromatic hydrocarbons. Environ Toxicol Chem, 36: 926-937.
#' https://doi.org/10.1002/etc.3601
#'
#' @examples
#' phototoxic_cwqg(590, pac = "Benzo[a]pyrene")
#' phototoxic_cwqg(590, narc_bench = 450)
phototoxic_cwqg <- function(
  x,
  pac = NULL,
  narc_bench = NULL,
  time_multiplier = 2,
  acr = default_acr()
) {
  check_positive_number(acr, "acr")

  if (!inherits(x, "tuv_results")) {
    time_multiplier <- NULL
  }

  pb_bench <- phototoxic_benchmark(
    x,
    pac = pac,
    narc_bench = narc_bench,
    time_multiplier = time_multiplier
  )
  pb_bench / acr
}

calc_time_delta <- function(tuv_results) {
  inp_aq <- attr(tuv_results, "inp_aq")
  start <- as.numeric(inp_aq[["tstart, hours local time"]])
  stop <- as.numeric(inp_aq[["tstop, hours local time"]])
  steps <- as.numeric(inp_aq[["number of time steps"]])
  max(diff(seq(start, stop, length.out = steps)))
}

default_acr <- function() 11.6
