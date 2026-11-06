# Calculate the narcotic and phototoxic benchmarks for a set of PACs

Given the results of a TUV model run (via
[`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md) or
[`run_tuv()`](https://bcgov.github.io/pahwq/reference/run_tuv.md)), get
the narcotic benchmark, Pabs, and phototoxic benchmark for a set of PACs

## Usage

``` r
pb_multi(tuv_results, pacs, time_multiplier = 2, acr = default_acr())
```

## Arguments

- tuv_results:

  data.frame of TUV results

- pacs:

  PACs for which to calculate narcotic benchmark, Pabs, and phototoxic
  benchmark, as `pac_id` or `pac_name` values from
  [`pac_list()`](https://bcgov.github.io/pahwq/reference/pac_list.md)

- time_multiplier:

  multiplier to get the total exposure time. I.e., if the tuv_results
  contains 24 hours of data, and you need a 48h exposure, the multiplier
  would be 2. (this is the default)

- acr:

  Acute-to-Chronic Ratio that the phototoxic benchmark is divided by.
  Default 11.6.

## Value

a data.frame of `pac_id`, `pac_name`, narcotic benchmark, narcotic_cwqg,
Pabs, phototoxic benchmark, and phototoxic_cwqg for the given PACs and
TUV results. A homologue group name gives the `pac_id` of its first
parent. `pac_name` matches the guideline tables in
`inst/doc-guideline-lookup/`.

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
#>       pac_id   pac_name narcotic_benchmark narcotic_cwqg         pabs
#> 1 anthracene Anthracene           64.12872      8.954894 1141.8589103
#> 2   fluorene   Fluorene          120.50776     17.202554    0.3084483
#> 3     pyrene     Pyrene           21.24224      2.853568  513.4609060
#>   phototoxic_benchmark phototoxic_cwqg
#> 1             2.146041      0.18500349
#> 2            77.089552      6.64565102
#> 3             1.026562      0.08849672
```
