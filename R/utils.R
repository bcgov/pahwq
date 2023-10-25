compact <- function(l) Filter(Negate(is.null), l)

tuv_data_dir <- function() {
  file.path(tools::R_user_dir("pahwq", "data"), "tuv_data")
}
