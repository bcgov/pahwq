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

  DOC <- doc_valid_range(DOC)

  # eqn 6 (pg 18), ARIS 2024
  a305 <- 1.28
  b305 <- 1.31

  kd305 <- a305 * DOC^b305 + 0.13
  round(kd305, 2)
}

doc_valid_range <- function(DOC)  {
  rng <- c(0.2, 61.45)
  if (DOC < rng[1]) {
    warning("DOC value supplied is less than the minimum valid DOC. Replacing with ", rng[1], call. = FALSE)
    return(rng[1])
  }
  if (DOC > rng[2]) {
    warning("DOC value supplied is greater than the maximum valid DOC. Replacing with ", rng[2], call. = FALSE)
    return(rng[2])
  }
  DOC
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
#' @inheritParams kd_lambda
#'
#' @return A numeric vector representing Kd at a given wavelength in marine waters
#' @export
#'
#' @examples
#' kd_marine(400)
kd_marine <- function(wavelength) {
  ## From Bricaud et al 1981
  kd375 <- 0.5 # m^-1
  Sk <- 0.014 # nm^-1
  kback <- 0

  kd_calc(kd375, 375, Sk, wavelength, kback)
}

kd_calc <- function(ref_kd, ref_wl, Sk, wavelength, kback) {
  kdlambda <- ref_kd * exp(Sk * (ref_wl - wavelength)) + kback

  names(kdlambda) <- as.character(wavelength)
  round(kdlambda, 2)
}
