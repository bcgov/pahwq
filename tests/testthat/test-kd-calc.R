test_that("kd_305 works at extremes of DOC", {
  expect_equal(kd_305(0.2), 0.51, tolerance = 0.01)
  expect_equal(kd_305(10), 47.00, tolerance = 0.01)
  expect_equal(kd_305(23), 130.70, tolerance = 0.01)
})

test_that("kd_lambda works at extremes of wavelengths", {
  expect_equal(kd_lambda(10, 280), 73.71, tolerance = 0.01)
  expect_equal(kd_lambda(10, 305), 47.00, tolerance = 0.01)
  expect_equal(kd_lambda(10, 400), 8.501, tolerance = 0.01)
})
