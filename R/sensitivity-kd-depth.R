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
#'
#' @inheritParams tuv
#' @inheritParams plc50
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
                          date = NULL, ...) {

  stopifnot(is.character(pah) && length(pah) == 1)
  pah <- sanitize_names(pah)
  check_valid_chemicals(pah)

  stopifnot(is.numeric(lat) && length(lat) == 1)
  stopifnot(is.numeric(lon) && length(lon) == 1)
  stopifnot(is.numeric(depth_m))

  date <- as.Date(date)

  attenuation <- list(DOC = DOC, Kd_ref = Kd_ref)
  attenuation_var <- names(which(vapply(
    attenuation,
    Negate(is.null),
    FUN.VALUE = logical(1)
  )))

  attenuation_abort <- function() {
    stop("Either `Kd_ref` or `DOC` must be numeric", call. = FALSE)
  }

  if (length(attenuation_var) != 1L) {
    attenuation_abort()
  }
  attenuation_vals <- attenuation[[attenuation_var]]
  if (!is.numeric(attenuation_vals)) {
    attenuation_abort()
  }

  elev_m <- elev_m %||% get_elevation(lon, lat)
  stopifnot(is.numeric(elev_m))

  grid <- expand.grid(
    lat = lat,
    lon = lon,
    elev_m = elev_m,
    attenuation = attenuation_vals,
    depth_m = depth_m,
    date = date,
    ...,
    stringsAsFactors = FALSE
  )

  names(grid)[names(grid) == "attenuation"] <- attenuation_var

  n_iter <- nrow(grid)

  if (n_iter > 100) {
    warning(
      "Initiating ",
      n_iter,
      " iterations of the TUV model. This could take a while",
      call. = FALSE
    )
  }

  df_by_row <- dplyr::rowwise(grid)

  df_by_row <- dplyr::mutate(
    df_by_row,
    tuv_res = list(call_tuv(
      attenuation = .data[[attenuation_var]],
      attenuation_var = attenuation_var,
      date = .data$date,
      lat = .data$lat,
      lon = .data$lon,
      elev_m = .data$elev_m,
      depth_m = .data$depth_m,
      ...
    ))
  )

  df <- dplyr::ungroup(df_by_row)
  df <- dplyr::mutate(
    df,
    pah = pah,
    nlc50 = nlc50(pah[1]),
    pabs = vapply(.data$tuv_res, function(x) {
      p_abs(x, pah[1])
    }, FUN.VALUE = numeric(1)),
    plc50 = vapply(.data$pabs, function(x) {
      plc50(x, pah[1])
    }, FUN.VALUE = numeric(1))
  )

  df
}

call_tuv <- function(attenuation, attenuation_var, ...) {
  args <- c(attenuation, list(...))

  names(args)[1] <- attenuation_var

  do.call("tuv", c(args, quiet = TRUE))
}

#' Make a heatmap of the sensitivity analysis performed by [sens_kd_depth()]
#'
#' @param x A data.frame, the output of [sens_kd_depth()]
#'
#' @return a ggplot2 object
#' @export
#'
#' @examples
#' out <- sens_kd_depth(
#'   "Anthracene",
#'   lat = 52,
#'   lon = -113,
#'   Kd_ref = 40:45,
#'   depth_m = c(0.25, 0.5, 1),
#'   date = c("2023-07-01", "2023-08-01")
#' )
#' plot_sens_kd_depth(out)
plot_sens_kd_depth <- function(x) {
  attenuation_var <- intersect(c("DOC", "Kd_ref"), names(x))

  ggplot2::ggplot(x) +
    ggplot2::geom_tile(
      ggplot2::aes(
        x = .data[[attenuation_var]],
        y = .data$depth_m,
        fill = .data$plc50
      )
    ) +
    ggplot2::scale_fill_viridis_c(option = "inferno") +
    ggplot2::scale_x_continuous(
      breaks = if (length(unique(x[[attenuation_var]])) < 5) {
        unique(x[[attenuation_var]])
      } else {
        ggplot2::waiver()
      }
    ) +
    ggplot2::scale_y_continuous(
      breaks = if (length(unique(x$depth_m)) < 5) {
        unique(x$depth_m)
      } else {
        ggplot2::waiver()
      }
    ) +
    ggplot2::facet_wrap(ggplot2::vars(.data$date)) +
    ggplot2::theme_minimal() +
    ggplot2::theme(panel.grid.minor = ggplot2::element_blank()) +
    ggplot2::labs(
      title = paste0("PLC50 of ", x$pah[1], " across various depths and values of ",
                    attenuation_var, ", by date"),
      x = if (attenuation_var == "DOC") "DOC (mg/L)" else "Kd(ref)",
      y = "Depth (m)",
      fill = "PLC50 (ug/L)"
    )
}
