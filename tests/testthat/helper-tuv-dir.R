local_tuv_dir <- function(env = parent.frame()) {
  tdir <- file.path(withr::local_tempdir(.local_envir = env), "pahwq", "tuv_data")
  withr::local_options("pahwq.tuv_data_dir" = tdir, .local_envir = env)
  setup_tuv_dir()
}

