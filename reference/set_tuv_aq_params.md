# Set required and optional aquatic parameters for TUV prior to running the model

Set required and optional aquatic parameters for TUV prior to running
the model

## Usage

``` r
set_tuv_aq_params(
  depth_m = 0.01,
  lat = NULL,
  lon = NULL,
  elev_m = NULL,
  date = NULL,
  Kd_ref = NULL,
  Kd_wvl = NULL,
  Sk = NULL,
  DOC = NULL,
  aq_env = c("freshwater", "marine"),
  tzone = 0L,
  tstart = 0,
  tstop = 23,
  tsteps = 24L,
  wvl_start = 280,
  wvl_end = 500,
  wvl_steps = wvl_end - wvl_start + 1,
  o3_tc = NULL,
  tauaer = NULL,
  ...,
  write = TRUE,
  tuv_dir = tuv_data_dir()
)
```

## Arguments

- depth_m:

  depth at which to calculate the light attenuation coefficient, in
  metres. Default `0.01` (1 cm), for all water bodies (marine waters,
  lakes and rivers).

- lat:

  latitude of the site, decimal degrees. Required.

- lon:

  longitude of the site, decimal degrees. Required.

- elev_m:

  elevation of the site above sea level, in metres. If `NULL` (default),
  it is `0` in marine waters, and in freshwater it is looked up from a
  digital elevation model using lat and lon.

- date:

  date of the calculation, as `Date` object, or a character in a
  standard format that can be converted to a `Date` object (e.g.,
  "YYYY-MM-DD"). Required.

- Kd_ref:

  Light attenuation coefficient at reference wavelength. In freshwater,
  can be set directly, or calculated from `DOC`. In marine waters, it is
  calculated from the marine model for the location and date
  ([`marine_kd_model()`](https://bcgov.github.io/pahwq/reference/marine_kd_model.md))
  unless set here.

- Kd_wvl:

  The reference wavelength at which `Kd_ref` was obtained, in nm.
  Default `305` in freshwater, where it is only used if `Kd_ref` is set,
  and `375` in marine waters, where if only `Kd_wvl` is set, `Kd_ref` is
  recalculated from the model at that wavelength, and the attenuation
  curve is unchanged.

- Sk:

  spectral slope: the slope of the exponential decay of Kd with
  wavelength, in nm^-1. If `NULL` (default), `0.018` in freshwater, and
  from the marine model for the location and date in marine waters
  ([`marine_kd_model()`](https://bcgov.github.io/pahwq/reference/marine_kd_model.md)).
  In marine waters, it can only be set together with `Kd_ref`.

- DOC:

  dissolved organic carbon concentration, in mg/L. Ignored if `Kd_ref`
  is set directly.

- aq_env:

  Aquatic environment: "freshwater" (default) or "marine"? If "marine",
  the light attenuation is calculated from models for the ecoregion,
  water type, and season of the site (see
  [`marine_kd_model()`](https://bcgov.github.io/pahwq/reference/marine_kd_model.md)).
  `DOC` cannot be set. `Kd_ref`, `Kd_wvl` and `Sk` can be set to
  override the model: those not set come from the model, with a message
  when `Sk` does. `Sk` can only be set together with `Kd_ref`. If both
  `Kd_ref` and `Sk` are set, the model is not used, so the site can be
  anywhere. Where the model has no data, or the site is not within 25 km
  of a marine model area (e.g., outside Canadian waters), `Kd_ref` and
  `Sk` must be set. A warning is given when the model is flagged as
  having few valid pixels across the area (`VPFAREA`) or over time
  (`VPFTIME`).

- tzone:

  timezone offset from UTC, in hours. Default `0`.

- tstart:

  start time of the calculation, in hours. Default `0`.

- tstop:

  stop time of the calculation, in hours. Default `23`.

- tsteps:

  number of time steps to calculate. Must be between `1` and `24`,
  default `24`.

- wvl_start:

  start wavelength of the calculation, in nm. Default `280`.

- wvl_end:

  end wavelength of the calculation, in nm. Default `500`.

- wvl_steps:

  number of wavelength steps to calculate. Default 1 step per nm from
  `wvl_start` and `wvl_end`, inclusive.

- o3_tc:

  The ozone column, in Dobson Units. If `NULL`, it is looked up based on
  latitude and month, based on historic climatology (Fortuin and Kelder
  1998, in 10 degree latitude bands). You can instead use the TUV
  default of 300 by setting the value of this parameter to the string
  `"default"`.

- tauaer:

  The aerosol optical depth (tau) at 550 nm. If `NULL`, it is looked up
  based on latitude, longitude, and month, based on historic climatology
  (MODIS-Aqua monthly means, 2002-2023, at 1 degree resolution). If
  there is no historic value for the given month and location, a default
  value of 0.235 is used. You can force the use of this default by
  setting the value of this parameter to the string `"default"`.

  The default is from TUV, from the Elterman (1968) continental aerosol
  profile. There is no value in the MODIS climatology for many locations
  in winter, especially north of 50 degrees N, so the default is more
  likely to be used from November to March.

- ...:

  other options passed on to the TUV model. See
  [`tuv_aq_defaults()`](https://bcgov.github.io/pahwq/reference/tuv_aq_defaults.md).

- write:

  should the options be written to `inp_aq` in the TUV directory?
  Default `TRUE`.

- tuv_dir:

  the directory where the compiled TUV executable is located

## Value

the options as a character vector, invisibly

## See also

[`tuv_aq_defaults()`](https://bcgov.github.io/pahwq/reference/tuv_aq_defaults.md)

## Examples

``` r
# Setting DOC, at the default depth of 1 cm
set_tuv_aq_params(
 lat = 49.601632,
 lon = -119.605862,
 elev_m = 342,
 DOC = 5,
 date = "2023-06-21"
)
# Setting Kd directly (with a different reference wavelength), at 25 cm
set_tuv_aq_params(
 depth_m = 0.25,
 lat = 49.601632,
 lon = -119.605862,
 elev_m = 342,
 Kd_ref = 40,
 Kd_wvl = 280,
 date = "2023-06-21"
)
# In a marine environment, Kd is looked up from the location and date.
# Do not set DOC.
set_tuv_aq_params(
 lat = 49.15085,
 lon = -125.91427,
 aq_env = "marine",
 date = "2023-06-21"
)
```
