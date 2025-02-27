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

test_that("phototoxic_benchmark works", {
  expect_snapshot(
    round(phototoxic_benchmark(590, narc_bench = 450), 2)
  )

  expect_snapshot(
    round(phototoxic_benchmark(590, pah = "Benzo(a)pyrene"), 2)
  )

  expect_snapshot(
    round(
      phototoxic_benchmark(590, pah = "Benzo(a)pyrene", narc_bench = 450),
      2
    )
  )

  expect_snapshot(phototoxic_benchmark(590), error = TRUE)
  expect_snapshot(phototoxic_benchmark(590, pah = "foo"), error = TRUE)
})

test_that("phototoxic_benchmark deals with time multiplier", {
  expect_silent(
    phototoxic_benchmark(590, narc_bench = 450)
  )

  expect_warning(
    phototoxic_benchmark(590, narc_bench = 450, time_multiplier = 2)
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
    phototoxic_benchmark(res, "Anthracene", time_multiplier = 2),
    phototoxic_benchmark(res, "Anthracene")
  )

  expect_equal(
    phototoxic_benchmark(res, "Anthracene", time_multiplier = 4),
    phototoxic_benchmark(
      p_abs(res, "Anthracene", time_multiplier = 4),
      "Anthracene"
    )
  )
})

test_that("narcotic_benchmark works", {
  expect_snapshot(
    round(narcotic_benchmark("C1-Chrysenes"), 2)
  )
  expect_snapshot(
    round(narcotic_benchmark("fluorene"), 2)
  )
})

test_that("Pabs errors correctly", {
  expect_error(p_abs(1, "Anthracene"), "tuv_results")
  expect_error(
    p_abs(
      structure(list(), class = c("tuv_results", "data.frame")),
      "foo"
    ),
    "must be one of"
  )
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
    round(phototoxic_benchmark(pabs, pah = "Anthracene"), 2)
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
  expect_snapshot(round(phototoxic_benchmark(pabs, narc_bench = 450), 2))
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
  expect_snapshot(round(phototoxic_benchmark(pabs, narc_bench = 450), 2))
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
    round(phototoxic_benchmark(pabs, pah = "C1 Pyrenes"), 2)
  )

  expect_message(
    pabs <- p_abs(res, "C3 Naphthalenes"),
    "1,6,7-trimethylnaphthalene"
  )
  expect_snapshot(round(pabs, 3))
  expect_snapshot(
    round(phototoxic_benchmark(pabs, pah = "C3 Naphthalenes"), 2)
  )
})

test_that("p_abs_single works", {
  set.seed(42)
  df <- data.frame(
    wl = 280:800,
    i = rexp(521, 0.75)
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
    round(p_abs_single(df, "anthracene", 3600 * 8), 5),
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

test_that("p_abs_single() works when wavelength diffs > 1", {
  df <- data.frame(
    wl = c(305, 320, 380, 400, 401, 402),
    i = c(0.19, 7.40, 2.60, 205.00, 205.00, 205.00)
  )

  expect_equal(round(p_abs_single(df, "anthracene"), 5), 0.00318)
})

test_that("narcotic_cwqg works", {
  expect_type(narcotic_cwqg("Anthracene"), "double")
  expect_snapshot(round(narcotic_cwqg("Anthracene")))
  expect_lt(narcotic_cwqg("Anthracene"), narcotic_benchmark("Anthracene"))
})

test_that("phototoxic_cwqg works", {
  expect_snapshot(
    round(phototoxic_cwqg(590, narc_bench = 450), 2)
  )

  expect_snapshot(
    round(phototoxic_cwqg(590, pah = "Benzo(a)pyrene"), 2)
  )

  expect_snapshot(
    round(phototoxic_cwqg(590, pah = "Benzo(a)pyrene", narc_bench = 450), 2)
  )

  expect_snapshot(phototoxic_cwqg(590), error = TRUE)
  expect_snapshot(phototoxic_cwqg(590, pah = "foo"), error = TRUE)
})

test_that("phototoxic_cwqg works with tuv results", {
  local_tuv_dir()
  skip_if_offline() # Looks up elevation from web service
  res <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    DOC = 5,
    date = "2023-06-21"
  )

  expect_snapshot(
    round(phototoxic_cwqg(res, "Anthracene"), 3)
  )

  expect_equal(
    phototoxic_cwqg(res, "Anthracene") * acr(),
    phototoxic_benchmark(res, "Anthracene")
  )
})

test_that("phototoxic_cwqg works with tuv results (Added chemicals to nlc50, #53); ", {
  local_tuv_dir()
  skip_if_offline() # Looks up elevation from web service
  res <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    DOC = 5,
    date = "2023-06-21"
  )

  expect_snapshot(
    round(phototoxic_cwqg(res, "retene"), 3)
  )

  expect_equal(
    phototoxic_cwqg(res, "C2-benzopyrenes") * acr(),
    phototoxic_benchmark(res, "C2-benzopyrenes")
  )
})
