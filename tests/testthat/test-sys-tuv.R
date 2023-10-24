test_that("setup_tuv_options() works with minimal specifications", {
  local_mocked_bindings(check_tuv_dir = function(tuv_dir) invisible(NULL))
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
})

test_that("setup_tuv_options errors without required arguments", {
  local_mocked_bindings(check_tuv_dir = function(tuv_dir) invisible(NULL))
  expect_snapshot(setup_tuv_options(), error = TRUE)
  expect_snapshot(setup_tuv_options(date = "2023-10-24"), error = TRUE)
  expect_snapshot(setup_tuv_options(date = "2023-10-24", DOC = 5), error = TRUE)
})
