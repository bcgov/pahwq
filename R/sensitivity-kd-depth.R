#' Sensitivity analysis for DOC, depth, and time of year
#'
#' Enter a single location and PAC, and a range of values for `DOC` or `Kd_ref`,
#' water depth, and dates and get back a data.frame of short-term narcotic
#' guideline, Pabs, and short-term phototoxic guideline values.
#'
#' You can add other variables beyond those listed explicitly, but if there are
#' too many combinations it will create many runs of the TUV model, which can
#' take a long time. Explicit variable checking is only performed on `pac`,
#' `lat`, `lon`, `elev_m`, `DOC`, `Kd_ref`, `depth`, and `months`. Passing
#' invalid values of other parameters may cause cryptic errors or unexpected
#' results.
#' Note that combinations of many `DOC`, `Kd_ref`, `depth_m`, and `date` values
#' will result in many runs of the TUV model and thus take a long time.
#'
#' @inheritParams tuv
#' @inheritParams phototoxic_benchmark
#' @inheritParams p_abs
#' @param depth_m depths at which to calculate the light attenuation
#'   coefficient, in metres. Default `0.01` (1 cm).
#' @param ... other parameters passed on to the tuv model. See [tuv()]
#'
#' @return A data.frame of all of the input parameters, plus `pac_id`,
#'   `pac_name`, a list column containing TUV results, and the columns
#'   `short_term_narcotic_guideline`, `pabs` and
#'   `short_term_phototoxic_guideline`. A homologue group name gives the `pac_id`
#'   of its first parent.
#' @export
#'
#' @examples
#' sens_kd_depth(
#'   "Anthracene",
#'   lat = 52,
#'   lon = -113,
#'   Kd_ref = 40:45,
#'   depth_m = c(0.25, 0.5, 1),
#'   date = c("2023-07-01", "2023-08-01")
#' )
sens_kd_depth <- function(
  pac = NULL,
  lat = NULL,
  lon = NULL,
  elev_m = NULL,
  DOC = NULL,
  Kd_ref = NULL,
  depth_m = 0.01,
  date = NULL,
  time_multiplier = 2,
  ...
) {
  stopifnot(is.character(pac) && length(pac) == 1)
  pac <- resolve_pac_id(pac)
  check_valid_pac_ids(pac)

  stopifnot(is.numeric(lat) && length(lat) == 1)
  stopifnot(is.numeric(lon) && length(lon) == 1)
  stopifnot(is.numeric(depth_m))

  date <- as.Date(date)

  # list with val and var
  attenuation <- get_attenuation(DOC, Kd_ref)

  elev_m <- elev_m %||% get_elevation(lon, lat)
  stopifnot(is.numeric(elev_m))

  grid <- make_full_grid(
    lat = lat,
    lon = lon,
    elev_m = elev_m,
    depth_m = depth_m,
    date = date,
    attenuation = attenuation
  )

  df_by_row <- dplyr::rowwise(grid)

  df_by_row <- dplyr::mutate(
    df_by_row,
    tuv_res = list(call_tuv(
      attenuation = .data[[attenuation$var]],
      attenuation_var = attenuation$var,
      date = .data$date,
      lat = .data$lat,
      lon = .data$lon,
      elev_m = .data$elev_m,
      depth_m = .data$depth_m,
      ...
    ))
  )

  calc_wq_df(df_by_row, pac = pac, time_multiplier = time_multiplier)
}

get_attenuation <- function(DOC, Kd_ref) {
  attenuation_list <- list(DOC = DOC, Kd_ref = Kd_ref)
  attenuation_var <- names(which(vapply(
    attenuation_list,
    Negate(is.null),
    FUN.VALUE = logical(1)
  )))

  attenuation_abort <- function() {
    stop("Either `Kd_ref` or `DOC` must be numeric", call. = FALSE)
  }

  if (length(attenuation_var) != 1L) {
    attenuation_abort()
  }
  attenuation_val <- attenuation_list[[attenuation_var]]
  if (!is.numeric(attenuation_val)) {
    attenuation_abort()
  }
  list(
    var = attenuation_var,
    val = attenuation_val
  )
}

make_full_grid <- function(..., attenuation) {
  grid <- expand.grid(
    ...,
    attenuation = attenuation$val,
    stringsAsFactors = FALSE
  )

  names(grid)[names(grid) == "attenuation"] <- attenuation$var

  n_iter <- nrow(grid)

  if (n_iter > 100) {
    warning(
      "Initiating ",
      n_iter,
      " iterations of the TUV model. This could take a while",
      call. = FALSE
    )
  }
  grid
}

calc_wq_df <- function(df, pac, time_multiplier) {
  df <- dplyr::ungroup(df)
  dplyr::mutate(
    df,
    pac_id = pac,
    pac_name = pac_name_from_id(pac),
    short_term_narcotic_guideline = narcotic_benchmark(pac),
    pabs = vapply(
      .data$tuv_res,
      function(x) {
        p_abs(x, pac, time_multiplier)
      },
      FUN.VALUE = numeric(1)
    ),
    short_term_phototoxic_guideline = vapply(
      .data$pabs,
      function(x) {
        phototoxic_benchmark(x, pac)
      },
      FUN.VALUE = numeric(1)
    )
  )
}

