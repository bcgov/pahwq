# Match names to PACs

Finds the PAC or PAC homologue group for each name, as functions such as
[`tu_hi()`](https://bcgov.github.io/pahwq/reference/tu_hi.md) do. A name
can be a `pac` or `chemical` name from
[`pac_list()`](https://bcgov.github.io/pahwq/reference/pac_list.md).
Differences in case, leading and trailing whitespace, spaces around
hyphens, and brackets are ignored (e.g., `" Benzo[a]pyrene"` matches
`"Benzo(a)pyrene"`).

## Usage

``` r
match_pac(x)
```

## Arguments

- x:

  A character vector of names.

## Value

A character vector the same length as `x`, with the `pac` name from
[`pac_list()`](https://bcgov.github.io/pahwq/reference/pac_list.md) for
each name, or `NA` if there is no match.

## Details

Both parents of a homologue group match the group, so names that match
the same PAC can be found with
[`duplicated()`](https://rdrr.io/r/base/duplicated.html).

## Examples

``` r
match_pac(c("Benzo[a]pyrene", "c1-anthracenes", "not a PAC"))
#> [1] "Benzo(a)pyrene"               "C1-Phenanthrenes/Anthracenes"
#> [3] NA                            
```
