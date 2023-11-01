# Copyright 2023 Province of British Columbia
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License. You may obtain a copy of
# the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under
# the License.

test_that("plc_50 works", {
  expect_equal(plc_50(590, 450), 14.68, tolerance = 0.01)
})

test_that("The whole shebang works", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  pabs <- p_abs(res, "Anthracene")
  expect_equal(pabs, 430.86, tolerance = 0.01)
  expect_equal(plc_50(pabs, NLC50 = 450), 16.71, tolerance = 0.01)
})

test_that("Specifying wavelengths for specific PAHs is not necessary", {
  # This is because molar_absorption data frame has 0s where the absorption
  # is zero, so multiplying by zero will give zero.
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_s3_class(res, "data.frame")
  pabs <- p_abs(res, "Fluorene")
  expect_equal(pabs, 0.0306, tolerance = 0.01)

  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21",
    wvl_start = 280, # specific range in which we know Fluorene absorbs
    wvl_end = 310,
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_s3_class(res, "data.frame")
  pabs2 <- p_abs(res, "Fluorene")
  expect_equal(pabs, pabs2, tolerance = 0.01)
})

test_that("Dibenxo[ah]anthracene (gaps in molar_absorption range)", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_s3_class(res, "data.frame")
  pabs <- p_abs(res, "Dibenzo[ah]anthracene")
  expect_equal(pabs, 184.445, tolerance = 0.01)
})
