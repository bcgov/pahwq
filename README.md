
<!--
Copyright 2023 Province of British Columbia
&#10;Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
&#10;http://www.apache.org/licenses/LICENSE-2.0
&#10;Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations under the License.
-->
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pahwq

Implementation of the Photoxic Lipid Model (PTLM) for the calculation of
Canadian Water Quality Guidelines for Polycyclic Aromatic Hydrocarbons
(PAH).

<!-- badges: start -->

[![R-CMD-check](https://github.com/ateucher/pahwq/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ateucher/pahwq/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This package uses the Tropospheric Ultraviolet and Visible (TUV)
Radiation Model (<https://github.com/NCAR/TUV>) to calculate the light
penetration through water of a given depth at a given location, with a
specified Dissolved Organic Carbon concentration. The light exposure is
then used (along with the PAH-specific molar absorption across a range
of wavelengths), to calculate the light absorption (Pabs) of the given
PAH at that location. This is then used to determine the PLC50.

## Installation

In order to install this package you will need a development toolchain
installed on your computer (specifically gfortran).

On a Mac, the easiest way to get started is to use
[Homebrew](https://brew.sh/):

    brew install gcc

On Windows, you need to install
[Rtools](https://cran.r-project.org/bin/windows/Rtools/). Make sure that
you install the appropriate version for your version of R (i.e. Rtools
4.0 for R 4.0.x, Rtools 4.3 for R 4.3.x, etc.).

This package is currently hosted in a private GitHub repository. As
such, you will need to authenticate with GitHub to be able to install
it:

``` r
install.packages(c("gitcreds", "devtools"))
```

Then, you will need to create a personal access token (PAT) on GitHub.
See [this article](https://happygitwithr.com/https-pat) for more
details.

``` r
usethis::create_github_token()
```

This will open a page in GitHub to create a new PAT. You can name it
whatever you want, but you will need to select at least the `repo` scope
for this package to install correctly.

Click “Generate Token” and copy the token that is generated. Then, run
the following command in R to save the token to your computer:

``` r
gitcreds::gitcreds_set() # Do not enter your token in the function call, you will be prompted for it.
```

When prompted, paste the token you copied from GitHub into the console.
This will save the token to your computer so that you can install the
package.

Then, install pahwq from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github(
    "ateucher/pahwq", 
    auth_token = gitcreds::gitcreds_get()$password
)
```

## Example usage

To calculate the acute phototoxic water quality guideline (PLC50) for
Anthracene at 0.25 m depth in Okanagan Lake on June 21, 2023, with a
measured DOC of 5 g/m^3, you can use the following code:

``` r
library(pahwq)

# Set the options for the TUV model run:
setup_tuv_options(
  depth_m = 0.25,
  lat = 49.601632,
  lon = -119.605862,
  elev_km = 0.342,
  DOC = 5,
  date = "2023-06-21",
  tzone = -8L
)

# Run the TUV model
tuv()

# Get the results
res <- get_tuv_results(file = "out_irrad_y")
head(res)
#>   wavelength_start wavelength_end Kd_lambda t_0.0 t_1.0 t_2.0 t_3.0    t_4.0
#> 1            279.5          280.5      31.5     0     0     0     0 1.67e-33
#> 2            280.5          281.5      31.0     0     0     0     0 6.22e-31
#> 3            281.5          282.5      30.4     0     0     0     0 2.60e-28
#> 4            282.5          283.5      29.9     0     0     0     0 7.11e-27
#> 5            283.5          284.5      29.3     0     0     0     0 3.90e-25
#> 6            284.5          285.5      28.8     0     0     0     0 1.39e-23
#>      t_5.0    t_6.0    t_7.0    t_8.0    t_9.0   t_10.0   t_11.0   t_12.0
#> 1 5.30e-33 1.02e-32 2.55e-32 2.53e-29 1.86e-25 3.98e-23 7.27e-22 1.83e-21
#> 2 1.97e-30 3.85e-30 9.87e-30 7.49e-27 2.47e-23 3.32e-21 4.73e-20 1.10e-19
#> 3 8.25e-28 1.63e-27 4.32e-27 2.46e-24 3.58e-21 2.98e-19 3.31e-18 7.13e-18
#> 4 2.26e-26 4.48e-26 1.22e-25 5.87e-23 5.37e-20 3.40e-18 3.26e-17 6.72e-17
#> 5 1.24e-24 2.49e-24 7.03e-24 2.67e-21 1.31e-18 5.79e-17 4.57e-16 8.87e-16
#> 6 4.43e-23 9.02e-23 2.69e-22 7.79e-20 2.02e-17 6.12e-16 3.96e-15 7.21e-15
#>     t_13.0   t_14.0   t_15.0   t_16.0   t_17.0   t_18.0   t_19.0   t_20.0
#> 1 7.38e-22 4.12e-23 1.97e-25 2.78e-29 2.59e-32 1.03e-32 5.33e-33 1.70e-33
#> 2 4.80e-20 3.42e-21 2.60e-23 8.16e-27 9.99e-30 3.87e-30 1.99e-30 6.33e-31
#> 3 3.35e-18 3.07e-19 3.76e-21 2.66e-24 4.37e-27 1.64e-27 8.30e-28 2.65e-28
#> 4 3.30e-17 3.50e-18 5.62e-20 6.31e-23 1.23e-25 4.51e-26 2.27e-26 7.23e-27
#> 5 4.63e-16 5.93e-17 1.37e-18 2.85e-21 7.14e-24 2.50e-24 1.25e-24 3.97e-25
#> 6 4.00e-15 6.25e-16 2.10e-17 8.26e-20 2.73e-22 9.08e-23 4.45e-23 1.41e-23
#>   t_21.0 t_22.0 t_23.0  wl
#> 1      0      0      0 280
#> 2      0      0      0 281
#> 3      0      0      0 282
#> 4      0      0      0 283
#> 5      0      0      0 284
#> 6      0      0      0 285

# Calculate Pabs for Anthracene from the TUV results.
(Pabs <- p_abs(res, "Anthracene"))
#> [1] 426.9667

# Calculate PLC50
plc_50(Pabs, NLC50 = 450)
#> [1] 16.77217
```

### Options

pahwq creates a directory on your computer to store the TUV model input
and output files. By default, the location of this is set automatically
to a standard location (determined by `tools::R_user_dir`). You can
change the location of this directory by setting the
`pahwq.tuv_data_dir` option:

``` r
options("pahwq.tuv_data_dir" = "path/to/my/tuv/data")
```

### Getting Help or Reporting an Issue

To report bugs/issues/feature requests, please file an
[issue](https://github.com/bcgov/pahwq/issues/).

### How to Contribute

If you would like to contribute to the package, please see our
[CONTRIBUTING](CONTRIBUTING.md) guidelines.

Please note that this project is released with a [Contributor Code of
Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree
to abide by its terms.

### License

    Copyright 2023 Province of British Columbia

    Licensed under the Apache License, Version 2.0 (the &quot;License&quot;);
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an &quot;AS IS&quot; BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and limitations under the License.
