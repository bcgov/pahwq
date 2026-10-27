#' List the PACs and their chemical properties
#'
#' Returns the polycyclic aromatic compounds (PACs) available in the package,
#' with the chemical properties used to calculate narcotic benchmarks and
#' guidelines. Values of log KOW are from EPI Suite KOWWIN, compiled by CCME,
#' and are capped at 6.0.
#'
#' PAC homologue groups that combine more than one parent, such as
#' "C1-Phenanthrenes/Anthracenes", have one row per parent (e.g.,
#' `"c1-phenanthrenes"` and `"c1-anthracenes"`), with the same properties.
#'
#' @param app_only If `TRUE`, only return the PACs displayed in the Shiny app.
#'
#' @return A data frame with columns:
#' * `chemical`: the chemical name, as accepted by functions such as
#'   [narcotic_benchmark()] and [p_abs()].
#' * `pac`: the PAC or PAC homologue group name.
#' * `chem_class`: the chemical class: `"PAH"`, `"He"` (heterocyclic aromatic
#'   compound), or `"oxy-PAH"`.
#' * `log_kow`: log KOW.
#' * `mol_weight`: molecular weight (g/mol).
#' * `app`: whether the PAC is displayed in the Shiny app.
#' * `ref`: the source of the values.
#' @export
#'
#' @examples
#' pac_list()
#' pac_list(app_only = TRUE)
pac_list <- function(app_only = FALSE) {
  if (!isTRUE(app_only) && !isFALSE(app_only)) {
    stop("'app_only' must be TRUE or FALSE", call. = FALSE)
  }
  ret <- as.data.frame(nlc50_lookup)
  if (app_only) {
    ret <- ret[ret$app, ]
  }
  rownames(ret) <- NULL
  ret
}
