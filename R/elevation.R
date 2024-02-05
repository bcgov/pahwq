#' Get elevation for a lon/lat pair
#'
#' Look up elevation for a point location using Natural Resource Canada's
#' Elevation API: https://natural-resources.canada.ca/science-and-data/science-and-research/earth-sciences/geography/topographic-information/web-services/elevation-api/17328
#'
#' @param lon Longitude: number between -140 and -53
#' @param lat Latitude: number 41 and 84
#'
#' @return Elevation, in m
#' @export
#'
#' @examples
#' get_elevation(-115, 53)
get_elevation <- function(lon, lat) {
 if (!is.numeric(lon) || lon <= -140 || lon >= -53) {
   stop("'lon' must be a numeric value between -140 and -53", call. = FALSE)
 }

 if (!is.numeric(lat) || lat <= 41 || lat >= 84) {
   stop("'lat' must be a numeric value between 41 and 84", call. = FALSE)
 }

  req <- elev_base_req()
  req <- httr2::req_url_query(req, lat = lat, lon = lon)
  resp <- httr2::req_perform(req)
  alt <- httr2::resp_body_json(resp)$altitude

  if (is.null(alt)) {
    stop("No altitude found for given location. Is it outside of Canada?",
         call. = FALSE)
  }
  alt
}

elev_base_req <- function(model = c("cdem", "cdsm"), endpoint = "altitude") {
  model <- match.arg(model)
  base_url <- "https://geogratis.gc.ca/services/elevation/"
  req <- httr2::request(base_url)
  req <- httr2::req_url_path_append(req, model, endpoint)
  httr2::req_user_agent(req, "pahwq (https://github.com/bcgov/pahwq)")
}
