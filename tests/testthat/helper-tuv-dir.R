local_tuv_dir <- function(env = parent.frame()) {
  tdir <- file.path(withr::local_tempdir(.local_envir = env), "pahwq", "tuv_data")
  setup_tuv_dir(tdir)
}