call_tuv <- function(attenuation, attenuation_var, ...) {
  args <- c(attenuation, list(...))

  names(args)[1] <- attenuation_var

  do.call("tuv", c(args, quiet = TRUE))
}

#' Make a heatmap of the sensitivity analysis performed by [sens_kd_depth()]
#'
#' @param x A data.frame, the output of [sens_kd_depth()]
#' @param interactive Whether to make the plot interactive
#' @param ... parameters passed on to [ggiraph::girafe()] to control the
#'   interactive plot if `interactive = TRUE`.
#'
#' @return a `ggplot2` object if `interactive = FALSE`, a `girafe` interactive
#'   plot object if `interactive = TRUE`
#' @export
#'
#' @examples
#' \dontrun{
#' out <- sens_kd_depth(
#'   "Anthracene",
#'   lat = 52,
#'   lon = -113,
#'   DOC = 3:8,
#'   depth_m = c(0.25, 0.5, 0.75, 1),
#'   date = c("2023-07-01", "2023-08-01")
#' )
#'
#' plot_sens_kd_depth(out)
#'
#' out2 <- sens_kd_depth(
#'   "benzo(a)pyrene",
#'   lat = 57,
#'   lon = -120,
#'   Kd_ref = seq(10, 50, by = 10),
#'   depth_m = c(0.25, 0.5, 0.75, 1),
#'   date = c("2023-07-01", "2023-08-01")
#' )
#'
#' plot_sens_kd_depth(out2, interactive = TRUE)
#' }
plot_sens_kd_depth <- function(x, interactive = FALSE, ...) {
  attenuation_var <- intersect(c("DOC", "Kd_ref"), names(x))

  if (attenuation_var == "DOC") {
    y_label <- "DOC"
    y_unit <- "(mg/L)"
  } else {
    y_label <- "Kd(305)"
    y_unit <- ""
  }

  x$.tooltip <- sprintf(
    "Date: %s
      Depth: %s m
      %s: %s %s
      Short-term narcotic guideline: %s ug/L
      Pabs: %s
      Short-term phototoxic guideline: %s ug/L",
    x$date,
    x$depth_m,
    y_label,
    round(x[[attenuation_var]], 2),
    y_unit,
    round(x$short_term_narcotic_guideline, 2),
    round(x$pabs, 2),
    round(x$short_term_phototoxic_guideline, 2)
  )

  x$.id <- seq_len(nrow(x))

  # Make short_term_phototoxic_guideline NA where Pabs == 0 so we can colour those Grey
  # This has to be done after we make the tooltip so that
  # the real short_term_phototoxic_guideline value shows up in the tooltip
  # x$short_term_phototoxic_guideline[x$pabs < 1e-6] <- NA_real_

  # Or a 0.5% percent difference in the short-term narcotic and phototoxic guidelines
  x$short_term_phototoxic_guideline[
    percent_diff(
      x$short_term_phototoxic_guideline,
      x$short_term_narcotic_guideline
    ) <
      0.5
  ] <- NA_real_

  p <- ggplot2::ggplot(x) +
    ggiraph::geom_tile_interactive(
      mapping = ggplot2::aes(
        x = .data$depth_m,
        y = .data[[attenuation_var]],
        fill = .data$short_term_phototoxic_guideline,
        tooltip = .data$.tooltip,
        data_id = .data$.id
      )
    ) +
    ggplot2::scale_fill_viridis_c(
      option = "inferno",
      begin = 0.4,
      direction = 1
    ) +
    ggplot2::scale_x_continuous(
      breaks = if (length(unique(x$depth_m)) < 5) {
        unique(x$depth_m)
      } else {
        ggplot2::waiver()
      }
    ) +
    ggplot2::scale_y_continuous(
      breaks = if (length(unique(x[[attenuation_var]])) < 5) {
        unique(x[[attenuation_var]])
      } else {
        ggplot2::waiver()
      }
    ) +
    ggplot2::facet_wrap(ggplot2::vars(.data$date)) +
    ggplot2::labs(
      title = paste0(
        "Short-term phototoxic guideline for ",
        pac_name_from_id(x$pac_id[1]),
        " across various depths and values of ",
        y_label,
        ", by date"
      ),
      caption = "Grey squares indicate that the short-term narcotic and phototoxic guidelines are within 0.5% (i.e., no phototoxic effect).",
      x = "Depth (m)",
      y = paste(y_label, y_unit),
      fill = "Short-term phototoxic guideline (ug/L)"
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      panel.grid.minor = ggplot2::element_blank(),
      plot.title = ggtext::element_textbox_simple(
        margin = ggplot2::margin(10, 0, 10, 0)
      ),
      plot.caption = ggtext::element_textbox_simple(
        margin = ggplot2::margin(10, 0, 10, 0)
      )
    )

  if (interactive) {
    p <- p +
      ggplot2::theme_minimal(base_size = 7)
    p <- ggiraph::girafe(ggobj = p, ...)
  }
  p
}

percent_diff <- function(a, b) {
  abs(a - b) / ((a + b) / 2) * 100
}
