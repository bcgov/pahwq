
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pahwq

<!-- badges: start -->

[![R-CMD-check](https://github.com/ateucher/pahwq/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ateucher/pahwq/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

## Installation

You can install the development version of pahwq from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ateucher/pahwq")
```

## Example

``` r
library(pahwq)

# Set the options for the TUV model run:
setup_tuv_options(
  depth_m = 0.25,
  lat = 49.601632,
  lon = -119.605862,
  elev_km = 0.342,
  DOC = 5,
  date = "2023-06-21",
  tzone = -8L
)

# Run the TUV model
tuv()

res <- get_tuv_results(file = "out_irrad_y")
head(res)
#>   wavelength_start wavelength_end Kd_lambda t_0.0 t_1.0 t_2.0 t_3.0    t_4.0
#> 1            279.5          280.5      31.5     0     0     0     0 1.67e-33
#> 2            280.5          281.5      31.0     0     0     0     0 6.23e-31
#> 3            281.5          282.5      30.4     0     0     0     0 2.61e-28
#> 4            282.5          283.5      29.9     0     0     0     0 7.13e-27
#> 5            283.5          284.5      29.3     0     0     0     0 3.91e-25
#> 6            284.5          285.5      28.8     0     0     0     0 1.40e-23
#>      t_5.0    t_6.0    t_7.0    t_8.0    t_9.0   t_10.0   t_11.0   t_12.0
#> 1 5.31e-33 1.03e-32 2.56e-32 2.54e-29 1.86e-25 3.99e-23 7.28e-22 1.84e-21
#> 2 1.98e-30 3.85e-30 9.89e-30 7.51e-27 2.48e-23 3.32e-21 4.74e-20 1.11e-19
#> 3 8.27e-28 1.63e-27 4.33e-27 2.47e-24 3.59e-21 2.99e-19 3.31e-18 7.15e-18
#> 4 2.26e-26 4.49e-26 1.22e-25 5.89e-23 5.39e-20 3.41e-18 3.27e-17 6.73e-17
#> 5 1.24e-24 2.50e-24 7.06e-24 2.68e-21 1.32e-18 5.81e-17 4.59e-16 8.89e-16
#> 6 4.44e-23 9.06e-23 2.70e-22 7.82e-20 2.03e-17 6.14e-16 3.97e-15 7.23e-15
#>     t_13.0   t_14.0   t_15.0   t_16.0   t_17.0   t_18.0   t_19.0   t_20.0
#> 1 7.40e-22 4.13e-23 1.97e-25 2.79e-29 2.59e-32 1.03e-32 5.34e-33 1.70e-33
#> 2 4.81e-20 3.43e-21 2.61e-23 8.19e-27 1.00e-29 3.88e-30 1.99e-30 6.35e-31
#> 3 3.36e-18 3.08e-19 3.77e-21 2.67e-24 4.39e-27 1.64e-27 8.32e-28 2.66e-28
#> 4 3.31e-17 3.50e-18 5.64e-20 6.33e-23 1.24e-25 4.52e-26 2.28e-26 7.26e-27
#> 5 4.64e-16 5.95e-17 1.37e-18 2.86e-21 7.16e-24 2.51e-24 1.25e-24 3.98e-25
#> 6 4.01e-15 6.27e-16 2.11e-17 8.30e-20 2.74e-22 9.12e-23 4.47e-23 1.42e-23
#>   t_21.0 t_22.0 t_23.0  wl
#> 1      0      0      0 280
#> 2      0      0      0 281
#> 3      0      0      0 282
#> 4      0      0      0 283
#> 5      0      0      0 284
#> 6      0      0      0 285

# Calculate Pabs
(Pabs <- p_abs(res, "anthracene"))
#> [1] 430.9775

# Calculate PLC50
plc_50(Pabs, NLC50 = 450)
#> [1] 16.70798
```
