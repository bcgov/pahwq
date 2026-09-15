# Calculate the phototoxic benchmark for a given P~abs~ and PAH chemical using the PTLM

The phototoxic benchmark is the acute benchmark concentration of a
phototoxic PAH based on its narcotic toxicity (narcotic benchmark) and
calculations of site-specific or field-level light absorption.

## Usage

``` r
phototoxic_benchmark(x, pah = NULL, narc_bench = NULL, time_multiplier)
```

## Arguments

- x:

  light absorption, calculated from
  [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md), or a
  `tuv_results` data.frame from
  [`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md) or
  [`get_tuv_results()`](https://bcgov.github.io/pahwq/reference/get_tuv_results.md).

- pah:

  The PAH of interest, which is used to calculate the narcotic benchmark
  value.

- narc_bench:

  (optional) the narcotic toxicity (i.e., in the absence of light) of
  the PAH in ug/L. If supplied, takes precedence over the PAH lookup.

- time_multiplier:

  If x is a `tuv_results` data frame, this is the multiplier to get the
  total exposure time. I.e., if the tuv_results contains 24 hours of
  data, and you need a 48h exposure, the multiplier would be 2 (this is
  the default). Ignored if `x` is a numeric value of light absorption.

## Value

the phototoxic benchmark value of the PAH in ug/L.

## Details

You can either supply a specific PAH, so the narcotic benchmark can be
calculated for that chemical, or supply a narcotic benchmark value
directly.

## References

Marzooghi, S., Finch, B.E., Stubblefield, W.A., Dmitrenko, O., Neal,
S.L. and Di Toro, D.M. (2017), Phototoxic target lipid model of single
polycyclic aromatic hydrocarbons. Environ Toxicol Chem, 36: 926-937.
https://doi.org/10.1002/etc.3601

## Examples

``` r
phototoxic_benchmark(590, pah = "Benzo[a]pyrene")
#> [1] 0.09815802
phototoxic_benchmark(590, narc_bench = 450)
#> [1] 20.40962
```
