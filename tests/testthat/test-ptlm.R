# Copyright 2023 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and limitations under the License.

test_that("plc_50 works", {
  expect_equal(plc_50(590, 450), 14.68, tolerance = 0.01)
})

test_that("The whole shebang works", {
  local_tuv_dir()
  setup_tuv_options(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_equal(pabs <- p_abs(res, "Anthracene"), 430.86, tolerance = 0.01)
  expect_equal(plc_50(pabs, NLC50 = 450), 16.71, tolerance = 0.01)
})

# TODO: test Pabs
