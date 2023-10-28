test_that("tuv executable gets copied to the right place on load", {
  dir <- local_tuv_dir()
  expect_true(file.exists(file.path(dir, "tuv")))
})

test_that("setup_tuv_options() works with minimal specifications", {
  dir <- local_tuv_dir()
  expect_snapshot(
    print(setup_tuv_options(
      depth_m = 0.25,
      lat = 49.601632,
      lon = -119.605862,
      elev_km = 0.342,
      DOC = 5,
      date = "2023-06-21",
      write = FALSE,
      tuv_dir = dir
    ))
  )
  setup_tuv_options(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21",
    tuv_dir = dir
  )
  expect_true(file.exists(file.path(dir, "AQUA", "inp_aq")))
})

test_that("setup_tuv_options errors without required arguments", {
  dir <- local_tuv_dir()
  expect_snapshot(
    setup_tuv_options(tuv_dir = dir),
    error = TRUE
  )
  expect_snapshot(
    setup_tuv_options(date = "2023-10-24", tuv_dir = dir),
    error = TRUE
  )
  expect_snapshot(
    setup_tuv_options(date = "2023-10-24", DOC = 5, tuv_dir = dir),
    error = TRUE
  )
})


test_that("tuv works", {
  dir <- local_tuv_dir()
  setup_tuv_options(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21",
    tuv_dir = dir
  )
  tuv(tuv_dir = dir)
  expect_true(all(file.exists(file.path(dir, "AQUA", tuv_out_files()))))
})

test_that("get_tuv_results works", {
  dir <- local_tuv_dir()
  setup_tuv_options(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21",
    tuv_dir = dir
  )
  tuv(tuv_dir = dir)
  res <- get_tuv_results(file = "out_irrad_y", tuv_dir = dir)
  expect_s3_class(res, "data.frame")
})
