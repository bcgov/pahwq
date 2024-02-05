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

`%||%` <- function(x, y) {
  if (!is.null(x)) {
    x
  } else {
    y
  }
}

setup_tuv_dir <- function(tuv_dir = tuv_data_dir()) {
  parent_dir <- dirname(tuv_dir)
  base_dir <- basename(tuv_dir)
  dir.create(parent_dir, showWarnings = FALSE, recursive = TRUE)
  file.copy(system.file(base_dir, package = "pahwq"), parent_dir, recursive = TRUE)
  file.copy(
    system.file(
      paste0("bin/", tuv_cmd()),
      package = "pahwq"
    ), tuv_dir
  )
  invisible(tuv_dir)
}

tuv_data_dir <- function(dir = getOption("pahwq.tuv_data_dir", default = NULL)) {
  dir %||% file.path(tools::R_user_dir("pahwq", "data"), "tuv_data")
}

#' Delete the directory containing the TUV files
#'
#' @param tuv_dir The directory containing the TUV files

#' @export
clean_tuv_dir <- function(tuv_dir = tuv_data_dir()) {
  if (dir.exists(tuv_dir)) {
    unlink(tuv_dir, recursive = TRUE)
  }
}

#' List files in the directory containing the TUV files
#'
#' @param tuv_dir The directory containing the TUV files

#' @export
list_tuv_dir <- function(tuv_dir = tuv_data_dir()) {
  if (!dir.exists(tuv_dir)) {
    character(0)
  }
  list.files(tuv_dir, recursive = TRUE, full.names = TRUE)
}

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
  abs(x - round(x)) < tol
}

sanitize_names <- function(x) {
  x <- tolower(x)
  # replace square brackets with parentheses
  x <- gsub("\\[([-,a-z0-9]{1,10})\\]", "(\\1)", x)

  # find all the text inside parentheses
  inside_parentheses <- gregexpr("\\(([^)]+)\\)", x)

  start_paren <- vapply(inside_parentheses, `[`, 1, FUN.VALUE = numeric(1))
  end_paren <- start_paren +
    vapply(inside_parentheses, function(y) {
      attr(y, "match.length") - 1
    }, FUN.VALUE = numeric(1))

  # split the string into the part before the parentheses, the part inside the
  # parentheses, and the part after the parentheses
  before <- substr(x, 1, start_paren - 1)
  inside <- substr(x, start_paren, end_paren)
  after <- substr(x, end_paren + 1, nchar(x))

  # change benz( to benzo(:
  before <- gsub("benz$", "benzo", before)

  # remove the commas from the part inside the parentheses
  inside <- gsub(",", "", inside)

  # paste the parts back together
  ret <- paste0(before, inside, after)

  # Put the ones that don't have parentheses back to the original
  ret[inside_parentheses == -1] <- x[inside_parentheses == -1]
  ret
}

