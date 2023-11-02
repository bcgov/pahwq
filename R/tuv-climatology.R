get_o3_column <- function(lat, month) {
  if (!is.wholenumber(month) || month < 1 || month > 12) {
    stop("month must be an integer between 1 and 12")
  }
  if (!is.numeric(lat) || lat < -85 || lat > 85) {
    stop("lat must be a numeric value between -85 and 85")
  }

  latcol <- findInterval(lat, seq(-85, +85, length.out = 18), all.inside = TRUE)
  o3[month, latcol]
}
