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

test_that("plc50 works", {
  expect_snapshot(
    round(plc50(590, NLC50 = 450), 2)
  )

  expect_snapshot(
    round(plc50(590, pah = "Benzo(a)pyrene"), 2)
  )

  expect_snapshot(
    round(plc50(590, pah = "Benzo(a)pyrene", NLC50 = 450), 2)
  )

  expect_snapshot(plc50(590), error = TRUE)
  expect_snapshot(plc50(590, pah = "foo"), error = TRUE)
})

test_that("plc50 deals with time multiplier", {
  expect_silent(
    plc50(590, NLC50 = 450)
  )

  expect_warning(
    plc50(590, NLC50 = 450, time_multiplier = 2)
  )

  local_tuv_dir()
  skip_if_offline() # Looks up elevation from web service
  res <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    DOC = 5,
    date = "2023-06-21"
  )

  expect_equal(
    plc50(res, "Anthracene", time_multiplier = 2),
    plc50(res, "Anthracene")
  )

  expect_equal(
    plc50(res, "Anthracene", time_multiplier = 4),
    plc50(p_abs(res, "Anthracene", time_multiplier = 4), "Anthracene")
  )
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
  skip_if_offline() # Looks up elevation from web service
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  pabs <- p_abs(res, "Anthracene")
  expect_snapshot(round(pabs, 3))
  expect_snapshot(
    round(plc50(pabs, pah = "Anthracene"), 2)
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
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_s3_class(res, "data.frame")
  pabs <- p_abs(res, "Fluorene")
  expect_snapshot(round(pabs, 2))

  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
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

test_that("Dibenzo[ah]anthracene (gaps in molar_absorption range)", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_s3_class(res, "data.frame")
  pabs <- p_abs(res, "Dibenzo(ah)anthracene")
  expect_snapshot(round(pabs, 2))
})

test_that("Setting o3_tc explicitly overrides the internal lookup", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    o3_tc = 300.0
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  pabs <- p_abs(res, "Anthracene")

  expect_snapshot(round(pabs, 1))
  expect_snapshot(round(plc50(pabs, NLC50 = 450), 2))
})

test_that("Setting Kd_ref and Kd_wvl works", {
  local_tuv_dir()
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    Kd_ref = 40,
    Kd_wvl = 280,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  pabs <- p_abs(res, "Anthracene")
  expect_snapshot(round(pabs, 2))
  expect_snapshot(round(plc50(pabs, NLC50 = 450), 2))
})

test_that("The whole shebang works with a chemical using surrogates", {
  local_tuv_dir()
  skip_if_offline() # Looks up elevation from web service
  set_tuv_aq_params(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    DOC = 5,
    date = "2023-06-21"
  )
  run_tuv(quiet = TRUE)
  res <- get_tuv_results(file = "out_irrad_y")
  expect_message(
    pabs <- p_abs(res, "C1 Pyrenes"),
    "fluoranthene"
  )
  expect_snapshot(round(pabs, 3))
  expect_snapshot(
    round(plc50(pabs, pah = "C1 Pyrenes"), 2)
  )

  expect_message(
    pabs <- p_abs(res, "C3 Naphthalenes"),
    "1,6,7-trimethylnaphthalene"
  )
  expect_snapshot(round(pabs, 3))
  expect_snapshot(
    round(plc50(pabs, pah = "C3 Naphthalenes"), 2)
  )
})

test_that("p_abs_single works", {
  set.seed(42)
  df <- data.frame(
    wl = 280:700,
    i = rexp(421, 0.75)
  )

  expect_equal(
    round(p_abs_single(df, "anthracene", 1), 5),
    0.00168
  )

  expect_equal(
    round(p_abs_single(df, "anthracene", irrad_units = "W / m^2 / nm"), 5),
    0.16784
  )

  expect_equal(
    # 8 hours
    round(p_abs_single(df, "anthracene", 3600*8), 5),
    48.33764
  )

  expect_error(
    round(p_abs_single(df, "anthracene", irrad_units = "foo"), 5),
    "'arg' should be one of"
  )

  expect_error(
    round(p_abs_single(list(), "anthracene"), 5),
    "'exposure' must be"
  )

  expect_error(
    round(p_abs_single(data.frame(wl = "a", i = 5), "anthracene"), 5),
    "'wl' column must be numeric"
  )

  expect_error(
    round(p_abs_single(data.frame(wl = 1, i = "a"), "anthracene"), 5),
    "Column 2 must be numeric"
  )

})
