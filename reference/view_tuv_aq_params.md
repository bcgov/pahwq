# View TUV aquatics options, as set by `set_tuv_aq_params()`.

This differs from
[`tuv_run_params()`](https://bcgov.github.io/pahwq/reference/tuv_run_params.md)
in that it reads the options that are currently set in the tuv
directory, while
[`tuv_run_params()`](https://bcgov.github.io/pahwq/reference/tuv_run_params.md)
tells you what inputs were used in a model run.

## Usage

``` r
view_tuv_aq_params(as_character = FALSE, tuv_dir = tuv_data_dir())
```

## Arguments

- as_character:

  Return as a character vector? Default `FALSE`, in which case it just
  prints the parameter list to the screen.

- tuv_dir:

  the directory where the compiled TUV executable is located
