# Sensitivity analysis for DOC, depth, and time of year

Enter a single location and PAH, and a range of values for `DOC` or
`Kd_ref`, water depth, and dates and get back a data.frame of narcotic
benchmark, Pabs, and phototoxic benchmark values.

## Usage

``` r
sens_kd_depth(
  pah = NULL,
  lat = NULL,
  lon = NULL,
  elev_m = NULL,
  DOC = NULL,
  Kd_ref = NULL,
  depth_m = NULL,
  date = NULL,
  time_multiplier = 2,
  ...
)
```

## Arguments

- pah:

  The PAH of interest, which is used to calculate the narcotic benchmark
  value.

- lat:

  latitude of the site, decimal degrees. Required.

- lon:

  longitude of the site, decimal degrees. Required.

- elev_m:

  elevation of the site above sea level, in metres. If `NULL` (default)
  it is looked up using a digital elevation model using lat and lon.

- DOC:

  dissolved organic carbon concentration, in mg/L. Ignored if `Kd_ref`
  is set directly.

- Kd_ref:

  Light attenuation coefficient at reference wavelength. Can be set
  directly, or calculated from `DOC`.

- depth_m:

  depth at which to calculate the light attenuation coefficient.
  Required.

- date:

  date of the calculation, as `Date` object, or a character in a
  standard format that can be converted to a `Date` object (e.g.,
  "YYYY-MM-DD"). Required.

- time_multiplier:

  If x is a `tuv_results` data frame, this is the multiplier to get the
  total exposure time. I.e., if the tuv_results contains 24 hours of
  data, and you need a 48h exposure, the multiplier would be 2 (this is
  the default). Ignored if `x` is a numeric value of light absorption.

- ...:

  other parameters passed on to the tuv model. See
  [`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md)

## Value

A data.frame of all of the input parameters, plus a list column
containing TUV results and narcotic benchmark, Pabs, and phototoxic
benchmark values

## Details

You can add other variables beyond those listed explicitly, but if there
are too many combinations it will create many runs of the TUV model,
which can take a long time. Explicit variable checking is only performed
on `pah`, `lat`, `lon`, `elev_m`, `DOC`, `Kd_ref`, `depth`, and
`months`. Passing invalid values of other parameters may cause cryptic
errors or unexpected results. Note that combinations of many `DOC`,
`Kd_ref`, `depth_m`, and `date` values will result in many runs of the
TUV model and thus take a long time.

## Examples

``` r
sens_kd_depth(
  "Anthracene",
  lat = 52,
  lon = -113,
  Kd_ref = 40:45,
  depth_m = c(0.25, 0.5, 1),
  date = c("2023-07-01", "2023-08-01")
)
#> # A tibble: 36 × 11
#>      lat   lon elev_m depth_m date       Kd_ref tuv_res               pah       
#>    <dbl> <dbl>  <dbl>   <dbl> <date>      <int> <list>                <chr>     
#>  1    52  -113    880    0.25 2023-07-01     40 <tv_rslts [521 × 28]> anthracene
#>  2    52  -113    880    0.5  2023-07-01     40 <tv_rslts [521 × 28]> anthracene
#>  3    52  -113    880    1    2023-07-01     40 <tv_rslts [521 × 28]> anthracene
#>  4    52  -113    880    0.25 2023-08-01     40 <tv_rslts [521 × 28]> anthracene
#>  5    52  -113    880    0.5  2023-08-01     40 <tv_rslts [521 × 28]> anthracene
#>  6    52  -113    880    1    2023-08-01     40 <tv_rslts [521 × 28]> anthracene
#>  7    52  -113    880    0.25 2023-07-01     41 <tv_rslts [521 × 28]> anthracene
#>  8    52  -113    880    0.5  2023-07-01     41 <tv_rslts [521 × 28]> anthracene
#>  9    52  -113    880    1    2023-07-01     41 <tv_rslts [521 × 28]> anthracene
#> 10    52  -113    880    0.25 2023-08-01     41 <tv_rslts [521 × 28]> anthracene
#> # ℹ 26 more rows
#> # ℹ 3 more variables: narcotic_benchmark <dbl>, pabs <dbl>,
#> #   phototoxic_benchmark <dbl>
```
