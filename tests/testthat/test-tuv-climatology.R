test_that("get_o3_column works", {
  expect_equal(
    get_o3_column(lat = 48, month = 6),
    359.9370
  )
})

test_that("get_aerpsol_tau works", {
  expect_equal(
    get_aerosol_tau(lat = 48.5, lon = -138.3, month = 4),
    0.2442
  )
  # Get the default value when the lookup is NaN
  expect_equal(
    get_aerosol_tau(lat = 36, lon = 138, month = 4),
    tuv_aq_defaults()$tauaer
  )
})
