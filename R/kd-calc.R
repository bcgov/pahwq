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

#' Calculate Kd at a given wavelength and DOC concentration.
#'
#' Note this function is not used inside the package as the same calculation is
#' done by the Fortran TUV model. It is present here for demonstration purposes.
#'
#' @param wavelength lambda wavelength in nm
#' @inheritParams kd_305
#'
#' @return A numeric vector representin Kd at a given wavelength
#' @export
#'
#' @examples
#' kd_lambda(10, 400)
kd_lambda <- function(DOC, wavelength) {
  # eqn 4-3, ARIS 2023
  Sk <- 0.018 #nm^-1
  kback <- 0

  kd305 <- kd_305(DOC)

  kdlambda <- kd305 * exp(Sk * (305 - wavelength)) + kback
  names(kdlambda) <- as.character(wavelength)
  round(kdlambda, 2)
}

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
  # eqn 4-1a, ARIS 2023
  # See Eqn 3 & 4 on page 14 in ARIS 2023b for potential alternative
  # relationships between DOC and Kd305
  a305 <- 2.76
  b305 <- 1.23

  kd305 <- a305 * DOC^b305 + 0.13
  round(kd305, 2)
}
