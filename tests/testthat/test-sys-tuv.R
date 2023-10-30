test_that("tuv executable gets copied to the right place on load", {
  dir <- local_tuv_dir()
  expect_true(file.exists(file.path(
    dir,
    tuv_cmd()
  )))
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
      write = FALSE
    ))
  )
  setup_tuv_options(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_km = 0.342,
    DOC = 5,
    date = "2023-06-21"
  )
  expect_true(file.exists(file.path(dir, "AQUA", "inp_aq")))
})

test_that("setup_tuv_options errors without required arguments", {
  local_tuv_dir()
  expect_snapshot(
    setup_tuv_options(),
    error = TRUE
  )
  expect_snapshot(
    setup_tuv_options(date = "2023-10-24"),
    error = TRUE
  )
  expect_snapshot(
    setup_tuv_options(date = "2023-10-24", DOC = 5),
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
    date = "2023-06-21"
  )
  tuv(quiet = TRUE)
  expect_true(all(file.exists(file.path(dir, "AQUA", tuv_out_files()))))
})

test_that("get_tuv_results works", {
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
  expect_s3_class(res, "data.frame")
})
