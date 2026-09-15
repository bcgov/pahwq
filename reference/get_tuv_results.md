# Retrieve the results of a TUV run

Retrieve the results of a TUV run

## Usage

``` r
get_tuv_results(file = "out_irrad_y", tuv_dir = tuv_data_dir())
```

## Arguments

- file:

  one of "out_irrad_y", "out_aflux_y", "out_irrad_ave", "out_aflux_ave",
  "out_irrad_atm", "out_aflux_atm". Default is `"out_irrad_y"`, for
  input into
  [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md).

- tuv_dir:

  the directory where the compiled TUV executable is located

## Value

A data.frame with the results of the TUV run. It contains columns
specifying wavelength and calculated Kd(lambda), and a column for each
timestamp containing the irradiance at that time and wavelength, in W
m-2 nm-1.
