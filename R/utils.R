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
