# Calculate the light absorption of a PAC from a single exposure experiment

Calculate the light absorption of a PAC from a single exposure
experiment

## Usage

``` r
p_abs_single(
  exposure,
  pac,
  time_multiplier = 1,
  irrad_units = c("uW / cm^2 / nm", "W / m^2 / nm")
)
```

## Arguments

- exposure:

  two-column data.frame of exposure results. The first column must
  contain the wavelengths and be called `wl`, the second column must
  contain the irradiance values at each wavelength expressed in units
  defined in the `units` parameter.

- pac:

  name of PAC to calculate light absorption for

- time_multiplier:

  multiplier to get the total exposure over a time period. I.e., if the
  exposure was one second, and you need a 16h exposure, the multiplier
  would be 3600 \* 16

- irrad_units:

  The units in which irradiance is recorded. One of `"uW / cm^2 / nm"`
  (default) or `"W / m^2 / nm"`

## Value

The value of `Pabs` for the exposure results.
