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
  expect_equal(
    round(plc_50(590, NLC50 = 450), 2),
    14.68
  )

  expect_equal(
    round(plc_50(590, pah = "Benzo[a]pyrene"), 2),
    0.06
  )

  expect_equal(
    round(plc_50(590, pah = "Benzo[a]pyrene", NLC50 = 450), 2),
    14.68
  )

  expect_snapshot(plc_50(590), error = TRUE)
  expect_snapshot(plc_50(590, pah = "foo"), error = TRUE)
})

test_that("nlc50 works",{
  expect_equal(
    round(nlc50("C1-Chrysenes"), 2),
    1.48
  )
  expect_equal(
    round(nlc50("fluorene"), 2),
    111.27
  )
})

test_that("Pabs errors correctly", {
  expect_error(p_abs(1, "Anthracene"), "tuv_results")
  expect_error(p_abs(
    structure(list(), class = c("tuv_results", "data.frame")),
    "foo"
    ), "must be one of")
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
  expect_equal(round(pabs, 3), 450.972)
  expect_equal(
    round(plc_50(pabs, pah = "Anthracene"), 2),
    2.13
  )
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
  expect_equal(round(pabs, 2), 0.02)

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
  expect_equal(pabs, pabs2)
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
  expect_equal(round(pabs, 2), 194.07)
})

test_that("Setting o3_tc explicitly overrides the internal lookup", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21",
    o3_tc = 300.0
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  pabs <- p_abs(res, "Anthracene")
  expect_equal(round(pabs, 2), 451.28)
  expect_equal(round(plc_50(pabs, NLC50 = 450), 2), 16.40)
})

test_that("Setting Kd_ref and Kd_wvl works", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    Kd_ref = 40,
    Kd_wvl = 280,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  pabs <- p_abs(res, "Anthracene")
  expect_equal(round(pabs, 2), 273.99)
  expect_equal(round(plc_50(pabs, NLC50 = 450), 2), 20.11)
})

