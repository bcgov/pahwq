# Package index

## Core TUV functions

- [`tuv()`](https://bcgov.github.io/pahwq/reference/tuv.md) : Run the
  TUV model with specified options
- [`set_tuv_aq_params()`](https://bcgov.github.io/pahwq/reference/set_tuv_aq_params.md)
  : Set required and optional aquatic parameters for TUV prior to
  running the model
- [`run_tuv()`](https://bcgov.github.io/pahwq/reference/run_tuv.md) :
  Run the TUV program
- [`get_tuv_results()`](https://bcgov.github.io/pahwq/reference/get_tuv_results.md)
  : Retrieve the results of a TUV run

## PTLM

- [`p_abs()`](https://bcgov.github.io/pahwq/reference/p_abs.md) :
  Calculate the total light absorption of a PAH using the results of the
  TUV model

- [`narcotic_benchmark()`](https://bcgov.github.io/pahwq/reference/narcotic_benchmark.md)
  : Calculate the narcotic benchmark (acute) concentration for a PAH or
  HAC using the Target Lipid Model (TLM)

- [`phototoxic_benchmark()`](https://bcgov.github.io/pahwq/reference/phototoxic_benchmark.md)
  : Calculate the phototoxic benchmark for a given P~abs~ and PAH
  chemical using the PTLM

- [`narcotic_cwqg()`](https://bcgov.github.io/pahwq/reference/narcotic_cwqg.md)
  : Calculate the narcotic guideline (chronic) concentration for a PAH
  or HAC using the Target Lipid Model (TLM)

- [`phototoxic_cwqg()`](https://bcgov.github.io/pahwq/reference/phototoxic_cwqg.md)
  : Calculate the phototoxic CWQG for a given P~abs~ and PAH chemical
  using the PTLM

- [`pb_multi()`](https://bcgov.github.io/pahwq/reference/pb_multi.md) :
  Calculate the narcotic and phototoxic benchmarks for a set of PAHs

- [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md)
  : Sensitivity analysis for DOC, depth, and time of year

- [`plot_sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/plot_sens_kd_depth.md)
  :

  Make a heatmap of the sensitivity analysis performed by
  [`sens_kd_depth()`](https://bcgov.github.io/pahwq/reference/sens_kd_depth.md)

- [`p_abs_single()`](https://bcgov.github.io/pahwq/reference/p_abs_single.md)
  : Calculate the light absorption of a PAH from a single exposure
  experiment

## TUV utilities

- [`get_elevation()`](https://bcgov.github.io/pahwq/reference/get_elevation.md)
  : Get elevation for a lon/lat pair

- [`tuv_aq_defaults()`](https://bcgov.github.io/pahwq/reference/tuv_aq_defaults.md)
  : Get a list of TUV inputs and their default values

- [`kd_305()`](https://bcgov.github.io/pahwq/reference/kd_305.md) :
  Calculate Kd at 305 nm for a given Dissolved Organic Carbon (DOC)
  concentration.

- [`kd_lambda()`](https://bcgov.github.io/pahwq/reference/kd_lambda.md)
  : Calculate Kd at a given wavelength and DOC concentration.

- [`kd_marine()`](https://bcgov.github.io/pahwq/reference/kd_marine.md)
  : Calculate Kd at a given wavelength in marine waters.

- [`view_tuv_aq_params()`](https://bcgov.github.io/pahwq/reference/view_tuv_aq_params.md)
  :

  View TUV aquatics options, as set by
  [`set_tuv_aq_params()`](https://bcgov.github.io/pahwq/reference/set_tuv_aq_params.md).

- [`tuv_run_params()`](https://bcgov.github.io/pahwq/reference/tuv_run_params.md)
  : Show the input parameters used for a TUV model run

- [`list_tuv_dir()`](https://bcgov.github.io/pahwq/reference/list_tuv_dir.md)
  : List files in the directory containing the TUV files

- [`clean_tuv_dir()`](https://bcgov.github.io/pahwq/reference/clean_tuv_dir.md)
  : Delete the directory containing the TUV files
