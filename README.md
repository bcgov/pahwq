
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

<!-- badges: start -->

[![R-CMD-check](https://github.com/bcgov/pahwq/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bcgov/pahwq/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/bcgov/pahwq/branch/main/graph/badge.svg)](https://app.codecov.io/gh/bcgov/pahwq?branch=main)
<!-- badges: end -->

## Overview

Implementation of the Photoxic Lipid Model (PTLM) for the calculation of
Canadian Water Quality Guidelines for Polycyclic Aromatic Hydrocarbons
(PAH).

This package uses the Tropospheric Ultraviolet and Visible (TUV)
Radiation Model (<https://github.com/NCAR/TUV>) to calculate the light
penetration through water of a given depth at a given location, with a
specified Dissolved Organic Carbon concentration. The light exposure is
then used (along with the PAH-specific molar absorption across a range
of wavelengths), to calculate the light absorption (Pabs) of the given
PAH at that location. This is then used to determine the PLC50.

## Installation

In order to install this package you will need a development toolchain
installed on your computer (specifically `gfortran`) to compile the
Fortran code for the TUV model.

On a Mac, the easiest way to get started is to use
[Homebrew](https://brew.sh/), and install `gcc`, which includes
`gfortran`:

    brew install gcc

On Windows, you need to install
[Rtools](https://cran.r-project.org/bin/windows/Rtools/). Make sure that
you install the appropriate version for your version of R (i.e. Rtools
4.0 for R 4.0.x, Rtools 4.3 for R 4.3.x, etc.).

Once you have Rtools (Windows) or `gcc` (Mac), you can install the
package with:

``` r
# install.packages("devtools")
devtools::install_github("bcgov/pahwq")
```

## Example usage

To calculate the acute phototoxic water quality guideline (PLC50) for
Anthracene at 0.25 m depth in Okanagan Lake on June 21, 2023, with a
measured DOC of 5 g/m^3, you can use the following code:

``` r
library(pahwq)

# Set the options for the TUV model run:
set_tuv_aq_params(
  depth_m = 0.25,
  lat = 49.601632,
  lon = -119.605862,
  elev_km = 0.342,
  DOC = 5,
  date = "2023-06-21",
  tzone = -8L
)

# Run the TUV model
run_tuv()

# Get the results
res <- get_tuv_results(file = "out_irrad_y")
head(res)
#>    wl wavelength_start wavelength_end Kd_lambda t_00.00.00 t_01.00.00
#> 1 280            279.5          280.5      31.5          0          0
#> 2 281            280.5          281.5      31.0          0          0
#> 3 282            281.5          282.5      30.4          0          0
#> 4 283            282.5          283.5      29.9          0          0
#> 5 284            283.5          284.5      29.3          0          0
#> 6 285            284.5          285.5      28.8          0          0
#>   t_02.00.00 t_03.00.00 t_04.00.00 t_05.00.00 t_06.00.00 t_07.00.00 t_08.00.00
#> 1          0          0   2.87e-38   9.14e-38   1.74e-37   4.16e-37   7.37e-34
#> 2          0          0   2.92e-35   9.28e-35   1.78e-34   4.35e-34   5.71e-31
#> 3          0          0   3.41e-32   1.08e-31   2.09e-31   5.27e-31   5.02e-28
#> 4          0          0   1.67e-30   5.31e-30   1.03e-29   2.65e-29   2.10e-26
#> 5          0          0   2.00e-28   6.35e-28   1.25e-27   3.31e-27   2.02e-24
#> 6          0          0   1.60e-26   5.07e-26   1.01e-25   2.79e-25   1.28e-22
#>   t_09.00.00 t_10.00.00 t_11.00.00 t_12.00.00 t_13.00.00 t_14.00.00 t_15.00.00
#> 1   3.08e-29   1.80e-26   5.57e-25   1.66e-24   5.68e-25   1.88e-26   3.30e-29
#> 2   9.11e-27   3.05e-24   7.02e-23   1.90e-22   7.14e-23   3.17e-24   9.71e-27
#> 3   3.00e-24   5.67e-22   9.64e-21   2.38e-20   9.79e-21   5.86e-22   3.17e-24
#> 4   7.18e-23   9.78e-21   1.40e-19   3.26e-19   1.42e-19   1.01e-20   7.57e-23
#> 5   3.28e-21   2.89e-19   3.28e-18   7.12e-18   3.32e-18   2.97e-19   3.44e-21
#> 6   9.60e-20   5.39e-18   4.82e-17   9.72e-17   4.88e-17   5.53e-18   1.00e-19
#>   t_16.00.00 t_17.00.00 t_18.00.00 t_19.00.00 t_20.00.00 t_21.00.00 t_22.00.00
#> 1   8.25e-34   4.20e-37   1.75e-37   9.19e-38   2.92e-38          0          0
#> 2   6.33e-31   4.41e-34   1.79e-34   9.33e-35   2.97e-35          0          0
#> 3   5.50e-28   5.33e-31   2.10e-31   1.09e-31   3.47e-32          0          0
#> 4   2.29e-26   2.69e-29   1.04e-29   5.34e-30   1.70e-30          0          0
#> 5   2.16e-24   3.35e-27   1.26e-27   6.39e-28   2.04e-28          0          0
#> 6   1.37e-22   2.83e-25   1.02e-25   5.10e-26   1.63e-26          0          0
#>   t_23.00.00
#> 1          0
#> 2          0
#> 3          0
#> 4          0
#> 5          0
#> 6          0

# Calculate Pabs for Anthracene from the TUV results.
(Pabs <- p_abs(res, "Anthracene"))
#> [1] 426.6752

# Calculate PLC50
plc_50(Pabs, NLC50 = 450)
#> [1] 16.77687
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
