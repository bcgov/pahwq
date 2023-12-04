library(pahwq)
library(dplyr)

sites <- structure(list(emsid = c("0400390", "0500236", "E207466"), name = c("CHARLIE L DEEP STATION 1.2 KM EAST OF PARK",
                                                                    "OKANAGAN L D/S KELOWNA STP (DEEP)", "QUAMICHAN LAKE; CENTRE"
), lon = c(-120.9642, -119.5134, -123.6625), lat = c(56.3125,
                                                     49.8614, 48.8003), elev_m = c(693, 342, 25), date = c("2023-08-01",
                                                                                                           "2023-08-01", "2023-08-01"), DOC = c(14, 4.26, 6.61), doc_min = c(0.96,
                                                                                                                                                                             4.06, 6.37), doc_max = c(15.4, 5.17, 11.8)), row.names = c(NA,
                                                                                                                                                                                                                                        -3L), class = c("tbl_df", "tbl", "data.frame"))

multi_tuv <- function(df, site = "name", pah, varying, vals = NULL, ...) {
  if (!varying %in% union(names(tuv_aq_defaults()), names(formals(set_tuv_aq_params)))) {
    stop(varying, " is not a valid argument for `set_tuv_aq_params()`")
  }

  if (!is.null(vals)) {
    var_df <- data.frame(vals)
    names(var_df) <- varying

    df <- df |>
      select(!any_of(varying)) |>
      cross_join(var_df)
  }

  df |>
    rowwise() |>
    mutate(
      Pabs = calc_Pabs(
        date = date,
        lat = lat,
        lon = lon,
        elev_m = elev_m,
        pah = pah,
        varying = .data[[varying]],
        vary_var = varying,
        ...
      ),
      plc50 = plc50(Pabs, pah = pah),
      plc_nlc_ratio = plc50 / nlc50(pah)
    )
}

calc_Pabs <- function(date, lat, lon, elev_m, pah, varying, vary_var, ...) {
  args <- c(
    varying,
    list(
      depth_m = 0.25,
      date = as.Date(date),
      lat = lat,
      lon = lon,
      elev_km = elev_m / 1000
    ),
    ...
  )
  names(args)[1] <- vary_var

  # allow overriding of one of the core args by one supplied in 'varying',
  # this will keep the first of duplicated argument names, which will
  # be the one in 'varying'
  args <- args[unique(names(args))]

  do.call("set_tuv_aq_params", args)

  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  p_abs(res, pah)
}

ret <- multi_tuv(sites,
          pah = "Anthracene",
          varying = "nstr",
          vals = c(-2, 4, 8, 16, 32),
          DOC = 5,
          o3_tc = 300,
          tauaer = 0.235)
