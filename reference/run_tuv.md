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

## Value

The exit status of the TUV program (`0`), invisibly. It is an error if
the program can't be run or fails. Output from any earlier run is
deleted first, so it can't be mistaken for the results of this one.
