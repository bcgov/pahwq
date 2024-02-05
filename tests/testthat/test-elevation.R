test_that("get_elevation works, NRCAN API", {
  skip_if_offline()

  expect_type(get_elevation(-115, 53), "double") # NRCAN
  expect_error(get_elevation(-170, 65), "'lon' must be a numeric")
  expect_error(get_elevation(-120, 90), "'lat' must be a numeric")
  expect_error(get_elevation(-115, 21), "'lat' must be a numeric")

})

test_that("get_elevation works, USGS EPQS API", {
  skip_if_offline()
  skip_on_ci()
  skip()

  expect_type(get_elevation(-101, 44), "double") # USGS - really unreliable
  # Pacific Ocean Canada:
  expect_error(get_elevation(-130, 50))
})
