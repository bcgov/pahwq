#' Sensitivity analysis for DOC, depth, and time of year
#'
#' Enter a single location and PAH, and a range of values for `DOC` or `Kd_ref`,
#' water depth, and dates and get back a data.frame of NLC50, Pabs, and PLC50
#' values.
#'
#' You can add other variables beyond those listed explicitly, but if there are
#' too many combinations it will create many runs of the TUV model, which can
#' take a long time. Explicit variable checking is only performed on `pah`,
#' `lat`, `lon`, `elev_m`, `DOC`, `Kd_ref`, `depth`, and `months`. Passing
#' invalid values of other parameters may cause cryptic errors or unexpected
#' results.
#' Note that combinations of many `DOC`, `Kd_ref`, `depth_m`, and `date` values
#' will result in many runs of the TUV model and thus take a long time.
#'
#' @inheritParams tuv
#' @inheritParams plc50
#' @inheritParams p_abs
#' @param ... other parameters passed on to the tuv model. See [tuv()]
#'
#' @return A data.frame of all of the input parameters, plus a list column
#'   containing TUV results and NLC50, Pabs, and PLC50 values
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
sens_kd_depth <- function(pah = NULL,
                          lat = NULL,
                          lon = NULL,
                          elev_m = NULL,
                          DOC = NULL,
                          Kd_ref = NULL,
                          depth_m = NULL,
                          date = NULL, 
                          time_multiplier = 2, 
                          ...) {

  stopifnot(is.character(pah) && length(pah) == 1)
  pah <- sanitize_names(pah)
  check_valid_chemicals(pah)

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

  calc_wq_df(df_by_row, pah = pah, time_multiplier = time_multiplier)
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

calc_wq_df <- function(df, pah, time_multiplier) {
  df <- dplyr::ungroup(df)
  dplyr::mutate(
    df,
    pah = pah,
    nlc50 = nlc50(pah[1]),
    pabs = vapply(.data$tuv_res, function(x) {
      p_abs(x, pah[1], time_multiplier)
    }, FUN.VALUE = numeric(1)),
    plc50 = vapply(.data$pabs, function(x) {
      plc50(x, pah[1])
    }, FUN.VALUE = numeric(1))
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
      NLC50: %s ug/L
      Pabs: %s
      PLC50: %s ug/L",
    x$date,
    x$depth_m,
    y_label,
    round(x[[attenuation_var]], 2),
    y_unit,
    round(x$nlc50, 2),
    round(x$pabs, 2),
    round(x$plc50, 2)
  )

  x$.id <- seq_len(nrow(x))

  # Make plc50 NA where Pabs == 0 so we can colour those Grey
  # This has to be done after we make the tooltip so that 
  # the real plc50 value shows up in the tooltip
  # x$plc50[x$pabs < 1e-6] <- NA_real_
  
  # Or a 0.5% percent difference in nlc50 and plc50
  x$plc50[percent_diff(x$plc50, x$nlc50) < 0.5] <- NA_real_

  p <- ggplot2::ggplot(x) +
    ggiraph::geom_tile_interactive(
      mapping = ggplot2::aes(
        x = .data$depth_m,
        y = .data[[attenuation_var]],
        fill = .data$plc50,
        tooltip = .data$.tooltip,
        data_id = .data$.id
      )
    ) +
    ggplot2::scale_fill_viridis_c(option = "inferno", begin = 0.4, direction = 1) +
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
    ggplot2::theme_minimal() +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank()) +
    ggplot2::labs(
      title = paste0(
        "PLC50 of ",
        x$pah[1],
        " across various depths and values of ",
        y_label,
        ", by date"
      ),
      x = "Depth (m)",
      y = paste(y_label, y_unit),
      fill = "PLC50 (ug/L)"
    )

  if (interactive) {
    p <- p +
      ggplot2::theme_minimal(base_size = 7)
    p <- ggiraph::girafe(ggobj = p, ...)
  }
  p
}

percent_diff <- function(a,b) {
  abs(a-b) / mean(c(a,b)) * 100
}
