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

#' Call TUV program
#'
#' @param tuv_dir the directory where the compiled TUV executable is located
#' @param quiet Should the progress of the TUV program be printed to the console?
#'
#' @export
tuv <- function(tuv_dir = getOption("tuv_dir", default = NULL), quiet = FALSE) {

  check_tuv_dir(tuv_dir)

  ## Must call tuv in the dir in which it lives so it can find accessory files
  withr::with_dir(tuv_dir, {
    system2(tuv_cmd(), stdout = if (quiet) FALSE else "")
  })
}

#' Retrieve results of TUV run
#'
#' @param file one of "out_irrad_y", "out_aflux_y", "out_irrad_ave",
#'     "out_aflux_ave", "out_irrad_atm", "out_aflux_atm"
#' @inheritParams tuv
#'
#' @return A data.frame with the results of the TUV run
#' @export
get_tuv_results <- function(file = "out_irrad_y", tuv_dir = getOption("tuv_dir", default = NULL)) {
  check_tuv_dir(tuv_dir)

  if (!file %in% tuv_out_files()) {
    stop("file must be one of: ", paste(tuv_out_files(), collapse = ", "))
  }

  fpath <- file.path(tuv_dir, "AQUA", file)

  header <- tuv_results_header(fpath)

  res <- utils::read.table(fpath, header = FALSE, col.names = header, skip = 2)
  res$wl <- (res$wavelength_start + res$wavelength_end) / 2
  res
}

check_tuv_dir <- function(tuv_dir) {
  if (is.null(tuv_dir)) {
    stop("Please set the path to your tuv executable with:
             options(tuv_dir = 'path'", call. = FALSE)
  }

  if (!dir.exists(tuv_dir)) {
    stop("specified tuv directory does not exist", call. = FALSE)
  }
}

tuv_results_header <- function(path) {
  l <- readLines(path, n = 1)
  header <- strsplit(l, "\\s+")[[1]]
  header <- gsub("^([0-9]{1,2})", "t_\\1", header)
  header <- sub("wl", "wavelength_start", header)
  header <- sub("wu", "wavelength_end", header)
  sub("Kvat", "Kd_lambda", header)
}

tuv_cmd <- function() {
  if (.Platform$OS.type == "windows") {
    return("tuv.exe")
  } else {
    "./tuv"
  }
}

tuv_out_files <- function() {
  c(
    "out_irrad_y",
    "out_aflux_y",
    "out_irrad_ave",
    "out_aflux_ave",
    "out_irrad_atm",
    "out_aflux_atm"
  )
}
