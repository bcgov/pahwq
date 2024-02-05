test_that("get_elevation works", {
  skip_if_offline()
  skip_on_cran()
  expect_type(get_elevation(-115, 53), "double")
  expect_error(get_elevation(-170, 65), "'lon' must be a numeric")
  expect_error(get_elevation(-120, 90), "'lat' must be a numeric")
  expect_error(get_elevation(-115, 43), "No altitude found")
})
