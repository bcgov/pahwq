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
#' * `pac_id`: the unique ID of the PAC, as accepted by functions such as
#'   [narcotic_benchmark()] and [p_abs()].
#' * `pac_name`: the display name of the PAC or PAC homologue group.
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
  ret <- as.data.frame(pac_lookup)
  if (app_only) {
    ret <- ret[ret$app, ]
  }
  rownames(ret) <- NULL
  ret
}

#' Match names to PACs
#'
#' Finds the PAC or PAC homologue group for each name, as functions such as
#' [tu_hi()] do. A name can be a `pac_name` or `pac_id` from [pac_list()].
#' Differences in case, leading and trailing whitespace, spaces around hyphens,
#' and brackets are ignored (e.g., `" Benzo[a]pyrene"` matches
#' `"Benzo(a)pyrene"`).
#'
#' Both parents of a homologue group match the group, so names that match the
#' same PAC can be found with `duplicated()`.
#'
#' @param x A character vector of names.
#'
#' @return A character vector the same length as `x`, with the `pac_name` from
#'   [pac_list()] for each name, or `NA` if there is no match.
#' @export
#'
#' @examples
#' match_pac(c("Benzo[a]pyrene", "c1-anthracenes", "not a PAC"))
match_pac <- function(x) {
  if (!is.character(x)) {
    stop("`x` must be a character vector.", call. = FALSE)
  }
  pac_lookup$pac_name[match_pac_rows(x)]
}

pac_name_from_id <- function(pac_id) {
  pac_lookup$pac_name[match(pac_id, pac_lookup$pac_id)]
}

# The row of `pac_lookup` for each `pac_id` or `pac_name`, or NA. Homologue
# group names don't sanitize to a `pac_id`, so `pac_name` is matched too.
match_pac_rows <- function(x) {
  x[is.na(x)] <- ""
  x <- sanitize_names(trimws(x))
  rows <- match(x, pac_lookup$pac_id)
  by_pac <- match(x, sanitize_names(pac_lookup$pac_name))
  rows[is.na(rows)] <- by_pac[is.na(rows)]
  rows
}
