.onLoad <- function(...) {
  tuv_dir <- tuv_data_dir()
  parent_dir <- dirname(tuv_dir)
  base_dir <- basename(tuv_dir)
  dir.create(parent_dir, showWarnings = FALSE, recursive = TRUE)
  file.copy(system.file(base_dir, package = "pahwq"), parent_dir, recursive = TRUE)
  file.copy(
    system.file(
      paste0("bin/tuv", if (.Platform$OS.type == "windows") ".exe"),
      package = "pahwq"
    ), tuv_dir
  )
  invisible(NULL)
}
