#' Calculate the narcotic and phototoxic benchmarks for a set of PACs
#'
#' Given the results of a TUV model run (via [tuv()] or [run_tuv()]),
#' get the narcotic benchmark, Pabs, and phototoxic benchmark for a set of PACs
#'
#' @param pacs PACs for which to calculate narcotic benchmark, Pabs, and
#'   phototoxic benchmark, as `pac_id` or `pac_name` values from [pac_list()]
#' @inheritParams p_abs
#' @inheritParams phototoxic_cwqg
#'
#' @return a data.frame of `pac_id`, `pac_name`, narcotic benchmark,
#'   narcotic_cwqg, Pabs, phototoxic benchmark, and phototoxic_cwqg for the given
#'   PACs and TUV results. A homologue group name gives the `pac_id` of its first
#'   parent. `pac_name` matches the guideline tables in
#'   `inst/doc-guideline-lookup/`.
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
pb_multi <- function(
  tuv_results,
  pacs,
  time_multiplier = 2,
  acr = default_acr()
) {
  if (!inherits(tuv_results, "tuv_results")) {
    stop("`tuv_res` must be an object of type 'tuv_results'.", call. = FALSE)
  }

  check_positive_number(acr, "acr")

  pacs <- resolve_pac_id(pacs)

  check_valid_pac_ids(pacs)

  nb_multi <- vapply(
    pacs,
    function(x) narcotic_benchmark(x),
    FUN.VALUE = numeric(1)
  )

  n_cwqg_multi <- vapply(
    pacs,
    function(x) narcotic_cwqg(x),
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

  p_cwqg_multi <- pb_multi / acr

  data.frame(
    pac_id = pacs,
    pac_name = pac_name_from_id(pacs),
    narcotic_benchmark = unname(nb_multi),
    narcotic_cwqg = unname(n_cwqg_multi),
    pabs = unname(pabs_multi),
    phototoxic_benchmark = unname(pb_multi),
    phototoxic_cwqg = unname(p_cwqg_multi)
  )
}
