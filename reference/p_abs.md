# Calculate the total light absorption of a PAH using the results of the TUV model

Calculate the total light absorption of a PAH using the results of the
TUV model

## Usage

``` r
p_abs(tuv_results, pah, time_multiplier = 2)
```

## Arguments

- tuv_results:

  data.frame of TUV results

- pah:

  name of PAH to calculate light absorption for

- time_multiplier:

  multiplier to get the total exposure time. I.e., if the tuv_results
  contains 24 hours of data, and you need a 48h exposure, the multiplier
  would be 2. (this is the default)

## Value

The value of `Pabs` for the TUV results.
