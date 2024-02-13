test_that("plc50_multi works", {
  local_tuv_dir()
  tuv_results <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )
  pahs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  res <- plc50_multi(tuv_results, pahs)
  expect_s3_class(res, "data.frame")
  expect_equal(nrow(res), 3)
  expect_equal(ncol(res), 4)

  expect_equal(res$pah, tolower(pahs))
  expect_equal(
    vapply(pahs, nlc50, FUN.VALUE = numeric(1), USE.NAMES = FALSE),
    res$nlc50
  )
  expect_equal(
    vapply(pahs, \(x) p_abs(tuv_results, x), FUN.VALUE = numeric(1), USE.NAMES = FALSE),
    res$pabs
  )
  expect_equal(
    vapply(pahs, \(x) plc50(tuv_results, x), FUN.VALUE = numeric(1), USE.NAMES = FALSE),
    res$plc50
  )
})

test_that("plc50_multi passes on arguments appropriately", {
  local_tuv_dir()
  tuv_results <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )
  pahs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  res <- plc50_multi(tuv_results, pahs)

  # time_muliplier - passed to Pabs
  res2 <- plc50_multi(tuv_results, pahs, time_multiplier = 1)
  expect_equal(res2$pabs * 2, res$pabs)
  expect_equal(res2$nlc50, res$nlc50)
  expect_true(all(res2$plc50 > res$plc50))

  # slope - passed to nlc50 via ...
  res3 <- plc50_multi(tuv_results, pahs, slope = -0.5)
  expect_true(all(res3$nlc50 > res$nlc50))
})

test_that("plc50_multi errors correctly", {
  local_tuv_dir()
  tuv_results <- tuv(
    depth_m = 0.25,
    lat = 49.601632,
    lon = -119.605862,
    elev_m = 342,
    DOC = 5,
    date = "2023-06-21",
    quiet = TRUE
  )

  pahs <- c("Anthracene", "benzo(a)pyrene", "acenaphthene")
  expect_snapshot(plc50_multi(5, pahs), error = TRUE)
  expect_snapshot(plc50_multi(tuv_results, c(pahs, "foo")), error = TRUE)
})
