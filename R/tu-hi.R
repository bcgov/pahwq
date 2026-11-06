#' Calculate toxic units and hazard indexes for a monitoring sample
#'
#' Calculates narcotic and phototoxic toxic units (TUs) and hazard indexes (HIs)
#' for the PACs measured in a sample, and their sums for the sample.
#'
#' For each PAC, the concentration is divided by a guideline for the sample's
#' site, date and depth:
#'
#' * `tu_narcotic`: the short-term narcotic guideline
#'   ([narcotic_benchmark()]).
#' * `tu_phototoxic`: the short-term phototoxic guideline
#'   ([phototoxic_benchmark()]).
#' * `hi_narcotic`: the long-term narcotic guideline ([narcotic_cwqg()]).
#' * `hi_phototoxic`: the long-term phototoxic guideline ([phototoxic_cwqg()]).
#'
#' Run [tuv()] with the location, date, depth and water parameters of the
#' sample, as the phototoxic guidelines depend on them.
#'
#' @param concentrations A data frame with one row per PAC and columns:
#' * `pac`: the PAC or PAC homologue group, as a `pac_name` or `pac_id` from
#'   [pac_list()].
#' * `concentration_ug_L`: the concentration in ug/L. Missing values count as 0.
#' @inheritParams pb_multi
#'
#' @return A one-row data frame of class `tu_hi`, with the sums of `tu_narcotic`,
#'   `tu_phototoxic`, `hi_narcotic` and `hi_phototoxic` for the sample.
#'
#' The results for each PAC are in the `"pacs"` attribute: a data frame with one
#' row per PAC, with `pac_name`, `concentration_ug_L`, the guidelines and `pabs` from
#' [pb_multi()], and `tu_narcotic`, `tu_phototoxic`, `hi_narcotic` and
#' `hi_phototoxic`.
#'
#' PACs that aren't recognised are dropped with a warning.
#' @export
#'
#' @examples
#' tuv_res <- tuv(
#'   lat = 49.601632,
#'   lon = -119.605862,
#'   elev_m = 342,
#'   DOC = 5,
#'   date = "2023-06-21"
#' )
#'
#' concentrations <- data.frame(
#'   pac = c(
#'     "Anthracene",
#'     "C1-Phenanthrenes/Anthracenes",
#'     "Pyrene",
#'     "Benzo(a)anthracene"
#'   ),
#'   concentration_ug_L = c(0.01, 0.2, NA, 0)
#' )
#'
#' tu_hi_results <- tu_hi(concentrations, tuv_res)
#'
#' # The sums for the sample
#' tu_hi_results
#'
#' # The results for each PAC
#' attr(tu_hi_results, "pacs")
tu_hi <- function(
  concentrations,
  tuv_results,
  time_multiplier = 2,
  acr = default_acr()
) {
  if (!inherits(tuv_results, "tuv_results")) {
    stop(
      "`tuv_results` must be an object of type 'tuv_results'.",
      call. = FALSE
    )
  }
  check_concentrations(concentrations)

  rows <- match_pac_rows(concentrations$pac)

  if (anyNA(rows)) {
    warning(
      "Dropping PACs that aren't recognised: ",
      paste(concentrations$pac[is.na(rows)], collapse = ", "),
      call. = FALSE
    )
    concentrations <- concentrations[!is.na(rows), ]
    rows <- rows[!is.na(rows)]
  }

  if (length(rows) == 0) {
    stop("`concentrations` must contain at least one known PAC.", call. = FALSE)
  }

  pac <- pac_lookup$pac_name[rows]

  if (anyDuplicated(pac)) {
    stop(
      "`concentrations` must have one row per PAC. Repeated: ",
      paste(unique(pac[duplicated(pac)]), collapse = ", "),
      call. = FALSE
    )
  }

  guidelines <- pb_multi(
    tuv_results,
    pac_lookup$pac_id[rows],
    time_multiplier = time_multiplier,
    acr = acr
  )

  tu_hi_calc(pac, as.numeric(concentrations$concentration_ug_L), guidelines)
}

tu_hi_calc <- function(pac, concentration, guidelines) {
  concentration[is.na(concentration)] <- 0

  indexes <- data.frame(
    tu_narcotic = concentration / guidelines$narcotic_benchmark,
    tu_phototoxic = concentration / guidelines$phototoxic_benchmark,
    hi_narcotic = concentration / guidelines$narcotic_cwqg,
    hi_phototoxic = concentration / guidelines$phototoxic_cwqg
  )

  pacs <- data.frame(
    pac_name = pac,
    concentration_ug_L = concentration,
    guidelines[, c(
      "narcotic_benchmark",
      "narcotic_cwqg",
      "pabs",
      "phototoxic_benchmark",
      "phototoxic_cwqg"
    )],
    indexes
  )

  structure(
    as.data.frame(lapply(indexes, sum)),
    pacs = pacs,
    class = c("tu_hi", "data.frame")
  )
}

#' @export
print.tu_hi <- function(x, ...) {
  pacs <- attr(x, "pacs")
  cat("\nToxic units and hazard indexes for the sample.\n")

  if (!is.null(pacs)) {
    cat(
      "PACs: ",
      nrow(pacs),
      " (",
      sum(pacs$concentration_ug_L > 0),
      " with a concentration above 0)\n\n",
      sep = ""
    )
  }

  NextMethod(row.names = FALSE)

  if (!is.null(pacs)) {
    cat("\nResults for individual PACs are in `attr(x, \"pacs\")`.\n")
  }

  invisible(x)
}

check_concentrations <- function(concentrations) {
  if (!is.data.frame(concentrations)) {
    stop("`concentrations` must be a data frame.", call. = FALSE)
  }

  missing_cols <- setdiff(
    c("pac", "concentration_ug_L"),
    names(concentrations)
  )
  if (length(missing_cols) > 0) {
    stop(
      "`concentrations` is missing columns: ",
      paste(missing_cols, collapse = ", "),
      call. = FALSE
    )
  }

  if (!is.character(concentrations$pac) || anyNA(concentrations$pac)) {
    stop(
      "`concentrations$pac` must be a character column with no missing values.",
      call. = FALSE
    )
  }

  concentration <- concentrations$concentration_ug_L
  if (!is.numeric(concentration) && !all(is.na(concentration))) {
    stop("`concentrations$concentration_ug_L` must be numeric.", call. = FALSE)
  }

  measured <- as.numeric(concentration[!is.na(concentration)])
  if (any(measured < 0 | is.infinite(measured))) {
    stop(
      "`concentrations$concentration_ug_L` must be zero or greater and finite.",
      call. = FALSE
    )
  }

  invisible(concentrations)
}
