# Run the TUV program

You must set tuv parameters by calling
[`set_tuv_aq_params()`](https://bcgov.github.io/pahwq/reference/set_tuv_aq_params.md)
before calling `run_tuv()`

## Usage

``` r
run_tuv(tuv_dir = tuv_data_dir(), quiet = FALSE)
```

## Arguments

- tuv_dir:

  the directory where the compiled TUV executable is located

- quiet:

  Should the progress of the TUV program be printed to the console?
