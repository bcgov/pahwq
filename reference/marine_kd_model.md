# Look up the marine light attenuation model for a location and date

Finds the marine area (ecoregion and clear/turbid water type) that
contains the location, and the seasonal model for that area, from the
Environment and Climate Change Canada (ECCC, 2026) models of Kd as a
function of wavelength.

## Usage

``` r
marine_kd_model(lat, lon, date, Kd_wvl = 375)
```

## Arguments

- lat:

  latitude, decimal degrees.

- lon:

  longitude, decimal degrees.

- date:

  date, as a `Date` object or a character in a standard format (e.g.,
  "YYYY-MM-DD"). `lat`, `lon`, and `date` are recycled to a common
  length.

- Kd_wvl:

  reference wavelength in nm at which `Kd_ref` is calculated. Default
  `375`.

## Value

A data frame with one row per location and columns `area`, `ecoregion`,
`water_type`, `season`, `Kd_ref`, `Kd_wvl`, `Sk`, `slope`, `intercept`,
`r2`, the quality flags `nodata`, `peak`, `vpf_area`, and `vpf_time`,
and `dist_km` (the distance to the area; `0` if inside it). `Kd_ref` and
`Sk` are `NA` when the model has no data (`nodata` is `TRUE`), which
occurs in some Arctic areas in winter.

## Details

The ECCC models describe the diffuse attenuation coefficient as
`log10(Kd(wavelength)) = intercept + slope * wavelength`. They were
fitted to satellite observations at visible wavelengths (up to 490 or
555 nm, depending on the area and season) and are extrapolated to
shorter wavelengths (down to 280 nm). They are converted to the form
used by the TUV model,
`Kd(wavelength) = Kd_ref * exp(Sk * (Kd_wvl - wavelength))`, with
`Sk = -slope * log(10)` and `Kd_ref = 10^(intercept + slope * Kd_wvl)`.
This is exact for any `Kd_wvl`.

Seasons are meteorological: winter (December to February), spring (March
to May), summer (June to August), and fall (September to November).

If a location is not within any area, the nearest area within 25 km is
used, with a message. Otherwise an error is raised.

## Examples

``` r
marine_kd_model(lat = 49.15085, lon = -125.91427, date = "2024-06-21")
#>                    area      ecoregion water_type season   Kd_ref Kd_wvl
#> 1 Southern_Shelf_Turbid Southern Shelf     turbid summer 0.846611    375
#>            Sk        slope intercept        r2 nodata  peak vpf_area vpf_time
#> 1 0.008755957 -0.003802664  1.353683 0.9808947  FALSE FALSE    FALSE    FALSE
#>   dist_km
#> 1       0
```
