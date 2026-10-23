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

#' Calculate Kd at 305 nm for a given Dissolved Organic Carbon (DOC) concentration.
#'
#' @param DOC DOC in g/m^3
#'
#' @return A numeric vector representing Kd at 305 nm
#' @export
#'
#' @examples
#' kd_305(5)
kd_305 <- function(DOC) {
  if (!is.numeric(DOC)) {
    stop("DOC must be numeric", call. = FALSE)
  }

  DOC <- doc_range_check(DOC)

  # eqn 6 (pg 18), ARIS 2024
  a305 <- 1.28
  b305 <- 1.31

  kd305 <- a305 * DOC^b305 + 0.13
  round(kd305, 2)
}

#' Valid range of DOC concentrations
#'
#' `doc_range()` returns the minimum and maximum DOC concentrations for which
#' the Kd model is valid. `doc_range_check()` checks a DOC value against that
#' range, and replaces it with the nearest limit (with a warning) if it falls
#' outside.
#'
#' @inheritParams kd_305
#'
#' @return `doc_range()` returns a numeric vector of length two: the minimum and
#'   maximum valid DOC in g/m^3. `doc_range_check()` returns `DOC`, or the
#'   nearest limit if `DOC` is outside the valid range.
#' @export
#'
#' @examples
#' doc_range()
#' doc_range_check(5)
#' doc_range_check(100)
doc_range_check <- function(DOC) {
  rng <- doc_range()
  if (DOC < rng[1]) {
    warning(
      "DOC value supplied is less than the minimum valid DOC. Replacing with ",
      rng[1],
      call. = FALSE
    )
    return(rng[1])
  }
  if (DOC > rng[2]) {
    warning(
      "DOC value supplied is greater than the maximum valid DOC. Replacing with ",
      rng[2],
      call. = FALSE
    )
    return(rng[2])
  }
  DOC
}

#' @rdname doc_range_check
#' @export
doc_range <- function() {
  c(0.2, 61.45) # Minimum and maximum valid DOC values in g/m^3
}

#' Calculate Kd at a given wavelength and DOC concentration.
#'
#' Note this function is not used inside the package as the same calculation is
#' done by the Fortran TUV model. It is present here for demonstration purposes.
#'
#' @param wavelength lambda wavelength in nm
#' @inheritParams kd_305
#'
#' @return A numeric vector representing Kd at a given wavelength
#' @export
#'
#' @examples
#' kd_lambda(10, 400)
kd_lambda <- function(DOC, wavelength) {
  # eqn 4-3, ARIS 2023
  Sk <- 0.018 #nm^-1
  kback <- 0

  kd305 <- kd_305(DOC)
  kd_calc(kd305, 305, Sk, wavelength, kback)
}

#' Calculate Kd at a given wavelength in marine waters.
#'
#' Uses the seasonal marine model for the area containing the location, from
#' [marine_kd_model()]. Errors if the model has no data for that area and
#' season.
#'
#' @param wavelength lambda wavelength in nm
#' @inheritParams marine_kd_model
#'
#' @return A numeric vector representing Kd at a given wavelength in marine
#'   waters
#' @export
#'
#' @examples
#' kd_marine(400, lat = 49.15085, lon = -125.91427, date = "2024-06-21")
kd_marine <- function(wavelength, lat, lon, date) {
  if (length(lat) != 1 || length(lon) != 1 || length(date) != 1) {
    stop("`lat`, `lon`, and `date` must each have length 1", call. = FALSE)
  }
  model <- marine_kd_model(lat, lon, date)
  check_marine_kd_data(model)
  kd_calc(
    model$Kd_ref,
    model$Kd_wvl,
    model$Sk,
    wavelength,
    kback = 0,
    digits = NULL
  )
}

check_marine_kd_data <- function(model) {
  if (isTRUE(model$nodata)) {
    stop(
      "There is no marine Kd model for ",
      model$area,
      " in ",
      model$season,
      ".",
      call. = FALSE
    )
  }
  invisible(model)
}

kd_calc <- function(ref_kd, ref_wl, Sk, wavelength, kback, digits = 2) {
  kdlambda <- ref_kd * exp(Sk * (ref_wl - wavelength)) + kback

  names(kdlambda) <- as.character(wavelength)
  if (is.null(digits)) kdlambda else round(kdlambda, digits)
}
