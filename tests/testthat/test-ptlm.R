test_that("plc_50 works", {
  expect_equal(plc_50(590, 450), 14.68, tolerance = 0.01)
})

# TODO: test Pabs
