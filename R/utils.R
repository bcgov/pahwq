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

compact <- function(l) Filter(Negate(is.null), l)

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

clean_tuv_data_dir <- function() {
  dir <- tuv_data_dir()
  if (dir.exists(dir)) {
    unlink(dir, recursive = TRUE)
  }
}

list_tuv_data_dir <- function() {
  dir <- tuv_data_dir()
  if (!dir.exists(dir)) {
    character(0)
  }
  list.files(dir, recursive = TRUE, full.names = TRUE)
}

is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) {
  abs(x - round(x)) < tol
}
