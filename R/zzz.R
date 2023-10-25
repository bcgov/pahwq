.onLoad <- function(...) {
  parent_dir <- dirname(tuv_data_dir())
  base_dir <- basename(tuv_data_dir())
  dir.create(parent_dir, showWarnings = FALSE, recursive = TRUE)
  file.copy(system.file(base_dir, package = "pahwq"), parent_dir, recursive = TRUE)
  invisible(NULL)
}
