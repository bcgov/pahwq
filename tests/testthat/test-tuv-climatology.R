test_that("get_o3_column works", {
  expect_equal(
    get_o3_column(lat = 48, month = 6),
    359.9370
  )
})

test_that("get_aerosol_tau works", {
  expect_equal(
    round(get_aerosol_tau(lat = 48.5, lon = -138.3, month = 4), 4),
    0.1576
  )
  # Get the default value when the lookup is NaN
  expect_message(res <- get_aerosol_tau(lat = 80, lon = 138, month = 4), )
  expect_equal(res, tuv_aq_defaults()$tauaer)
})

test_that("get_aerosol_tau checks lat and lon", {
  expect_snapshot(
    error = TRUE,
    get_aerosol_tau(lat = 95, lon = -120, month = 6)
  )
  expect_snapshot(
    error = TRUE,
    get_aerosol_tau(lat = "a", lon = -120, month = 6)
  )
  expect_snapshot(
    error = TRUE,
    get_aerosol_tau(lat = 49, lon = -200, month = 6)
  )
  expect_snapshot(error = TRUE, get_aerosol_tau(lat = 49, lon = "a", month = 6))
})
