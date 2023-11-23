test_that("get_o3_column works", {
  expect_equal(
    get_o3_column(lat = 48, month = 6),
    359.9370
  )
})

test_that("get_aerpsol_tau works", {
  expect_equal(
    round(get_aerosol_tau(lat = 48.5, lon = -138.3, month = 4), 4),
    0.1576
  )
  # Get the default value when the lookup is NaN
  expect_message(res <- get_aerosol_tau(lat = 80, lon = 138, month = 4),)
  expect_equal(res, tuv_aq_defaults()$tauaer)
})
