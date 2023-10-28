# Copyright 2023 Province of British Columbia
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

#' Call TUV program
#'
#' @param tuv_dir the directory where the compiled TUV executable is located
#' @param quiet Should the progress of the TUV program be printed to the console?
#'
#' @export
tuv <- function(tuv_dir = tuv_data_dir(), quiet = FALSE) {

  check_tuv_dir(tuv_dir)

  ## Must call tuv in the dir in which it lives so it can find accessory files
  withr::with_dir(tuv_dir, {
    system2(tuv_cmd(), stdout = if (quiet) FALSE else "")
  })
}

#' Retrieve results of TUV run
#'
#' @param file one of "out_irrad_y", "out_aflux_y", "out_irrad_ave",
#'     "out_aflux_ave", "out_irrad_atm", "out_aflux_atm"
#' @inheritParams tuv
#'
#' @return A data.frame with the results of the TUV run
#' @export
get_tuv_results <- function(file = "out_irrad_y", tuv_dir = tuv_data_dir()) {
  check_tuv_dir(tuv_dir)

  if (!file %in% tuv_out_files()) {
    stop("file must be one of: ", paste(tuv_out_files(), collapse = ", "))
  }

  fpath <- file.path(tuv_dir, "AQUA", file)

  header <- tuv_results_header(fpath)

  res <- utils::read.table(fpath, header = FALSE, col.names = header, skip = 2)
  res$wl <- (res$wavelength_start + res$wavelength_end) / 2
  res
}

