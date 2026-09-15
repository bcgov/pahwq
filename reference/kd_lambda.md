# Calculate Kd at a given wavelength and DOC concentration.

Note this function is not used inside the package as the same
calculation is done by the Fortran TUV model. It is present here for
demonstration purposes.

## Usage

``` r
kd_lambda(DOC, wavelength)
```

## Arguments

- DOC:

  DOC in g/m^3

- wavelength:

  lambda wavelength in nm

## Value

A numeric vector representing Kd at a given wavelength

## Examples

``` r
kd_lambda(10, 400)
#>  400 
#> 4.75 
```
