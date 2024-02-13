#' Calculate the NLC50 and PLC50 for a set of PAHs
#'
#' Given the results of a TUV model run (via [tuv()] or [run_tuv()]),
#' get the NLC50, Pabs, and PLC50 for a set of PAHs
#'
#' @param pahs names of PAHs for which to calculate NLC50, Pabs, and PLC50
#' @param ... arguments passed on to [nlc50()]
#' @inheritParams p_abs
#'
#' @return a data.frame of NLC50, Pabs, and PLC50 for the given PAHs and TUV
#'   results
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
#' plc50_multi(tuv_res, c("Anthracene", "fluorene", "pyrene"))
plc50_multi <- function(tuv_results, pahs, time_multiplier = 2, ...) {

  if (!inherits(tuv_results, "tuv_results")) {
    stop("`tuv_res` must be an object of type 'tuv_results'.", call. = FALSE)
  }

  pahs <- sanitize_names(pahs)

  valid_chemicals <- sanitize_names(
    intersect(nlc50_lookup$chemical, molar_absorption$chemical)
  )

  if (!all(pahs %in% valid_chemicals)) {
    stop("You have included invalid PAH names.", call. = FALSE)
  }

  nlc50_multi <- vapply(
    pahs,
    function(x) nlc50(x, ...),
    FUN.VALUE = numeric(1)
  )

  pabs_multi <- vapply(
    names(nlc50_multi),
    function(x) p_abs(tuv_results, x, time_multiplier = time_multiplier),
    FUN.VALUE = numeric(1)
  )

  plc50_multi <- vapply(
    names(pabs_multi),
    function(x) plc50(pabs_multi[x], x),
    FUN.VALUE = numeric(1)
  )

  data.frame(
    pah = pahs,
    nlc50 = unname(nlc50_multi),
    pabs = unname(pabs_multi),
    plc50 = unname(plc50_multi)
  )

}
