get_o3_column <- function(lat = NULL, month = NULL) {
  if (!is.wholenumber(month) || month < 1 || month > 12) {
    stop("month must be an integer between 1 and 12")
  }
  if (!is.numeric(lat) || lat < -85 || lat > 85) {
    stop("lat must be a numeric value between -85 and 85")
  }

  latcol <- findInterval(lat, seq(-85, +85, length.out = 18), all.inside = TRUE)
  out_val <- o3[month, latcol, drop = TRUE]
  if (is.na(out_val)) out_val <- 300
  out_val
}

get_aerosol_tau <- function(lat = NULL, lon = NULL, month = NULL) {
  if (!is.wholenumber(month) || month < 1 || month > 12) {
    stop("month must be an integer between 1 and 12")
  }
  if (!is.numeric(lat) || lat <= -90 || lat >= 90) {
    stop("lat must be a numeric value between -90 and 90")
  }
  if (!is.numeric(lon) || lat <= -180 || lat >= 180) {
    stop("lat must be a numeric value between -90 and 90")
  }
  # The rows are sorted N (+ve) to S (-ve), but findInterval works only on a positively
  # sorted vector, so need to reverse the lookup interval
  month <- sprintf("%02i", month)
  latrow <- nrow(aerosol) - findInterval(lat, seq(-90, 90, length.out = 181), all.inside = TRUE) + 1
  loncol <- findInterval(lon, seq(-180, 180, length.out = 361), all.inside = TRUE)

  out_val <- aerosol[latrow, loncol, month, drop = TRUE]
  # If no value, use default constant
  if (is.na(out_val)) {
    message("Unable to find a historical value for aerosol optical depth. Using default value tauaer = 0.235")
    out_val <- 0.235
  }
  out_val
}
