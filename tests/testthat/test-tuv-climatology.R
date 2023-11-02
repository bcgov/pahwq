test_that("get_o3_column works", {
  expect_equal(
    get_o3_column(lat = 48, month = 6),
    359.9370
  )
})
