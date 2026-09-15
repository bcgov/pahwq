# Set required and optional aquatic parameters for TUV prior to running the model

Set required and optional aquatic parameters for TUV prior to running
the model

## Usage

``` r
set_tuv_aq_params(
  depth_m = NULL,
  lat = NULL,
  lon = NULL,
  elev_m = NULL,
  date = NULL,
  Kd_ref = NULL,
  Kd_wvl = NULL,
  DOC = NULL,
  aq_env = c("freshwater", "marine"),
  tzone = 0L,
  tstart = 0,
  tstop = 23,
  tsteps = 24L,
  wvl_start = 280,
  wvl_end = 800,
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

  depth at which to calculate the light attenuation coefficient.
  Required.

- lat:

  latitude of the site, decimal degrees. Required.

- lon:

  longitude of the site, decimal degrees. Required.

- elev_m:

  elevation of the site above sea level, in metres. If `NULL` (default)
  it is looked up using a digital elevation model using lat and lon.

- date:

  date of the calculation, as `Date` object, or a character in a
  standard format that can be converted to a `Date` object (e.g.,
  "YYYY-MM-DD"). Required.

- Kd_ref:

  Light attenuation coefficient at reference wavelength. Can be set
  directly, or calculated from `DOC`.

- Kd_wvl:

  The reference wavelength at which `Kd_ref` was obtained, in nm.
  Default `305`. Only used if `Kd_ref` is set.

- DOC:

  dissolved organic carbon concentration, in mg/L. Ignored if `Kd_ref`
  is set directly.

- aq_env:

  Aquatic environment: "freshwater" (default) or "marine"? If "marine",
  `Kd_ref` and `Kd_wvl` are set to 0.5 and 375 respectively, as per
  Bricaud (1981). Internally, the constant Sk is set to 0.014.

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

  end wavelength of the calculation, in nm. Default `800`.

- wvl_steps:

  number of wavelength steps to calculate. Default 1 step per nm from
  `wvl_start` and `wvl_end`, inclusive.

- o3_tc:

  The ozone column, in Dobson Units. If `NULL`, it is looked up based on
  latitude and month, based on historic climatology. If there is no
  historic value for the given month and location, a default value of
  300 is used. You can force the use of this default by setting the
  value of this parameter to the string `"default"`.

- tauaer:

  The aerosol optical depth (tau) at 550 nm. If `NULL`, it is looked up
  based on latitude, longitude, and month, based on historic
  climatology. If there is no historic value for the given month and
  location, a default value of 0.235 is used. You can force the use of
  this default by setting the value of this parameter to the string
  `"default"`.

- ...:

  other options passed on to the TUV model. See
  [`tuv_aq_defaults()`](https://bcgov.github.io/pahwq/reference/tuv_aq_defaults.md)

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
# Setting DOC
set_tuv_aq_params(
 depth_m = 0.25,
 lat = 49.601632,
 lon = -119.605862,
 elev_m = 342,
 DOC = 5,
 date = "2023-06-21"
)
# Setting Kd directly (with a different reference wavelength)
set_tuv_aq_params(
 depth_m = 0.25,
 lat = 49.601632,
 lon = -119.605862,
 elev_m = 342,
 Kd_ref = 40,
 Kd_wvl = 280,
 date = "2023-06-21"
)
# In a marine environment, do not set DOC, Kd_ref, or Kd_wvl.
# Set aq_env = "marine"
set_tuv_aq_params(
 depth_m = 0.25,
 lat = 49.601632,
 lon = -119.605862,
 elev_m = 342,
 aq_env = "marine",
 date = "2023-06-21"
)
```