check_tuv_dir <- function(tuv_dir) {
  if (is.null(tuv_dir)) {
    stop("Please set the path to your tuv executable with:
             options(tuv_dir = 'path'", call. = FALSE)
  }

  if (!dir.exists(tuv_dir)) {
    stop("specified tuv directory does not exist", call. = FALSE)
  }
}

tuv_results_header <- function(path) {
  l <- readLines(path, n = 1)
  header <- strsplit(l, "\\s+")[[1]]
  header <- gsub("^([0-9]{1,2})", "t_\\1", header)
  header <- sub("wl", "wavelength_start", header)
  header <- sub("wu", "wavelength_end", header)
  sub("Kvat", "Kd_lambda", header)
}

tuv_cmd <- function() {
  if (.Platform$OS.type == "windows") {
    return("tuv.exe")
  } else {
    "./tuv"
  }
}

tuv_out_files <- function() {
  c(
    "out_irrad_y",
    "out_aflux_y",
    "out_irrad_av",
    "out_aflux_av",
    "out_irrad_atm",
    "out_aflux_atm"
  )
}

#' Title
#'
#' @param depth_m depth at which to calculate the light attenuation coefficient.
#'   Required.
#' @param lat latitude of the site, decimal degrees. Required.
#' @param lon longitude of the site, decimal degrees. Required.
#' @param elev_km elevation of the site above sea level, in kilometres. Required.
#' @param date date of the calculation, as `Date` object, or a character in a
#'   standard format that can be converted to a `Date` object (e.g.,
#'   "YYYY-MM-DD"). Required.
#' @param DOC dissolved organic carbon concentration, in mg/L. Required.
#' @param tzone timezone offset from UTC, in hours. Default `0`.
#' @param tstart start time of the calculation, in hours. Default `0`.
#' @param tstop stop time of the calculation, in hours. Default `23`.
#' @param tsteps number of time steps to calculate. Default `24`.
#' @param wvl_start start wavelength of the calculation, in nm. Default `279.5`.
#' @param wvl_end end wavelength of the calculation, in nm. Default `400.5`.
#' @param wvl_steps number of wavelength steps to calculate. Default `121`.
#' @param ... other options passed on to the TUV model. See [inp_aq_defaults()]
#' @param write should the options be written to `inp_aq` in the TUV directory? Default `TRUE`.
#' @inheritParams tuv
#'
#' @return the options as a character vector, invisibly
#' @export
setup_tuv_options <- function(depth_m = NULL,
                              lat = NULL,
                              lon = NULL,
                              elev_km = NULL,
                              date = NULL,
                              DOC = NULL,
                              tzone = 0L,
                              tstart = 0,
                              tstop = 23,
                              tsteps = 24L,
                              wvl_start = 279.5,
                              wvl_end = 400.5,
                              wvl_steps = 121L,
                              ...,
                              write = TRUE,
                              tuv_dir = tuv_data_dir()) {

  check_tuv_dir(tuv_dir)

  if (is.null(date)) {
    stop("date must be specified", call. = FALSE)
  }

  date = as.Date(date)
  year = as.integer(format(date, "%Y"))
  month = as.integer(format(date, "%m"))
  day = as.integer(format(date, "%d"))

  if (!is.numeric(DOC)) {
    stop("DOC must be numeric", call. = FALSE)
  }

  if (DOC < 0.2 || DOC > 23) {
    warning("Estimating the light attenuation coefficient (Kd) from DOC works
            best for DOC values between 0.2 and 23 mg/L.", call. = FALSE)
  }

  Kd <- kd_305(DOC = DOC)

  opts <- c(
    list(
      Kd = Kd,
      depth_m = depth_m,
      lat = lat,
      lon = lon,
      elev_km = elev_km,
      year = year,
      month = month,
      day = day,
      tzone = tzone,
      tstart = tstart,
      tstop = tstop,
      tsteps = tsteps,
      wvl_start = wvl_start,
      wvl_end = wvl_end,
      wvl_steps = wvl_steps
    ),
    list(...)
  )

  input_values <- utils::modifyList(inp_aq_defaults(), opts, keep.null = FALSE)

  check_data_fields(input_values)

  tuv_options <- render_inp_aq(input_values)

  if (write) {
    write_file(file.path(tuv_dir, "AQUA", "inp_aq"), tuv_options)
  }
  invisible(tuv_options)
}

render_inp_aq <- function(data = list()) {

  template_path <- system.file("inp_aq_template", package = "pahwq")

  template <- readLines(template_path, n = -1L, encoding = "UTF-8", warn = FALSE)

  strsplit(whisker::whisker.render(template, data), "\n")[[1]]
}

check_data_fields <- function(data) {
    missing <- setdiff(names(inp_aq_defaults()), names(data))
    extra <- setdiff(names(data), names(inp_aq_defaults()))

    if (length(extra) > 0) {
      warning("Extra fields will be ignored: ", paste(extra, collapse = ", "), call. = FALSE)
    }

    if (length(missing) > 0) {
      stop("Missing required fields: ", paste(missing, collapse = ", "), call. = FALSE)
    }

    # Check all fields are the right type:
    for (field in names(data)) {
        if (typeof(data[[field]]) != typeof(inp_aq_defaults()[[field]])) {
          stop("Field '", field, "' must be of type '", typeof(inp_aq_defaults()[[field]]), "'", call. = FALSE)
        }
    }

    invisible(TRUE)
}

#' Get a list of TUV inputs and their default values
#'
#' Inputs that don't have a default value and thus are required to be specified
#' in `set_tup_options()` are shown as an empty vector of the required data type.
#'
#' @return a list of TUV inputs and their default values
#' @export
inp_aq_defaults <- function() {
  list(
    Kd = double(),
    Sk = 0.018,
    ref_wvl = 305.,   # a,b,c for: kvdom = a exp(-b(wvl-c)). ACT: a = kd(305), b = Sk, c = wavelength (ref_wvl = 305)
    depth_m = double(), #  ! ydepth, m
    lat = double(), # ! lat, negative S of Equator
    lon = double(), # ! lon, negative W of Greenwich (zero) meridian
    elev_km = double(), #  ! surface elevation, km above sea level
    year = integer(), #  ! iyear
    month = integer(), # ! imonth
    day = integer(), # ! iday
    tzone = 0L, #  ! timezone  Local Time - UTC
    tstart = 0., #  ! tstart, hours local time
    tstop = 23., #  ! tstop, hours local time
    tsteps = 24L, #  ! number of time steps
    albedo = 0.1, # ! surface albedo
    o3_tc = 300L, #  ! o3_tc  ozone column, Dobson Units (DU)
    so2_tc = 0L, # ! so2_tc SO2 column, DU
    no2_tc = 0L, # ! no2_tc NO2 column, DU
    taucld = 0L, # ! taucld - cloud optical depth
    zbase = 4, #  ! zbase - cloud base, km
    ztop = 5, # ! ztop - cloud top, km
    tauaer = 0.235, # ! tauaer - aerosol optical depth at 550 nm
    ssaaer = 0.990, # ! ssaaer - aerosol single scattering albedo
    alpha = 1.0, #  ! alpha - aerosol Angstrom exponent
    wvl_start = 279.5, #  ! starting wavelength, nm
    wvl_end = 400.5, #  ! end wavelength, nm
    wvl_steps = 121L, #  ! number of wavelength intervals
    nstr = -2L, #! nstr, use -2 for fast, 4 for slightly more accurate
    out_irrad_y = "T", #  ! out_irrad_y, T/F, planar spectral irradiance at ydepth
    out_aflux_y = "T", #  ! out_aflux_y, T/F, scalar spectral irradiance (actinic flux)  at depth
    out_irrad_ave = "T", #  ! out_irrad_ave, T/F, planar irrad., averaged 0-ydepth
    out_aflux_ave = "T", #  ! out_aflux_ave, T/F, scalar, ave 0-ydepth
    out_irrad_atm = "T", #  ! out_irrad_atm, T/F, planar, in atmosphere
    out_aflux_atm = "T" #  ! out_aflux_atm, T/F, scalar, in atmosphere
  )
}

write_file <- function(path, lines, append = FALSE) {
  file_mode <- if (append) "ab" else "wb"
  con <- file(path, open = file_mode, encoding = "utf-8")
  withr::defer(close(con))

  # convert embedded newlines
  lines <- gsub("\r?\n", "\n", lines)
  base::writeLines(enc2utf8(lines), con, sep = "\n", useBytes = TRUE)

  invisible(TRUE)
}
