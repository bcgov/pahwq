local_tuv_dir <- function(env = parent.frame()) {
  tdir <- file.path(
    withr::local_tempdir(.local_envir = env),
    "pacwq",
    "tuv_data"
  )
  withr::local_options("pacwq.tuv_data_dir" = tdir, .local_envir = env)
  setup_tuv_dir()
}
