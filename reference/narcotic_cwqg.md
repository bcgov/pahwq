# Calculate the narcotic guideline (chronic) concentration for a PAH or HAC using the Target Lipid Model (TLM)

This calculates the narcotic chronic water quality guideline using the
equation and default values from Tillmanns et al 2024.

## Usage

``` r
narcotic_cwqg(chemical)
```

## Arguments

- chemical:

  The chemical (a HAC or PAH) of interest

## Value

the narcotic chronic water quality guideline value of the PAH in ug/L.

## Details

The values used in the calculation are:

- **slope** The slope in Equation 3 in Tillmanns et al 2024. The default
  value is -0.951.

- **HC5** The 5th percentile of the SSD of critical body burdens
  predicted to be hazardous for no more than 5% of the species. Default
  value is 3.14 umol/g, from Equation 2 in Tillmanns et al 2024.

- **dc_pah** Chemical class correction (Δc) for PAHs, as reported in
  Tillmanns et al 2024. The default value is -0.659.

- **dc_hac** Chemical class correction (Δc) for HACs, as reported in
  Tillmanns et al 2024. The default value is -0.398.

## References

Tillmanns, A. R., McGrath, J. A., & Di Toro, D. M. (2024). International
Water Quality Guidelines for Polycyclic Aromatic Hydrocarbons: Advances
to Improve Jurisdictional Uptake of Guidelines Derived Using The Target
Lipid Model. Environmental Toxicology and Chemistry, 43(4), 686-700.

## Examples

``` r
narcotic_cwqg("anthracene")
#> [1] 8.954894
```
