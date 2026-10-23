# Calculate Kd at a given wavelength in marine waters.

Uses the seasonal marine model for the area containing the location,
from
[`marine_kd_model()`](https://bcgov.github.io/pahwq/reference/marine_kd_model.md).
Errors if the model has no data for that area and season.

## Usage

``` r
kd_marine(wavelength, lat, lon, date)
```

## Arguments

- wavelength:

  lambda wavelength in nm

- lat:

  latitude, decimal degrees.

- lon:

  longitude, decimal degrees.

- date:

  date, as a `Date` object or a character in a standard format (e.g.,
  "YYYY-MM-DD"). `lat`, `lon`, and `date` are recycled to a common
  length.

## Value

A numeric vector representing Kd at a given wavelength in marine waters

## Examples

``` r
kd_marine(400, lat = 49.15085, lon = -125.91427, date = "2024-06-21")
#>       400 
#> 0.6801697 
```
