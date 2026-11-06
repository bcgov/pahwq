# Calculate toxic units and hazard indexes for a monitoring sample

Calculates narcotic and phototoxic toxic units (TUs) and hazard indexes
(HIs) for the PACs measured in a sample, and their sums for the sample.

## Usage

``` r
tu_hi(concentrations, tuv_results, time_multiplier = 2, acr = default_acr())
```

## Arguments

- concentrations:

  A data frame with one row per PAC and columns:

  - `pac`: the PAC or PAC homologue group, as a `pac_name` or `pac_id`
    from
    [`pac_list()`](https://bcgov.github.io/pahwq/reference/pac_list.md).

  - `concentration_ug_L`: the concentration in ug/L. Missing values
    count as 0.

- tuv_results:

  data.frame of TUV results

- time_multiplier:

  multiplier to get the total exposure time. I.e., if the tuv_results
  contains 24 hours of data, and you need a 48h exposure, the multiplier
  would be 2. (this is the default)

- acr:

  Acute-to-Chronic Ratio that the phototoxic benchmark is divided by.
  Default 11.6.

## Value

A one-row data frame of class `tu_hi`, with the sums of `tu_narcotic`,
`tu_phototoxic`, `hi_narcotic` and `hi_phototoxic` for the sample.

The results for each PAC are in the `"pacs"` attribute: a data frame
with one row per PAC, with `pac_name`, `concentration_ug_L`, the
guidelines and `pabs` from
[`pb_multi()`](https://bcgov.github.io/pahwq/reference/pb_multi.md), and
`tu_narcotic`, `tu_phototoxic`, `hi_narcotic` and `hi_phototoxic`.

PACs that aren't recognised are dropped with a warning.

## Details

For each PAC, the concentration is divided by a guideline for the
sample's site, date and depth:

- `tu_narcotic`: the short-term narcotic guideline
  ([`narcotic_benchmark()`](https://bcgov.github.io/pahwq/reference/narcotic_benchmark.md)).

- `tu_phototoxic`: the short-term phototoxic guideline
  ([`phototoxic_benchmark()`](https://bcgov.github.io/pahwq/reference/phototoxic_benchmark.md)).

- `hi_narcotic`: the long-term narcotic guideline
  ([`narcotic_cwqg()`](https://bcgov.github.io/pahwq/reference/narcotic_cwqg.md)).

- `hi_phototoxic`: the long-term phototoxic guideline
  ([`phototoxic_cwqg()`](https://bcgov.github.io/pahwq/reference/phototoxic_cwqg.md)).

Run [`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md) with the
location, date, depth and water parameters of the sample, as the
phototoxic guidelines depend on them.

## Examples

``` r
tuv_res <- tuv(
  lat = 49.601632,
  lon = -119.605862,
  elev_m = 342,
  DOC = 5,
  date = "2023-06-21"
)

concentrations <- data.frame(
  pac = c(
    "Anthracene",
    "C1-Phenanthrenes/Anthracenes",
    "Pyrene",
    "Benzo(a)anthracene"
  ),
  concentration_ug_L = c(0.01, 0.2, NA, 0)
)

tu_hi_results <- tu_hi(concentrations, tuv_res)
#> No measured absorption spectrum for C1-Phenanthrenes/Anthracenes. Using the mean of the spectra of 9-Methylphenanthrene and 9-Methylanthracene as a surrogate.

# The sums for the sample
tu_hi_results
#> 
#> Toxic units and hazard indexes for the sample.
#> PACs: 4 (2 with a concentration above 0)
#> 
#>  tu_narcotic tu_phototoxic hi_narcotic hi_phototoxic
#>  0.009254007     0.3573531  0.06866298      4.145296
#> 
#> Results for individual PACs are in `attr(x, "pacs")`.

# The results for each PAC
attr(tu_hi_results, "pacs")
#>                       pac_name concentration_ug_L narcotic_benchmark
#> 1                   Anthracene               0.01           64.12872
#> 2 C1-Phenanthrenes/Anthracenes               0.20           21.98268
#> 3                       Pyrene               0.00           21.24224
#> 4           Benzo(a)anthracene               0.00            6.85202
#>   narcotic_cwqg     pabs phototoxic_benchmark phototoxic_cwqg  tu_narcotic
#> 1     8.9548941 3514.398            1.2699152      0.10947545 0.0001559364
#> 2     2.9609330 1959.473            0.5722812      0.04933459 0.0090980710
#> 3     2.8535677 3506.634            0.4210887      0.03630075 0.0000000000
#> 4     0.8849048 2626.820            0.1555374      0.01340840 0.0000000000
#>   tu_phototoxic hi_narcotic hi_phototoxic
#> 1   0.007874542 0.001116708    0.09134468
#> 2   0.349478545 0.067546276    4.05395112
#> 3   0.000000000 0.000000000    0.00000000
#> 4   0.000000000 0.000000000    0.00000000
```
