# Copyright 2026 Canadian Council of Ministers of the Environment
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

marine_kd_crs <- 3979

met_season <- function(date) {
  month <- as.integer(format(as.Date(date), "%m"))
  seasons <- c(
    "winter",
    "winter",
    "spring",
    "spring",
    "spring",
    "summer",
    "summer",
    "summer",
    "fall",
    "fall",
    "fall",
    "winter"
  )
  seasons[month]
}

marine_kd_area <- function(lat, lon, max_dist_km = 25) {
  if (
    !is.numeric(lat) ||
      !is.numeric(lon) ||
      anyNA(c(lat, lon)) ||
      length(lat) != length(lon)
  ) {
    stop(
      "`lat` and `lon` must be non-missing numeric vectors of the same length",
      call. = FALSE
    )
  }

  pts <- data.frame(lon = lon, lat = lat) |>
    sf::st_as_sf(coords = c("lon", "lat"), crs = 4326) |>
    sf::st_transform(marine_kd_crs)

  hits <- sf::st_intersects(pts, marine_kd_polygons)
  idx <- vapply(hits, \(x) if (length(x)) x[[1]] else NA_integer_, integer(1))
  dist_km <- ifelse(is.na(idx), NA_real_, 0)

  outside <- which(is.na(idx))
  if (length(outside)) {
    near <- sf::st_nearest_feature(pts[outside, ], marine_kd_polygons)
    d <- as.numeric(sf::st_distance(
      pts[outside, ],
      marine_kd_polygons[near, ],
      by_element = TRUE
    )) /
      1000

    too_far <- d > max_dist_km
    if (any(too_far)) {
      bad <- outside[too_far][1]
      stop(
        "The location (lat = ",
        lat[bad],
        ", lon = ",
        lon[bad],
        ") is not within ",
        max_dist_km,
        " km of an area with a marine Kd model. ",
        "It may be on land or outside Canadian waters.",
        call. = FALSE
      )
    }

    idx[outside] <- near
    dist_km[outside] <- d
    message(
      "Location is outside the marine Kd model areas; using the nearest area (",
      paste0(
        marine_kd_polygons$area[near],
        " at ",
        round(d, 1),
        " km",
        collapse = "; "
      ),
      ")."
    )
  }

  data.frame(area = marine_kd_polygons$area[idx], dist_km = dist_km)
}

# `model` is one or more rows of `marine_kd_models`
marine_kd_params <- function(model, Kd_wvl = 375) {
  data.frame(
    Kd_ref = 10^(model$intercept + model$slope * Kd_wvl),
    Kd_wvl = Kd_wvl,
    Sk = -model$slope * log(10)
  )
}

#' Look up the marine light attenuation model for a location and date
#'
#' Finds the marine area (ecoregion and clear/turbid water type) that contains
#' the location, and the seasonal model for that area, from the Environment and
#' Climate Change Canada (ECCC, 2026) models of Kd as a function of wavelength.
#'
#' The ECCC models describe the diffuse attenuation coefficient as
#' `log10(Kd(wavelength)) = intercept + slope * wavelength`. They were fitted
#' to satellite observations at visible wavelengths (up to 490 or 555 nm,
#' depending on the area and season) and are extrapolated to shorter
#' wavelengths (down to 280 nm). They are converted to the form used by
#' the TUV model, `Kd(wavelength) = Kd_ref * exp(Sk * (Kd_wvl - wavelength))`,
#' with `Sk = -slope * log(10)` and `Kd_ref = 10^(intercept + slope * Kd_wvl)`.
#' This is exact for any `Kd_wvl`.
#'
#' Seasons are meteorological: winter (December to February), spring (March to
#' May), summer (June to August), and fall (September to November).
#'
#' If a location is not within any area, the nearest area within 25 km is used,
#' with a message. Otherwise an error is raised.
#'
#' @param lat latitude, decimal degrees.
#' @param lon longitude, decimal degrees.
#' @param date date, as a `Date` object or a character in a standard format
#'   (e.g., "YYYY-MM-DD"). `lat`, `lon`, and `date` are recycled to a common
#'   length.
#' @param Kd_wvl reference wavelength in nm at which `Kd_ref` is calculated.
#'   Default `375`.
#'
#' @return A data frame with one row per location and columns `area`,
#'   `ecoregion`, `water_type`, `season`, `Kd_ref`, `Kd_wvl`, `Sk`, `slope`,
#'   `intercept`, `r2`, the quality flags `nodata`, `peak`, `vpf_area`, and
#'   `vpf_time`, and `dist_km` (the distance to the area; `0` if inside it).
#'   `Kd_ref` and `Sk` are `NA` when the model has no data (`nodata` is
#'   `TRUE`), which occurs in some Arctic areas in winter.
#' @export
#'
#' @examples
#' marine_kd_model(lat = 49.15085, lon = -125.91427, date = "2024-06-21")
marine_kd_model <- function(lat, lon, date, Kd_wvl = 375) {
  if (missing(date) || is.null(date)) {
    stop("date must be specified", call. = FALSE)
  }
  date <- as.Date(date)
  if (anyNA(date)) {
    stop("`date` must not be `NA`", call. = FALSE)
  }
  if (!is.numeric(Kd_wvl) || length(Kd_wvl) != 1 || is.na(Kd_wvl)) {
    stop("`Kd_wvl` must be a single number", call. = FALSE)
  }

  n <- max(length(lat), length(lon), length(date))
  lat <- rep_len(lat, n)
  lon <- rep_len(lon, n)
  season <- met_season(rep_len(date, n))

  loc <- marine_kd_area(lat, lon)
  key <- paste(loc$area, season)
  model <- marine_kd_models[
    match(key, paste(marine_kd_models$area, marine_kd_models$season)),
  ]

  res <- data.frame(
    model[c("area", "ecoregion", "water_type", "season")],
    marine_kd_params(model, Kd_wvl),
    model[c(
      "slope",
      "intercept",
      "r2",
      "nodata",
      "peak",
      "vpf_area",
      "vpf_time"
    )],
    dist_km = loc$dist_km
  )
  rownames(res) <- NULL
  res
}

#' Marine areas used for the light attenuation models
#'
#' @return An `sf` data frame with one row per area (ecoregion and
#'   clear/turbid water type), with columns `area`, `ecoregion`, `water_type`,
#'   and `geometry`, in WGS84 (EPSG:4326). The polygons are simplified.
#' @export
#'
#' @examples
#' marine_kd_areas()
marine_kd_areas <- function() {
  sf::st_transform(marine_kd_polygons, 4326)
}
