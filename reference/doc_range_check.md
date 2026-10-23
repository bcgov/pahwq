# Valid range of DOC concentrations

`doc_range()` returns the minimum and maximum DOC concentrations for
which the Kd model is valid. `doc_range_check()` checks a DOC value
against that range, and replaces it with the nearest limit (with a
warning) if it falls outside.

## Usage

``` r
doc_range_check(DOC)

doc_range()
```

## Arguments

- DOC:

  DOC in g/m^3

## Value

`doc_range()` returns a numeric vector of length two: the minimum and
maximum valid DOC in g/m^3. `doc_range_check()` returns `DOC`, or the
nearest limit if `DOC` is outside the valid range.

## Examples

``` r
doc_range()
#> [1]  0.20 61.45
doc_range_check(5)
#> [1] 5
doc_range_check(100)
#> Warning: DOC value supplied is greater than the maximum valid DOC. Replacing with 61.45
#> [1] 61.45
```
