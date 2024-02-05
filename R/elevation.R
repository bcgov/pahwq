#' Get elevation for a lon/lat pair
#'
#' Look up elevation for a point location using Natural Resource Canada's
#' Elevation API: https://natural-resources.canada.ca/science-and-data/science-and-research/earth-sciences/geography/topographic-information/web-services/elevation-api/17328,
#' and if outside of Canada, using the USGS Elevation Point Query Service:
#' https://epqs.nationalmap.gov/v1/docs
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

  if (!is.numeric(lat) || lat <= 24 || lat >= 84) {
    stop("'lat' must be a numeric value between 24 and 84", call. = FALSE)
  }

  # Try NRCAN first, then USGS
  alt <- nrcan_req(lon, lat) %||% epqs_req(lon, lat, signal_no_nrcan = TRUE)

  if (is.null(alt)) {
    stop("No altitude found for given location. Is it outside of Canada and the USA?",
         call. = FALSE)
  }
  round(alt)
}

nrcan_req <- function(lon, lat, model = c("cdem", "cdsm"), endpoint = "altitude") {
  if (lat < 41) return(NULL) # Not in Canada

  model <- match.arg(model)

  req <- httr2::request("https://geogratis.gc.ca/services/elevation/")
  req <- httr2::req_url_path_append(req, model, endpoint)
  req <- httr2::req_user_agent(req, pahwq_user_agent())
  req <- httr2::req_url_query(req, lon = lon, lat = lat)
  req <- httr2::req_headers(req, Accept = 'application/json')

  req <- httr2::req_retry(req, max_tries = 5)
  resp <- httr2::req_perform(req)

  httr2::resp_body_json(resp)$altitude
}

epqs_req <- function(lon, lat, signal_no_nrcan) {

  if (signal_no_nrcan) {
    message(
      "Unable to look up elevation using NRCAN API (point likely outside Canada).
       Trying USGS elevation API..."
    )
  }

  req <- httr2::request("https://epqs.nationalmap.gov")
  req <- httr2::req_url_path_append(req, "v1", "json")
  req <- httr2::req_user_agent(req, pahwq_user_agent())

  req <- httr2::req_url_query(
    req,
    x = lon,
    y = lat,
    wkid = 4326,
    units = "Meters",
    includeDate = "false"
  )
  req <- httr2::req_headers(req, Accept = 'application/json')

  req <- httr2::req_retry(req, max_tries = 5,
                          is_transient = function(x) {
                            httr2::resp_status(x) == 504 ||
                              !httr2::resp_has_body(x)
                          })
  resp <- httr2::req_perform(req)

  if (!httr2::resp_has_body(resp)) {
    stop("Unable to look up elevation using USGS EPQS service", call. = FALSE)
  }

  as.numeric(httr2::resp_body_json(resp)$value)
}

pahwq_user_agent <- function() "pahwq (https://github.com/bcgov/pahwq)"
