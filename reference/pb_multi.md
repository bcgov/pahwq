# Calculate the narcotic and phototoxic benchmarks for a set of PAHs

Given the results of a TUV model run (via
[`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md) or
[`run_tuv()`](https://bcgov.github.io/pahwq/reference/run_tuv.md)), get
the narcotic benchmark, Pabs, and phototoxic benchmark for a set of PAHs

## Usage

``` r
pb_multi(tuv_results, pahs, time_multiplier = 2)
```

## Arguments

- tuv_results:

  data.frame of TUV results

- pahs:

  names of PAHs for which to calculate narcotic benchmark, Pabs, and
  phototoxic benchmark

- time_multiplier:

  multiplier to get the total exposure time. I.e., if the tuv_results
  contains 24 hours of data, and you need a 48h exposure, the multiplier
  would be 2. (this is the default)

## Value

a data.frame of narcotic benchmark, narcotic_cwqg, Pabs, phototoxic
benchmark, and phototoxic_cwqg for the given PAHs and TUV results

## Examples

``` r
tuv_res <- tuv(
  depth_m = 0.25,
  lat = 49.601632,
  lon = -119.605862,
  DOC = 5,
  date = "2023-06-21"
)

pb_multi(tuv_res, c("Anthracene", "fluorene", "pyrene"))
#>          pah narcotic_benchmark narcotic_cwqg         pabs phototoxic_benchmark
#> 1 anthracene           64.12872      8.954894 1141.8593777              2.14604
#> 2   fluorene          120.50776     17.202554    0.3084483             77.08955
#> 3     pyrene           21.24224      2.853568  513.4631473              1.02656
#>   phototoxic_cwqg
#> 1      0.18500346
#> 2      6.64565103
#> 3      0.08849654
```
