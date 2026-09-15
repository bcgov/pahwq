# Calculate the narcotic benchmark (acute) concentration for a PAH or HAC using the Target Lipid Model (TLM)

This calculates the acute water quality benchmark using the equation and
default values from Tillmanns et al 2024.

## Usage

``` r
narcotic_benchmark(chemical)
```

## Arguments

- chemical:

  The chemical (a HAC or PAH) of interest

## Value

the narcotic benchmark value of the PAH in ug/L.

## Details

The values used in the calculation are:

- **slope** The slope in Equation 2 in Tillmanns et al 2024. The default
  value is -0.922.

- **HC5** The 5th percentile of the SSD of critical body burdens
  predicted to be hazardous for no more than 5% of the species. Default
  value is 9.7 umol/g, from Equation 2 in Tillmanns et al 2024.

- **dc_pah** Chemical class correction (Δc) for PAHs, as reported in
  Tillmanns et al 2024. The default value is -0.420.

- **dc_hac** Chemical class correction (Δc) for HACs, as reported in
  Tillmanns et al 2024. The default value is -0.467.

## References

Tillmanns, A. R., McGrath, J. A., & Di Toro, D. M. (2024). International
Water Quality Guidelines for Polycyclic Aromatic Hydrocarbons: Advances
to Improve Jurisdictional Uptake of Guidelines Derived Using The Target
Lipid Model. Environmental Toxicology and Chemistry, 43(4), 686-700.

## Examples

``` r
narcotic_benchmark("anthracene")
#> [1] 64.12872
```
