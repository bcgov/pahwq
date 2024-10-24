#' Calculate the narcotic and phototoxic benchmarks for a set of PAHs
#'
#' Given the results of a TUV model run (via [tuv()] or [run_tuv()]),
#' get the narcotic benchmark, Pabs, and phototoxic benchmark for a set of PAHs
#'
#' @param pahs names of PAHs for which to calculate narcotic benchmark, Pabs,
#'   and phototoxic benchmark
#' @inheritParams p_abs
#'
#' @return a data.frame of narcotic benchmark, Pabs, and phototoxic benchmark
#'   for the given PAHs and TUV results
#' @export
#'
#' @examples
#' tuv_res <- tuv(
#'   depth_m = 0.25,
#'   lat = 49.601632,
#'   lon = -119.605862,
#'   DOC = 5,
#'   date = "2023-06-21"
#' )
#'
#' pb_multi(tuv_res, c("Anthracene", "fluorene", "pyrene"))
pb_multi <- function(tuv_results, pahs, time_multiplier = 2) {

  if (!inherits(tuv_results, "tuv_results")) {
    stop("`tuv_res` must be an object of type 'tuv_results'.", call. = FALSE)
  }

  pahs <- sanitize_names(pahs)

  check_valid_chemicals(pahs)

  nb_multi <- vapply(
    pahs,
    function(x) narcotic_benchmark(x),
    FUN.VALUE = numeric(1)
  )

  pabs_multi <- vapply(
    names(nb_multi),
    function(x) p_abs(tuv_results, x, time_multiplier = time_multiplier),
    FUN.VALUE = numeric(1)
  )

  pb_multi <- vapply(
    names(pabs_multi),
    function(x) phototoxic_benchmark(pabs_multi[x], x),
    FUN.VALUE = numeric(1)
  )

  data.frame(
    pah = pahs,
    narcotic_benchmark = unname(nb_multi),
    pabs = unname(pabs_multi),
    phototoxic_benchmark = unname(pb_multi)
  )

}
